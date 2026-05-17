# Architecture : partage externe et ajout de Wish

Contexte pour modifier ou débugger la feature (partage → add-wish → formulaire prérempli).

## Objectifs

1. **Partage depuis une autre app / site** : l’utilisateur partage une URL ou du texte (ex. lien produit, titre) vers l’app → ouverture d’un formulaire de création de Wish prérempli.
2. **Arrivée sur `WishFormScreen`** préremplie avec les infos récupérées (nom, lien, image, etc.).
3. **Évolution future** : ajout d’un Wish en **scannant le code-barres d’un produit** (EAN, etc.) → lookup API → même flux de préremplissage.

---

## Principes

- **Une seule entrée “données externes”** : le modèle **WishPrefillData** (et le payload partage via `ShareIntentPayload`) représente tout ce qui peut venir du partage, d’un deep link ou, plus tard, du scan code-barres.
- **Une seule vue formulaire** : `WishFormScreen` reçoit soit un `Wish` (édition), soit un prefill (création préremplie).
- **Deux points d’entrée navigation** : avec wishlist connue → `CreateWishRoute` ; sans wishlist → `AddWishRoute` (choix de wishlist) puis `CreateWishRoute`.

---

## Schéma des flux

```
[Partage externe]     →  parse WishPrefillData  →  AddWishRoute  →  (choix wishlist)  →  CreateWishRoute(prefill)  →  WishFormScreen(prefill)
[Deep link]           →  GoRouter (URL)         →  AddWishRoute ou CreateWishRoute(prefill)  →  WishFormScreen(prefill)
[Clic in-app]         →  CreateWishRoute        →  WishFormScreen (prefill vide ou depuis lien interne)
[Scan code-barres]    →  (futur) lookup API    →  WishPrefillData  →  CreateWishRoute(prefill)  →  WishFormScreen(prefill)
```

Tout converge vers **une seule vue** (`WishFormScreen`) et **un seul modèle de préremplissage** (`WishPrefillData`).

---

## Contexte technique

- **Partage** : plugin [share_intent_package](https://pub.dev/packages/share_intent_package) (iOS Share Extension + Android). On l’utilise car l’ancien receive_sharing_intent n’est pas compatible avec les app extensions iOS (`addApplicationDelegate` interdit). Côté Flutter : `ShareIntentHandler` → `WishPrefillData.fromSharedText` → `ShareIntentPayload` → navigation add-wish.
- **Link preview** : Edge Function Supabase `link-preview` (fetch HTML, parse OG/meta, fallback Microlink). Client : `link_preview_client.dart` + `linkPreviewDataProvider`. Utilisée dans `WishFormScreen` quand l’utilisateur saisit un lien (sauf si image déjà fournie par partage).

---

## Configuration iOS (Share Extension)

Sur iOS, « Partager → Wishy » nécessite une **Share Extension** et les App Groups. La procédure complète et le dépannage sont dans **[IOS_SHARE_EXTENSION.md](IOS_SHARE_EXTENSION.md)**.
