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
   flutter run
   ```

4. **📱 Build for Production**

   ```bash
   flutter build appbundle   # For Android  
   flutter build ios         # For iOS
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

## 📧 Contact

If you have any questions, feel free to reach out via [wishyapp.contact@gmail.com](mailto:wishyapp.contact@gmail.com).

## Happy gifting! 🎁✨