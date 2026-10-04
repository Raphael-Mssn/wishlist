#!/usr/bin/env python3
"""Compare les sources de prévisualisation de lien (titre + image) pour Wishy.

Pour chaque URL produit, mesure :
  - direct    : fetch HTML + og:title / og:image, comme l'Edge Function link-preview
  - microlink : api.microlink.io, plan gratuit sans clé (fallback actuel)
  - jina      : r.jina.ai en mode JSON, sans clé, moteur par défaut
  - jina-direct : r.jina.ai avec `X-Engine: direct` (sans navigateur headless)

Une image n'est comptée comme trouvée que si elle se télécharge et fait plus de
500 octets, avec une signature d'image reconnue, comme le fait l'app
(link_preview_client.dart). Un placeholder 1x1 ou une URL data: ne compte pas.

Usage : python3 benchmark.py [--skip microlink] > results.json
Pas de dépendance hors bibliothèque standard. Quotas : Microlink 25 req/jour,
Jina 20 req/min (sans clé) ; le script espace les appels Jina.
"""
import argparse, html, json, re, sys, time, urllib.parse, urllib.request

UA = ("Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/120.0.0.0 Mobile Safari/537.36")

URLS = {
    "Amazon": "https://www.amazon.fr/dp/B0D1XD1ZV3",
    "Fnac": "https://www.fnac.com/a19221423/Apple-AirPods-Pro-2",
    "Ikea": "https://www.ikea.com/fr/fr/p/billy-bibliotheque-blanc-20522046/",
    "Zalando": "https://www.zalando.fr/nike-sportswear-air-force-1-unisex-baskets-basses-phantomcool-greykhakisail-ni116d0nx-q12.html",
    "Etsy": "https://www.etsy.com/listing/1534751289/funny-java-programmer-coffee-mug",
    "Sephora": "https://www.sephora.fr/Parfum/Parfum-Femme/Parisienne-Eau-de-Parfum/P88307",
    "Decathlon": "https://www.decathlon.ca/fr/p/8957937/tente-de-camping-2-personnes-mh-100",
    "Shopify (Marin Montagut)": "https://www.marinmontagut.com/en/products/tasse-personnalisee-rue-madame",
}

IMAGE_MAGIC = (b"\x89PNG", b"\xff\xd8\xff", b"GIF8", b"RIFF")


def http(url, headers=None, timeout=30, data=None):
    req = urllib.request.Request(url, headers=headers or {}, data=data)
    t = time.monotonic()
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            body = r.read()
            return r.status, body, time.monotonic() - t, dict(r.headers)
    except urllib.error.HTTPError as e:
        return e.code, e.read() if e.fp else b"", time.monotonic() - t, dict(e.headers or {})
    except Exception as e:  # timeout, DNS...
        return None, str(e).encode(), time.monotonic() - t, {}


def usable_image(url):
    """Même critère que l'app : téléchargeable, > 500 octets, signature image."""
    if not url or not url.startswith("http"):
        return False
    status, body, _, _ = http(url, {"User-Agent": UA}, timeout=10)
    return (status == 200 and len(body) >= 500
            and any(body.startswith(m) for m in IMAGE_MAGIC))


def meta(page, prop):
    for pat in (rf'(?:property|name)=["\']{re.escape(prop)}["\'][^>]*content=["\']([^"\']+)',
                rf'content=["\']([^"\']+)["\'][^>]*(?:property|name)=["\']{re.escape(prop)}["\']'):
        m = re.search(pat, page, re.I)
        if m:
            return html.unescape(m.group(1).strip())
    return None


def direct(url):
    status, body, dt, _ = http(url, {"User-Agent": UA, "Accept": "text/html",
                                     "Accept-Language": "fr-FR,fr;q=0.9"}, timeout=10)
    page = body.decode("utf-8", "replace")
    title = meta(page, "og:title") or meta(page, "twitter:title")
    image = meta(page, "og:image") or meta(page, "twitter:image")
    if image and image.startswith("/"):
        image = urllib.parse.urljoin(url, image)
    return {"status": status, "time": round(dt, 2), "title": title, "image": image}


def microlink(url):
    api = "https://api.microlink.io/?url=" + urllib.parse.quote(url, safe="")
    status, body, dt, headers = http(api, {"User-Agent": UA}, timeout=30)
    try:
        j = json.loads(body)
    except ValueError:
        j = {}
    d = j.get("data") or {}
    image = (d.get("image") or {}).get("url") or (d.get("logo") or {}).get("url")
    return {"status": status, "time": round(dt, 2), "title": d.get("title"), "image": image,
            "error": j.get("code") if j.get("status") != "success" else None,
            "remaining": headers.get("x-rate-limit-remaining")}


def jina(url, engine=None):
    headers = {"Accept": "application/json", "X-Return-Format": "markdown"}
    if engine:
        headers["X-Engine"] = engine
    status, body, dt, h = http("https://r.jina.ai/" + url, headers, timeout=60)
    try:
        j = json.loads(body)
    except ValueError:
        j = {}
    d = j.get("data") or {}
    m = d.get("metadata") or {}
    title = m.get("og:title") or d.get("title")
    image = m.get("og:image") or m.get("twitter:image") or None
    return {"status": status, "time": round(dt, 2), "title": title, "image": image,
            "http_status_of_page": d.get("httpStatus"),
            "tokens": (d.get("usage") or {}).get("tokens"),
            "error": j.get("name") or (j.get("message") if status != 200 else None)}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--skip", action="append", default=[])
    args = ap.parse_args()
    sources = {"direct": direct, "microlink": microlink, "jina": jina,
               "jina-direct": lambda u: jina(u, "direct")}
    results = []
    for shop, url in URLS.items():
        row = {"shop": shop, "url": url}
        for name, fn in sources.items():
            if name in args.skip:
                continue
            r = fn(url)
            r["image_ok"] = usable_image(r.get("image"))
            row[name] = r
            print(f"{shop:28} {name:12} status={r['status']} {r['time']:>6}s "
                  f"title={'oui' if r.get('title') else 'non'} image={'oui' if r['image_ok'] else 'non'}",
                  file=sys.stderr)
            if name.startswith("jina"):
                time.sleep(4)  # 20 req/min sans clé
        results.append(row)
    json.dump({"date": time.strftime("%Y-%m-%d %H:%M"), "results": results},
              sys.stdout, ensure_ascii=False, indent=2)


if __name__ == "__main__":
    main()
