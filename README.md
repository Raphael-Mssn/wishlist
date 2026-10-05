# 🎁 Wishy App

Welcome to the Wishy App! This Flutter application is designed to help you effortlessly create, manage, and share your wishlists with friends and family, making gift-giving occasions more organized and enjoyable.

## ✨ Features

* **📝 Create a Wishlist**: Create a wishlist, enter a title and details, and start adding your desired items.
* **📤 Share Your Wishlist**: Use the share functionality to send your wishlist via email, messaging apps, or directly within the app.
* **🔧 Manage Wishlists**: View and edit your existing wishlists, track reserved items, and update details as needed.
* **🤝 Collaborate**: Invite others to view or contribute to your wishlists. See what gifts have been reserved and what’s still available.

---

## 🚀 Getting Started

### ✅ Prerequisites

* **🛠 Flutter**: Ensure you have Flutter installed on your machine. You can follow the installation guide [here](https://flutter.dev/docs/get-started/install).
* **🎯 Dart**: Flutter requires Dart, which is included with the Flutter SDK.

### 📦 Installation

1. **🔗 Clone the Repository**

   ```bash
   git clone git@github.com:Raphael-Mssn/wishlist.git
   cd wishlist
   ```

2. **📥 Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **▶️ Run the App**

   ```bash
   flutter run   # dev environment by default
   ```

4. **📱 Build for Production**

   ```bash
   flutter build appbundle --dart-define=APP_ENV=prod   # For Android
   flutter build ios --dart-define=APP_ENV=prod         # For iOS
   ```

---

## 🧱 Supabase Setup (for developers)

The app uses **Supabase** as its backend for authentication, database, and storage.
Each environment (`dev` and `prod`) is managed separately to keep development safe and clean.

### ⚙️ Requirements

* **Supabase CLI**
  Install via Homebrew or npm:

  ```bash
  brew install supabase/tap/supabase
  # or
  npm install -g supabase
  ```

* **Docker Desktop** (required for migrations)

  ```bash
  brew install --cask docker
  open -a "Docker"
  ```

---

### 🔐 Login to Supabase

Each developer must use their own Supabase account and Personal Access Token (PAT).

1. Generate a new token at [https://supabase.com/account/tokens](https://supabase.com/account/tokens)
2. Log in to the CLI:

   ```bash
   supabase login --token "<YOUR_PERSONAL_TOKEN>"
   ```

---

### 🗂 Project Linking

The project includes two Supabase environments:

| Environment | Folder           | Supabase Project | Project Ref            |
| ----------- | ---------------- | ---------------- | ---------------------- |
| Development | `supabase-dev/`  | wishlist-dev     | `qedynftuclpdisocgzuv` |
| Production  | `supabase-prod/` | wishy-prod       | `cbcrtjggsmtwvqljzbnl` |

Each developer must manually link both projects once.

#### 👉 Link dev

```bash
cd supabase-dev
supabase link --project-ref qedynftuclpdisocgzuv
```

#### 👉 Link prod

```bash
cd ../supabase-prod
supabase link --project-ref cbcrtjggsmtwvqljzbnl
```

Verify with:

```bash
supabase projects list
```

---

### 🔄 Syncing schemas between dev and prod

1. **Pull the latest schema from dev**

   ```bash
   cd supabase-dev
   supabase db pull
   ```

2. **Push the schema to prod**

   ```bash
   cd ../supabase-prod
   supabase db push
   ```

---

## 🚀 CI/CD

Le projet utilise **GitHub Actions** pour l'intégration et le déploiement continus.

### ✅ Intégration Continue (CI)

La CI se déclenche automatiquement sur :
- Push sur `main`
- Ouverture/mise à jour d'une Pull Request

Elle exécute :
- `dart format` - vérification du formatage
- `flutter analyze` - analyse statique du code
- `build_runner` - génération de code (Freezed, Riverpod, etc.)
- `flutter test` - tests unitaires et golden tests

### 📦 Déploiement Continu (CD)

La CD se déclenche lors du push d'un **tag de version** (`v*`).

#### Déclencher un déploiement

```bash
git tag v0.2.3
git push origin v0.2.3
```

#### Destinations

| Plateforme | Track            |
| ---------- | ---------------- |
| Android    | Internal Testing |
| iOS        | TestFlight       |

#### Secrets GitHub requis

| Secret | Description |
| ------ | ----------- |
| `ANDROID_KEYSTORE_BASE64` | Keystore Android encodé en base64 |
| `ANDROID_KEYSTORE_PASSWORD` | Mot de passe du keystore |
| `ANDROID_KEY_ALIAS` | Alias de la clé |
| `ANDROID_KEY_PASSWORD` | Mot de passe de la clé |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | JSON du service account Google Play |
| `IOS_P12_BASE64` | Certificat Apple Distribution encodé en base64 |
| `IOS_P12_PASSWORD` | Mot de passe du certificat |
| `IOS_PROVISIONING_PROFILE_BASE64` | Provisioning profile encodé en base64 |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID App Store Connect |
| `APP_STORE_CONNECT_API_KEY_ID` | Key ID App Store Connect |
| `APP_STORE_CONNECT_API_PRIVATE_KEY` | Contenu du fichier .p8 |
| `SUPABASE_URL` | URL Supabase production |
| `SUPABASE_ANON_KEY` | Clé anonyme Supabase production |

---

## 📧 Contact

If you have any questions, feel free to reach out via [wishyapp.contact@gmail.com](mailto:wishyapp.contact@gmail.com).

## Happy gifting! 🎁✨