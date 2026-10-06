// Link Preview Edge Function: lecture directe de la page (OG / meta) puis Jina Reader en fallback, renvoie title + imageUrl (pas de prix).
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const BROWSER_UA =
  "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36";

/**
 * Décode les entités HTML d'un attribut (« L&#039;Or&eacute;al &amp; Co » →
 * « L'Oréal & Co »), y compris dans les URL d'image (`?a=1&amp;b=2`).
 * Une seule passe : « &amp;lt; » donne « &lt; », pas « < ». Les entités
 * nommées inconnues sont laissées telles quelles.
 */
const NAMED_ENTITIES: Record<string, string> = {
  amp: "&", quot: '"', apos: "'", lt: "<", gt: ">", nbsp: "\u00a0",
  eacute: "é", Eacute: "É", egrave: "è", Egrave: "È", ecirc: "ê", Ecirc: "Ê",
  euml: "ë", agrave: "à", Agrave: "À", acirc: "â", ccedil: "ç", Ccedil: "Ç",
  icirc: "î", iuml: "ï", ocirc: "ô", ugrave: "ù", ucirc: "û", uuml: "ü",
  oelig: "œ", rsquo: "\u2019", lsquo: "\u2018", ldquo: "\u201c", rdquo: "\u201d",
  laquo: "«", raquo: "»", hellip: "…", ndash: "–", mdash: "—", euro: "€",
  deg: "°", reg: "®", copy: "©", trade: "™",
};
function decodeHtmlEntities(s: string): string {
  return s.replace(/&(#x[0-9a-f]+|#\d+|[a-z]+);/gi, (match, code: string) => {
    if (code[0] === "#") {
      const n = code[1] === "x" || code[1] === "X"
        ? parseInt(code.slice(2), 16)
        : Number(code.slice(1));
      return Number.isFinite(n) && n > 0 && n <= 0x10ffff ? String.fromCodePoint(n) : match;
    }
    return NAMED_ENTITIES[code] ?? NAMED_ENTITIES[code.toLowerCase()] ?? match;
  });
}

function metaContent(html: string, property: string, quote: string = '"'): string | null {
  const escaped = property.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const re = new RegExp(
    `property=${quote}${escaped}${quote}[^>]*content=${quote}([^${quote}]+)${quote}`,
    "i"
  );
  const m = html.match(re);
  if (m) return decodeHtmlEntities(m[1]).trim();
  const re2 = new RegExp(
    `content=${quote}([^${quote}]+)${quote}[^>]*property=${quote}${escaped}${quote}`,
    "i"
  );
  const m2 = html.match(re2);
  return m2 ? decodeHtmlEntities(m2[1]).trim() : null;
}

function metaName(html: string, name: string, quote: string = '"'): string | null {
  const escaped = name.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const re = new RegExp(
    `name=${quote}${escaped}${quote}[^>]*content=${quote}([^${quote}]+)${quote}`,
    "i"
  );
  const m = html.match(re);
  if (m) return decodeHtmlEntities(m[1]).trim();
  const re2 = new RegExp(
    `content=${quote}([^${quote}]+)${quote}[^>]*name=${quote}${escaped}${quote}`,
    "i"
  );
  const m2 = html.match(re2);
  return m2 ? decodeHtmlEntities(m2[1]).trim() : null;
}

function ogOrTwitter(html: string, name: string): string | null {
  return metaContent(html, `og:${name}`) ?? metaName(html, `twitter:${name}`);
}

/**
 * Écarte ce qui n'est pas un nom de produit. Pas de seuil de longueur au-delà
 * de 3 caractères : « Switch 2 » ou « AirPods 4 » sont des titres valides.
 */
function normalizeTitle(t: string | null | undefined): string | null {
  const s = t?.trim();
  if (!s || s.length < 3) return null;
  // Slug technique sans espace : « product-12345 », « index_page ».
  if (/^[a-z0-9]+(?:[_-][a-z0-9]+)+$/i.test(s)) return null;
  // Simple nom de domaine, titre typique des pages de blocage : « fnac.com ».
  if (/^[a-z0-9-]+(?:\.[a-z0-9-]+)+$/i.test(s)) return null;
  return s;
}

