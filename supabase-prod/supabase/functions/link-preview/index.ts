// Link Preview Edge Function: Jina Reader puis lecture directe de la page (OG / meta), renvoie title + imageUrl (pas de prix).
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const BROWSER_UA =
  "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36";

function metaContent(html: string, property: string, quote: string = '"'): string | null {
  const escaped = property.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const re = new RegExp(
    `property=${quote}${escaped}${quote}[^>]*content=${quote}([^${quote}]+)${quote}`,
    "i"
  );
  const m = html.match(re);
  if (m) return m[1].trim();
  const re2 = new RegExp(
    `content=${quote}([^${quote}]+)${quote}[^>]*property=${quote}${escaped}${quote}`,
    "i"
  );
  const m2 = html.match(re2);
  return m2 ? m2[1].trim() : null;
}

function metaName(html: string, name: string, quote: string = '"'): string | null {
  const escaped = name.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const re = new RegExp(
    `name=${quote}${escaped}${quote}[^>]*content=${quote}([^${quote}]+)${quote}`,
    "i"
  );
  const m = html.match(re);
  if (m) return m[1].trim();
  const re2 = new RegExp(
    `content=${quote}([^${quote}]+)${quote}[^>]*name=${quote}${escaped}${quote}`,
    "i"
  );
  const m2 = html.match(re2);
  return m2 ? m2[1].trim() : null;
}

function ogOrTwitter(html: string, name: string): string | null {
  return metaContent(html, `og:${name}`) ?? metaName(html, `twitter:${name}`);
}

function normalizeTitle(t: string | null | undefined): string | null {
  const s = t?.trim();
  if (!s || s.length < 10) return null;
  if (/^[a-z0-9_-]+$/i.test(s) && s.length < 20) return null;
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

// Jina Reader, source principale, sans clé (20 req/min par IP). Le moteur "direct"
// lit la page sans navigateur headless : même résultat sur les pages testées,
// et moins d'une seconde au lieu de 5 à 15 s avec le moteur par défaut.
// Comparatif : tools/link_preview_benchmark/ (branche chore/link-preview-benchmark).
const JINA_TIMEOUT_MS = 4000;

/** Les métadonnées Jina peuvent être une chaîne ou une liste (balises en double). */
function firstString(v: unknown): string | null {
  if (typeof v === "string") return v.trim() || null;
  if (Array.isArray(v)) return v.find((x) => typeof x === "string" && x.trim()) ?? null;
  return null;
}

async function fetchViaJina(url: string): Promise<{
  title: string | null;
  imageUrl: string | null;
} | null> {
  try {
    const res = await fetch(`https://r.jina.ai/${url}`, {
      headers: { Accept: "application/json", "X-Engine": "direct" },
      signal: AbortSignal.timeout(JINA_TIMEOUT_MS),
    });
    if (!res.ok) {
      console.log("[link-preview] Jina status", res.status);
      return null;
    }
    const d = (await res.json())?.data;
    if (!d) return null;
    // Page bloquée (anti-bot, 403...) : Jina renvoie 200 mais le titre est
    // celui de la page de blocage ("Access Denied", "fnac.com").
    if (typeof d.httpStatus === "number" && d.httpStatus >= 400) {
      console.log("[link-preview] Jina: page status", d.httpStatus);
      return null;
    }
    const meta = d.metadata ?? {};
    const title = normalizeTitle(firstString(meta["og:title"]) ?? firstString(d.title));
    const imageUrl = usableImageUrl(
      firstString(meta["og:image"]) ?? firstString(meta["twitter:image"]),
    );
    return { title, imageUrl };
  } catch (e) {
    console.log("[link-preview] Jina error", e);
    return null;
  }
}

/** Écarte les images inutilisables par l'app : vide, data: (placeholder 1x1 d'Amazon). */
function usableImageUrl(url: string | null): string | null {
  return url && url.startsWith("http") ? url : null;
}

const PREVIEW_TIMEOUT_MS = 5000;

function withTimeout<T>(p: Promise<T>, ms: number): Promise<T> {
  return Promise.race([
    p,
    new Promise<never>((_, reject) =>
      setTimeout(() => reject(new Error("timeout")), ms)
    ),
  ]);
}

type Preview = { title: string | null; imageUrl: string | null };
type Source = "jina" | "html" | null;
type PreviewResult = Preview & { source: { title: Source; image: Source } };

/** Lecture directe de la page : fetch HTML puis og:title / og:image. */
async function fetchViaHtml(targetUrl: string): Promise<Preview> {
  let html = "";
  let status = 0;
  try {
    const res = await fetch(targetUrl, {
      headers: {
        "User-Agent": BROWSER_UA,
        Accept: "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "fr-FR,fr;q=0.9,en;q=0.8",
      },
      redirect: "follow",
    });
    status = res.status;
    html = await res.text();
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
 * Jina Reader d'abord, puis lecture directe de la page pour compléter ce qui
 * manque. `source` indique d'où vient chaque champ (pour tester, ignoré par
 * l'app).
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

  fill(await fetchViaJina(targetUrl), "jina");
  if (!result.title || !result.imageUrl) {
    console.log("[link-preview] Jina incomplete, reading page", {
      hasTitle: !!result.title,
      hasImageUrl: !!result.imageUrl,
    });
    fill(await fetchViaHtml(targetUrl), "html");
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
