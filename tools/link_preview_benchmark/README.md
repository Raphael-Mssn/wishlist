# Comparatif des sources de preview de lien

Objectif : savoir si [Jina Reader](https://jina.ai/reader/) peut remplacer Microlink comme repli de l'Edge Function `link-preview`, quand le fetch direct de la page ne donne pas de titre ni d'image.

- `benchmark.py` : script de mesure (bibliothèque standard uniquement), `python3 benchmark.py > results.json`.
- `results.json` : résultats bruts du run du 04/10/2026.

## Méthode

Huit pages produit, quatre sources par page :

- **direct** : fetch HTML et lecture `og:title` / `og:image`, comme le fait la fonction aujourd'hui.
- **microlink** : `api.microlink.io`, plan gratuit sans clé (repli actuel, 25 req/jour).
- **jina** : `r.jina.ai` en mode JSON, sans clé (20 req/min), moteur par défaut (navigateur headless).
- **jina-direct** : pareil avec `X-Engine: direct` (sans navigateur).

Une image ne compte que si elle se télécharge, pèse plus de 500 octets et a une signature d'image : le critère de l'app. Un titre ne compte que s'il est le vrai nom du produit (pas « Access Denied » ni « fnac.com »).

**Limites** : un seul run, depuis une IP résidentielle et pas depuis Supabase (les IP de sortie Supabase peuvent être traitées différemment par les sites et par les quotas). La fonction coupe à 5 s : tout résultat plus lent est perdu en production.

## Résultats

Les cas qui comptent sont ceux où le fetch direct échoue (6 boutiques sur 8).

| Boutique | Direct | Microlink | Jina | Jina `direct` |
|---|---|---|---|---|
| Ikea | ✅ titre + image | ✅ (4,5 s) | ✅ (4,6 s) | ✅ (1,0 s) |
| Shopify (Marin Montagut) | ✅ titre + image | ✅ (5,4 s ⚠️) | ✅ (3,6 s) | ✅ (0,5 s) |
| Amazon | ❌ | titre seul (0,1 s), image = GIF 1×1 | titre seul (0,6 s) | titre seul (0,6 s) |
| Zalando | ❌ 403 | ✅ mais 7,2 s, hors délai | ✅ (4,9 s) | ✅ (4,0 s) |
| Decathlon | ❌ 403 | ❌ `EPROXYNEEDED` | titre seul (4,7 s) | titre seul (0,4 s) |
| Fnac | ❌ 403 | ❌ `EPROXYNEEDED` | ❌ CAPTCHA (15,8 s) | ❌ CAPTCHA (0,8 s) |
| Etsy | ❌ 403 | ❌ `EPROXYNEEDED` | ❌ page de blocage (15,6 s) | ❌ page de blocage (0,5 s) |
| Sephora | ❌ 403 | ❌ « Access Denied » | ❌ « Access Denied » | ❌ « Access Denied » |

Sur les 6 boutiques où le repli sert, dans le délai de 5 s :

| | Titres | Images |
|---|---|---|
| Microlink | 1 (Amazon) | 0 |
| Jina | 3 (Amazon, Zalando, Decathlon) | 1 (Zalando) |
| Jina `direct` | 3 | 1 |

## Piste image

Amazon et Decathlon n'exposent pas d'`og:image` à Jina, mais l'en-tête `X-With-Images-Summary: true` renvoie la liste des images de la page, et la photo produit y est :

- Amazon : `Image 10: Apple AirPods Pro (2nd Generation)…` → `m.media-amazon.com/images/I/61SUj2aKoEL._AC_SX679_.jpg`, la seule image dont la légende reprend le titre.
- Decathlon : la première image `contents.mediadecathlon.com` en grande taille (`f=3000`).

Une heuristique générique (image dont la légende partage des mots avec le titre, sinon la première grande image hors logo) récupérerait probablement ces deux cas. Non testée sur d'autres boutiques.

## Conclusion

- Jina en mode `direct` fait mieux que Microlink sur ce panel : 3 titres contre 1, et toujours sous 5 s sur les pages qui répondent. Le moteur par défaut (navigateur) n'apporte rien ici et monte à 15 s sur les pages bloquées : `X-Engine: direct` est le bon réglage.
- Aucun service gratuit ne passe Fnac, Etsy ni Sephora : il faudrait un service avec proxy anti-bot, payant.
- Avant de remplacer Microlink : refaire la mesure depuis Supabase (déployer une fonction de test en dev), et tester l'heuristique d'image sur un panel plus large.