function resolveUrl(base: string, path: string): string {
  if (path.startsWith("http://") || path.startsWith("https://")) return path;
  try {
    return new URL(path, base).href;
  } catch {
    return path;
  }
}

// Jina Reader en fallback, sans clé (20 req/min par IP). Le moteur "direct"
// lit la page sans navigateur headless : même résultat sur les pages testées,
// et moins d'une seconde au lieu de 5 à 15 s avec le moteur par défaut.
// Comparatif : tools/link_preview_benchmark/ (branche chore/link-preview-benchmark).
// Le moteur "browser" (navigateur headless, ~4,5 s) ne sert que pour passer un
// challenge Cloudflare ("Just a moment..."), ex. decathlon.fr.
type JinaEngine = "direct" | "browser";
const JINA_TIMEOUT_MS: Record<JinaEngine, number> = { direct: 4000, browser: 7000 };
const CLOUDFLARE_CHALLENGE_TITLE = /^just a moment/i;

type JinaResult =
  | { preview: { title: string | null; imageUrl: string | null }; cloudflareChallenge: false }
  | { preview: null; cloudflareChallenge: boolean };

/** Les métadonnées Jina peuvent être une chaîne ou une liste (balises en double). */
function firstString(v: unknown): string | null {
  if (typeof v === "string") return v.trim() || null;
  if (Array.isArray(v)) return v.find((x) => typeof x === "string" && x.trim()) ?? null;
  return null;
}

async function fetchViaJina(url: string, engine: JinaEngine): Promise<JinaResult> {
  const nothing: JinaResult = { preview: null, cloudflareChallenge: false };
  try {
    const res = await fetch(`https://r.jina.ai/${url}`, {
      headers: {
        Accept: "application/json",
        "X-Engine": engine,
        // Liste des images de la page (légende -> URL), pour les sites sans og:image.
        "X-With-Images-Summary": "true",
      },
      signal: AbortSignal.timeout(JINA_TIMEOUT_MS[engine]),
    });
    if (!res.ok) {
      console.log("[link-preview] Jina status", { engine, status: res.status });
      return nothing;
    }
    const d = (await res.json())?.data;
    if (!d) return nothing;
    // Page bloquée (anti-bot, 403...) : Jina renvoie 200 mais le titre est
    // celui de la page de blocage ("Access Denied", "fnac.com").
    // Le challenge Cloudflare peut aussi revenir avec un statut 200 : on se fie
    // aussi à son titre.
    const cloudflareChallenge = CLOUDFLARE_CHALLENGE_TITLE.test(firstString(d.title) ?? "");
    if (cloudflareChallenge || (typeof d.httpStatus === "number" && d.httpStatus >= 400)) {
      console.log("[link-preview] Jina: page status", { engine, status: d.httpStatus, cloudflareChallenge });
      return { preview: null, cloudflareChallenge };
    }
    const meta = d.metadata ?? {};
    const title = normalizeTitle(firstString(meta["og:title"]) ?? firstString(d.title));
    const imageUrl = usableImageUrl(
      firstString(meta["og:image"]) ??
        firstString(meta["twitter:image"]) ??
        pickProductImage(d.images, title),
    );
    return { preview: { title, imageUrl }, cloudflareChallenge: false };
  } catch (e) {
    console.log("[link-preview] Jina error", { engine, error: String(e) });
    return nothing;
  }
}

// Images à ignorer : logos, sprites, pixels de tracking, SVG...
const NON_PRODUCT_IMAGE =
  /logo|sprite|icon|favicon|badge|pixel|tracking|\/batch\/|\.svg(\?|$)|placeholder|spinner|loader|avatar|flag/i;
// Indications de taille dans l'URL : Amazon (_AC_SX679_, _AC_US40_), CDN (?f=3000, ?width=416...).
const SIZE_HINT =
  /_(?:AC_)?(?:SX|SY|SL|US|SS|UL|SR)(\d+)|[?&](?:f|w|width|imwidth|wid)=(\d+)/i;
const STOP_WORDS = new Set(["les", "des", "une", "avec", "pour", "the", "and", "with", "from", "sur", "par", "dans"]);

function significantWords(s: string): Set<string> {
  return new Set(
    (s.toLowerCase().match(/[a-z0-9]+/g) ?? []).filter((w) => w.length >= 3 && !STOP_WORDS.has(w)),
  );
}

