# iOS : partage vers Wishy (Share Extension)

L’app utilise **[share_intent_package](https://pub.dev/packages/share_intent_package)** pour le partage iOS. Le plugin génère une **ShareExtension** (dossier `ios/ShareExtension/`). Le `ShareViewController` a été personnalisé pour écrire les données partagées dans le conteneur App Group (`shared_files/share_data.json`) et rouvrir l’app via l’URL `SharingMedia-$(BUNDLE_ID)://`.

---

## ⚠️ Pourquoi je ne vois pas Wishy dans le menu Partager ?

1. **Tester en release sur l’iPhone**  
   En debug, l’extension peut ne pas apparaître ou crasher (limite mémoire ~120 Mo).  
   `flutter run --release` ou build depuis Xcode (schéma **Runner**, configuration Release).

2. **Après modification de l’extension**  
   `flutter build ios --config-only` puis rebuild (Xcode ou `flutter run --release`).

3. **Désinstaller puis réinstaller l’app**  
   iOS met en cache la liste des extensions ; une réinstallation peut être nécessaire.

4. **Vérifier l’extension embarquée**  
   Après un build : `build/ios/Release-iphoneos/Runner.app/PlugIns/` doit contenir `ShareExtension.appex`.

5. **App Groups**  
   Runner et **ShareExtension** doivent être dans le même App Group (ex. `group.com.raphtang.wishy`). Vérifier les entitlements et le portail Apple.

6. **Safari**  
   Bug connu : le menu Partager ne montre pas toujours toutes les apps au premier tap. Réessayer ou redémarrer l’appareil.

---

## Configuration (déjà en place)

- **Extension** : créée par `dart run share_intent_package:setup_ios_clean` → `ios/ShareExtension/`.
- **App Group** : `group.com.raphtang.wishy` (Runner + ShareExtension).
- **Runner Info.plist** : schéma d’URL `SharingMedia-$(PRODUCT_BUNDLE_IDENTIFIER)` pour que l’app soit rouverte après partage.
- **ShareViewController** : extrait les pièces jointes (URL, texte, images), écrit un JSON dans `shared_files/share_data.json` du conteneur, puis ouvre l’app. L’AppDelegate lit ce fichier (ou le MethodChannel `getSharedDataFromContainer`) pour fournir les données à Flutter.

---

## Dépannage

- **Wishy s’ouvre mais pas sur l’écran « Ajouter un wish »**  
  Les données partagées n’arrivent pas à Flutter. Vérifier les logs :
  - `[Wishy Share] Read X chars from container file` → données lues côté natif.
  - `getSharedDataFromContainer: returning X chars` → Flutter reçoit bien le JSON.
  - Si tu vois `2 chars` ou `{}`, l’extension a écrit un JSON vide : vérifier l’extraction dans `ShareViewController.swift` (types d’attachments : `public.url`, `public.plain-text`, `text/uri-list`, etc.).

- **Runner has NO container access**  
  L’app n’a pas l’entitlement App Group au runtime. Portail Apple → Identifiers → ton App ID → Capabilities → App Groups → coche le groupe → régénère le profil, Clean Build, réinstalle.

- **Vérifier que l’extension écrit**  
  Console.app (Mac) → sélectionne l’iPhone → filtre par « ShareExtension » ou « Share ». Chercher les logs `[Wishy Share] ShareExtension: data saved to container (logs uniquement en Debug)` ou erreurs d’écriture.

- **`Couldn't read values... Container: (null)`**  
  App ID ou profil de provisioning sans App Groups. Même correction que ci‑dessus.

---

## objectVersion Xcode

Le projet utilise **objectVersion = 70**. Si `pod install` échoue (ex. ancienne CocoaPods), repasser à `objectVersion = 56` dans `project.pbxproj` avant `pod install`.

---

## Tests manuels

- [ ] **iOS cold start** : Partager un lien depuis Safari/Amazon → app fermée → Wishy s’ouvre sur l’écran add-wish, formulaire prérempli.
- [ ] **iOS warm start** : Partager un lien alors que Wishy est ouvert → retour à l’app, navigation vers add-wish, formulaire prérempli.
- [ ] **Prefill** : Nom, lien et image présents quand la source les fournit ou via link preview.
- [ ] **Plusieurs wishlists** : Écran de choix avant le formulaire.
