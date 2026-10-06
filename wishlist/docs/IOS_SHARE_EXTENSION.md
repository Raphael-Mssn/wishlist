# iOS : partage vers Wishy (Share Extension)

L'app utilise [share_intent_package](https://pub.dev/packages/share_intent_package) pour le partage iOS. Le plugin génère une ShareExtension (`ios/ShareExtension/`). Le `ShareViewController` a été personnalisé pour écrire les données partagées dans le conteneur App Group (`shared_files/share_data.json`) et rouvrir l'app via l'URL `SharingMedia-$(BUNDLE_ID)://`. L'AppDelegate lit ce fichier (ou le MethodChannel `getSharedDataFromContainer`) pour fournir les données à Flutter.

## Configuration

- App Group : `group.com.raphtang.wishy` (Runner + ShareExtension, entitlements et portail Apple).
- Runner Info.plist : schéma d'URL `SharingMedia-$(PRODUCT_BUNDLE_IDENTIFIER)`.
- Signing : la cible ShareExtension (`com.raphtang.wishy.ShareExtension`) a besoin de son propre profil App Store, et le profil du Runner doit inclure App Groups. La CD (`cd.yml`) signe en manuel avec un seul profil : à adapter avant la première release incluant l'extension.

## Dépannage

Les logs `[Wishy Share]` ci-dessous ne sont émis qu'en Debug. Côté extension, les lire dans Console.app (Mac) en filtrant sur « ShareExtension ».

- Wishy n'apparaît pas dans le menu Partager : tester en release sur iPhone (en debug l'extension peut crasher, limite mémoire ~120 Mo), désinstaller/réinstaller (iOS cache la liste des extensions), vérifier que `Runner.app/PlugIns/` contient `ShareExtension.appex`. Après modification de l'extension, `flutter build ios --config-only` puis rebuild.
- Wishy s'ouvre mais pas sur l'écran « Ajouter un wish » : chercher `Read X chars from container file` (lecture native) puis `getSharedDataFromContainer: returning X chars` (réception Flutter). Si `X` vaut 2 (`{}`), l'extension a écrit un JSON vide : vérifier les types d'attachments gérés dans `ShareViewController.swift` (`public.url`, `public.plain-text`, `text/uri-list`...).
- `Runner has NO container access` ou `Couldn't read values... Container: (null)` : App ID ou profil sans App Groups. Portail Apple → Identifiers → App ID → App Groups, régénérer le profil, Clean Build, réinstaller.
- L'extension n'écrit rien : chercher `data saved to container` ou `error writing to container` dans Console.app.

## Tests manuels

- [ ] iOS cold start : partager un lien depuis Safari/Amazon, app fermée. Wishy s'ouvre sur add-wish, formulaire prérempli.
- [ ] iOS warm start : partager un lien alors que Wishy est ouvert. Retour à l'app, navigation vers add-wish.
- [ ] Prefill : nom, lien et image présents quand la source les fournit ou via link preview.
- [ ] Plusieurs wishlists : écran de choix avant le formulaire.