/**
 * Choisit la photo produit dans la liste d'images de Jina, quand la page n'a
 * pas d'og:image (Amazon, Decathlon) :
 * 1. la première image dont la légende partage au moins 2 mots avec le titre
 *    (la première, pas la plus proche : les variantes et produits similaires
 *    ont souvent des légendes encore plus proches du titre) ;
 * 2. sinon la première image restante, hors logos, icônes et miniatures.
 * Testé sur le panel de tools/link_preview_benchmark : bonne image sur les 5
 * pages lisibles.
 */
function pickProductImage(images: unknown, title: string | null): string | null {
  if (!images || typeof images !== "object") return null;
  const candidates: { alt: string; url: string }[] = [];
  for (const [caption, url] of Object.entries(images as Record<string, unknown>)) {
    if (typeof url !== "string" || !url.startsWith("http")) continue;
    const alt = caption.replace(/^Image [\d,]+:?\s*/, "");
    if (NON_PRODUCT_IMAGE.test(url) || NON_PRODUCT_IMAGE.test(alt)) continue;
    const size = url.match(SIZE_HINT);
    if (size && Number(size[1] ?? size[2]) < 200) continue;
    candidates.push({ alt, url });
  }
  const titleWords = significantWords(title ?? "");
  const byCaption = candidates.find(({ alt }) => {
    const altWords = significantWords(alt);
    let shared = 0;
    for (const w of titleWords) if (altWords.has(w)) shared++;
    return shared >= 2;
  });
  return (byCaption ?? candidates[0])?.url ?? null;
}

/** Écarte les images inutilisables par l'app : vide, data: (placeholder 1x1 d'Amazon). */
function usableImageUrl(url: string | null): string | null {
  return url && url.startsWith("http") ? url : null;
}

// Lecture directe + Jina direct + Jina browser (challenge Cloudflare) : ~6 s
// au pire constaté. Le client coupe à 25 s.
const PREVIEW_TIMEOUT_MS = 10000;

function withTimeout<T>(p: Promise<T>, ms: number): Promise<T> {
  return Promise.race([
    p,
    new Promise<never>((_, reject) =>
      setTimeout(() => reject(new Error("timeout")), ms)
    ),
  ]);
}

type Preview = { title: string | null; imageUrl: string | null };
type Source = "html" | "jina" | "jina-browser" | null;
type PreviewResult = Preview & { source: { title: Source; image: Source } };

/** Lecture directe de la page : fetch HTML puis og:title / og:image. */
// Les <meta> sont dans le <head> : inutile de lire plus que le début de la
// page, et un lien direct vers un gros fichier ne doit pas être téléchargé.
const HTML_FETCH_TIMEOUT_MS = 5000;
const HTML_MAX_BYTES = 512 * 1024;

async function readTextLimited(res: Response, maxBytes: number): Promise<string> {
  const reader = res.body?.getReader();
  if (!reader) return "";
  const chunks: Uint8Array[] = [];
  let size = 0;
  while (size < maxBytes) {
    const { done, value } = await reader.read();
    if (done) break;
    chunks.push(value);
    size += value.length;
  }
  await reader.cancel().catch(() => {});
  const bytes = new Uint8Array(Math.min(size, maxBytes));
  let offset = 0;
  for (const chunk of chunks) {
    const n = Math.min(chunk.length, bytes.length - offset);
    bytes.set(chunk.subarray(0, n), offset);
    offset += n;
    if (offset >= bytes.length) break;
  }
  return new TextDecoder().decode(bytes);
}

