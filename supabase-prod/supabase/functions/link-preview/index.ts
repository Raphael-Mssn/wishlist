// Link Preview Edge Function: fetch URL, parse OG / meta, return title + imageUrl (pas de prix).
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

// Microlink en fallback (sans clé API = plan gratuit, suffisant pour image + titre).
// Retry jusqu'à 2 fois en cas d'échec (réseau, rate limit, etc.).
async function fetchViaMicrolink(url: string): Promise<{
  title: string | null;
  imageUrl: string | null;
} | null> {
  const apiUrl = new URL("https://api.microlink.io");
  apiUrl.searchParams.set("url", url);
  const maxAttempts = 2;
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      const res = await fetch(apiUrl.toString(), {
        headers: { "User-Agent": BROWSER_UA },
      });
      if (!res.ok) {
        if (attempt < maxAttempts) {
          console.log("[link-preview] Microlink attempt", attempt, "status", res.status);
          continue;
        }
        return null;
      }
      const json = await res.json();
      if (json?.status !== "success" || !json.data) {
        if (attempt < maxAttempts) continue;
        return null;
      }
      const d = json.data;
      const title = normalizeTitle(d.title ?? undefined);
      let imageUrl: string | null = null;
      if (d.image?.url) imageUrl = d.image.url;
      else if (d.screenshot?.url) imageUrl = d.screenshot.url;
      else if (d.logo?.url) imageUrl = d.logo.url;
      return { title, imageUrl };
    } catch (e) {
      console.log("[link-preview] Microlink attempt", attempt, "error", e);
      if (attempt >= maxAttempts) return null;
    }
  }
  return null;
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

/** Logique complète fetch HTML + parse + Microlink, pour pouvoir timeout + retry. */
async function fetchPreview(targetUrl: string): Promise<{
  title: string | null;
  imageUrl: string | null;
}> {
  let html: string;
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
    html = "";
  }

  console.log("[link-preview] fetch result", {
    url: targetUrl.slice(0, 60) + (targetUrl.length > 60 ? "…" : ""),
    status,
    htmlLength: html?.length ?? 0,
  });

  let title: string | null = null;
  let imageUrl: string | null = null;

  if (html && html.length > 500) {
    title = normalizeTitle(ogOrTwitter(html, "title") ?? metaName(html, "title"));
    imageUrl =
      ogOrTwitter(html, "image") ??
      metaName(html, "twitter:image:src");
    if (imageUrl && !imageUrl.startsWith("http")) {
      imageUrl = resolveUrl(targetUrl, imageUrl);
    }
    console.log("[link-preview] from HTML", {
      status,
      hasTitle: !!title,
      hasImageUrl: !!imageUrl,
    });
  }

  if (!title || !imageUrl) {
    console.log("[link-preview] fallback Microlink", {
      reason: !title ? "no title" : "no imageUrl",
    });
    const microlink = await fetchViaMicrolink(targetUrl);
    if (microlink) {
      console.log("[link-preview] Microlink result", {
        hasTitle: !!microlink.title,
        hasImageUrl: !!microlink.imageUrl,
      });
      if (!title) title = microlink.title;
      if (!imageUrl) imageUrl = microlink.imageUrl;
    } else {
      console.log("[link-preview] Microlink returned nothing");
    }
  }

  return { title: title ?? null, imageUrl: imageUrl ?? null };
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
    let result: { title: string | null; imageUrl: string | null } = {
      title: null,
      imageUrl: null,
    };

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
        result = { title: null, imageUrl: null };
        break;
      }
      // Pas de retry quand on a un résultat (même sans image) : refetch donnerait
      // le même HTML et ne ferait qu’ajouter du délai. On ne retry que sur timeout/erreur.
      break;
    }

    console.log("[link-preview] response", {
      hasTitle: !!result.title,
      hasImageUrl: !!result.imageUrl,
    });

    return new Response(
      JSON.stringify({
        title: result.title,
        imageUrl: result.imageUrl,
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