async function fetchViaHtml(targetUrl: string): Promise<Preview> {
  let html = "";
  let status = 0;
  try {
    // Signal d'annulation : withTimeout abandonne la promesse mais
    // n'interromprait pas la requête, qui continuerait en arrière-plan.
    const res = await fetch(targetUrl, {
      headers: {
        "User-Agent": BROWSER_UA,
        Accept: "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "fr-FR,fr;q=0.9,en;q=0.8",
      },
      redirect: "follow",
      signal: AbortSignal.timeout(HTML_FETCH_TIMEOUT_MS),
    });
    status = res.status;
    const contentType = res.headers.get("content-type") ?? "";
    if (contentType && !/html/i.test(contentType)) {
      // PDF, image, vidéo... : pas de métadonnées à lire.
      await res.body?.cancel();
      console.log("[link-preview] not HTML", { contentType });
      return { title: null, imageUrl: null };
    }
    html = await readTextLimited(res, HTML_MAX_BYTES);
  } catch (e) {
    console.error("[link-preview] fetch error", e);
  }
  console.log("[link-preview] fetch result", {
    url: targetUrl.slice(0, 60) + (targetUrl.length > 60 ? "…" : ""),
    status,
    htmlLength: html.length,
  });

  // Une page d'erreur (403 anti-bot...) n'a pas les métadonnées du produit.
  if (status >= 400 || html.length <= 500) return { title: null, imageUrl: null };

  const title = normalizeTitle(ogOrTwitter(html, "title") ?? metaName(html, "title"));
  let imageUrl = ogOrTwitter(html, "image") ?? metaName(html, "twitter:image:src");
  if (imageUrl && !imageUrl.startsWith("http") && !imageUrl.startsWith("data:")) {
    imageUrl = resolveUrl(targetUrl, imageUrl);
  }
  return { title, imageUrl: usableImageUrl(imageUrl) };
}

/**
 * Lecture directe de la page d'abord (gratuite, sans quota), puis Jina Reader
 * pour compléter ce qui manque (moteur navigateur si challenge Cloudflare). `source` indique d'où vient chaque champ
 * (pour tester, ignoré par l'app).
 */
async function fetchPreview(targetUrl: string): Promise<PreviewResult> {
  const result: PreviewResult = {
    title: null,
    imageUrl: null,
    source: { title: null, image: null },
  };
  const fill = (p: Preview | null, source: Source) => {
    if (!p) return;
    if (!result.title && p.title) {
      result.title = p.title;
      result.source.title = source;
    }
    if (!result.imageUrl && p.imageUrl) {
      result.imageUrl = p.imageUrl;
      result.source.image = source;
    }
  };

  fill(await fetchViaHtml(targetUrl), "html");
  if (!result.title || !result.imageUrl) {
    console.log("[link-preview] page incomplete, fallback Jina", {
      hasTitle: !!result.title,
      hasImageUrl: !!result.imageUrl,
    });
    const jina = await fetchViaJina(targetUrl, "direct");
    fill(jina.preview, "jina");
    if (jina.cloudflareChallenge) {
      console.log("[link-preview] Cloudflare challenge, retrying Jina with browser");
      fill((await fetchViaJina(targetUrl, "browser")).preview, "jina-browser");
    }
  }
  return result;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: CORS_HEADERS });
  }

  try {
    const { url } = (await req.json()) as { url?: string };
    if (!url || typeof url !== "string" || !url.startsWith("http")) {
      return new Response(
        JSON.stringify({ error: "Invalid or missing url" }),
        { status: 400, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
      );
    }

    const targetUrl = url.trim();
    const maxAttempts = 2;
    const empty: PreviewResult = {
      title: null,
      imageUrl: null,
      source: { title: null, image: null },
    };
    let result = empty;

    for (let attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        result = await withTimeout(fetchPreview(targetUrl), PREVIEW_TIMEOUT_MS);
      } catch (e) {
        const isTimeout = e instanceof Error && e.message === "timeout";
        console.log(
          "[link-preview] attempt",
          attempt,
          isTimeout ? "timeout" : "error",
          isTimeout ? "" : e
        );
        if (attempt < maxAttempts) {
          console.log("[link-preview] retrying…");
          continue;
        }
        console.error("[link-preview] all attempts failed");
        result = empty;
        break;
      }
      // Pas de retry quand on a un résultat (même sans image) : refaire les
      // mêmes appels donnerait la même chose. On ne retry que sur timeout/erreur.
      break;
    }

    console.log("[link-preview] response", {
      hasTitle: !!result.title,
      hasImageUrl: !!result.imageUrl,
      source: result.source,
    });

    return new Response(
      JSON.stringify({
        title: result.title,
        imageUrl: result.imageUrl,
        source: result.source,
      }),
      {
        status: 200,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      }
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: e instanceof Error ? e.message : "Unknown error" }),
      { status: 500, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
    );
  }
});
