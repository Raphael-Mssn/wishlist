# 🏗️ Architecture Realtime - Best Practices

## 📋 Principe de séparation des responsabilités

L'architecture Realtime suit le principe **CQRS** (Command Query Responsibility Segregation) :

- **Queries (Lecture)** : `StreamProvider` qui écoute les changements Realtime
- **Commands (Écriture)** : `ActionsProvider` qui expose les mutations

```
┌─────────────────────────────────────────────────┐
│                    UI LAYER                      │
│                                                  │
│  • Lecture : ref.watch(realtimeProvider)        │
│  • Écriture : ref.read(actionsProvider).xxx()   │
└──────────────┬──────────────────┬────────────────┘
               │                  │
        LECTURE│                  │ÉCRITURE
               │                  │
      ┌────────▼────────┐  ┌──────▼─────────┐
      │ StreamProvider  │  │ ActionsProvider │
      │   (Realtime)    │  │   (Mutations)   │
      └────────┬────────┘  └──────┬─────────┘
               │                  │
               │                  │
      ┌────────▼──────────────────▼─────────┐
      │     Repository / Service             │
      └──────────────┬───────────────────────┘
                     │
            ┌────────▼────────┐
            │ Supabase Backend│
            └─────────────────┘
```

---

## 🎯 Avantages de cette architecture

### ✅ Séparation claire des responsabilités
- **Lecture** : Les StreamProviders ne font que de la lecture
- **Écriture** : Les ActionsProviders ne font que des mutations
- Pas de confusion entre les deux

### ✅ Testabilité
```dart
// Facile à mocker dans les tests
final mockActions = MockWishlistActions();
when(mockActions.createWishlist(any)).thenReturn(...);
```

### ✅ Type safety
```dart
// Les actions sont typées et documentées
final actions = ref.read(wishlistActionsProvider);
await actions.createWishlist(request);  // ✅ Auto-complétion
await actions.updateWishlist(wishlist); // ✅ Type-safe
```

### ✅ Pas d'appel direct au service depuis l'UI
```dart
// ❌ MAUVAIS (appelait directement le service)
await ref.read(wishlistServiceProvider).createWishlist(request);

// ✅ BON (passe par le provider d'actions)
await ref.read(wishlistActionsProvider).createWishlist(request);
```

---

## 📁 Structure des fichiers

Pour chaque entité (Wishlist, Wish, Friendship), on a :

### 1. Stream Repository (Lecture Realtime)
```
lib/shared/infra/repositories/xxx/
├── xxx_stream_repository.dart              # Interface
├── supabase_xxx_stream_repository.dart     # Implémentation
├── xxx_stream_repository_provider.dart     # Provider du repository
└── xxx_streams_providers.dart              # StreamProviders pratiques
```

### 2. Actions Provider (Écriture)
```
lib/shared/infra/
└── xxx_actions_provider.dart               # Actions provider
```

### 3. Realtime Provider (Combinaison)
```
lib/shared/infra/
└── xxx_realtime_provider.dart              # StreamProvider qui combine lecture + service
```

---

## 💻 Exemples d'utilisation

### Wishlists

#### Lecture (Affichage)
```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Lecture via StreamProvider Realtime
    final wishlists = ref.watch(wishlistsRealtimeProvider);

    return wishlists.when(
      data: (data) => WishlistsGrid(wishlists: data),
      loading: () => CircularProgressIndicator(),
      error: (error, _) => Text('Erreur: $error'),
    );
  }
}
```

#### Écriture (Actions)
```dart
class CreateWishlistButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // ✅ Écriture via ActionsProvider
        final actions = ref.read(wishlistActionsProvider);
        await actions.createWishlist(request);
        
        // L'UI se met à jour automatiquement via Realtime ! ✨
      },
      child: Text('Créer'),
    );
  }
}
```

### Wishs

#### Lecture + Écriture combinées
```dart
class WishCard extends ConsumerWidget {
  final Wish wish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Les données viennent du StreamProvider parent
    return Card(
      child: ListTile(
        title: Text(wish.name),
        trailing: IconButton(
          icon: Icon(
            wish.isFavourite ? Icons.favorite : Icons.favorite_border,
          ),
          onPressed: () async {
            // ✅ Action via ActionsProvider
            final actions = ref.read(wishActionsProvider);
            await actions.updateWish(
              wish.copyWith(isFavourite: !wish.isFavourite),
            );
            // L'UI se met à jour automatiquement ! ✨
          },
        ),
      ),
    );
  }
}
```

### Friendships

#### Lecture
```dart
class FriendsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Lecture via StreamProvider Realtime
    final friendsData = ref.watch(friendshipsRealtimeProvider);

    return friendsData.when(
      data: (data) => FriendsList(friends: data.friends),
      loading: () => CircularProgressIndicator(),
      error: (error, _) => Text('Erreur: $error'),
    );
  }
}
```

#### Écriture
```dart
class AskFriendshipButton extends ConsumerWidget {
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // ✅ Action via ActionsProvider
        final actions = ref.read(friendshipActionsProvider);
        await actions.askFriendship(userId);
        
        // La liste d'amis se met à jour automatiquement ! ✨
      },
      child: Text('Ajouter'),
    );
  }
}
```

---

## 🔄 Flow complet d'une mutation

Prenons l'exemple de l'ajout d'un ami :

```
1. Utilisateur clique sur "Ajouter ami"
   │
   ├─> UI appelle : ref.read(friendshipActionsProvider).askFriendship(userId)
   │
2. ActionsProvider appelle le Service
   │
   ├─> FriendshipService.askFriendshipTo(userId)
   │
3. Service appelle le Repository
   │
   ├─> FriendshipRepository.askFriendshipTo(userId)
   │
4. Repository fait l'INSERT dans Supabase
   │
   ├─> INSERT INTO friendships (...)
   │
5. Supabase Realtime détecte le changement
   │
   ├─> WebSocket notification → INSERT event
   │
6. StreamRepository reçoit l'événement
   │
   ├─> SupabaseFriendshipStreamRepository.watchCurrentUserRequestedFriendsIds()
   │
7. StreamProvider émet les nouvelles données
   │
   ├─> friendshipsRealtimeProvider émet FriendsData mis à jour
   │
8. UI se rebuilds automatiquement
   │
   └─> ✨ Le nouvel ami apparaît dans la liste !
```

**Temps total : ~100-300ms** ⚡

---

## 📊 Comparaison Avant / Après

### ❌ Avant (sans ActionsProvider)

```dart
// Appel direct au service depuis l'UI
await ref.read(friendshipServiceProvider).askFriendshipTo(userId);

// Problèmes :
// - Couplage fort entre UI et Service
// - Difficile à tester
// - Pas de séparation des responsabilités
// - Moins lisible
```

### ✅ Après (avec ActionsProvider)

```dart
// Appel via le provider d'actions
await ref.read(friendshipActionsProvider).askFriendship(userId);

// Avantages :
// ✅ Séparation claire (lecture vs écriture)
// ✅ Facilement mockable pour les tests
// ✅ API claire et documentée
// ✅ Plus maintenable
```

---

## 🎓 Règles à suivre

### ✅ À FAIRE

1. **Lecture** : Toujours utiliser les StreamProviders
```dart
final data = ref.watch(xxxRealtimeProvider);
```

2. **Écriture** : Toujours utiliser les ActionsProviders
```dart
await ref.read(xxxActionsProvider).action();
```

3. **Ne jamais invalider manuellement** les StreamProviders Realtime
```dart
// ❌ PAS BESOIN de ça avec Realtime !
// ref.invalidate(wishlistsRealtimeProvider);
```

### ❌ À NE PAS FAIRE

1. **Ne jamais appeler le service directement depuis l'UI**
```dart
// ❌ MAUVAIS
await ref.read(wishlistServiceProvider).createWishlist(...);

// ✅ BON
await ref.read(wishlistActionsProvider).createWishlist(...);
```

2. **Ne jamais mélanger lecture et écriture dans le même provider**
```dart
// ❌ MAUVAIS : Un StateNotifier qui gère lecture ET écriture
class BadNotifier extends StateNotifier<AsyncValue<Data>> {
  Future<void> create() { /* mutation */ }
  Future<void> load() { /* lecture */ }
}
```

3. **Ne pas créer de StateNotifier pour les données Realtime**
```dart
// ❌ MAUVAIS : StateNotifier pour données Realtime
final badProvider = StateNotifierProvider<DataNotifier, AsyncValue<Data>>();

// ✅ BON : StreamProvider pour données Realtime
final goodProvider = StreamProvider<Data>();
```

---

## 🧪 Tests

### Tester un ActionsProvider

```dart
void main() {
  test('FriendshipActions.askFriendship appelle le service', () async {
    // Arrange
    final mockService = MockFriendshipService();
    final actions = FriendshipActions(mockService);

    // Act
    await actions.askFriendship('user-123');

    // Assert
    verify(mockService.askFriendshipTo('user-123')).called(1);
  });
}
```

### Tester un Widget avec ActionsProvider

```dart
void main() {
  testWidgets('Bouton appelle askFriendship', (tester) async {
    // Arrange
    final mockActions = MockFriendshipActions();
    final container = ProviderContainer(
      overrides: [
        friendshipActionsProvider.overrideWithValue(mockActions),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MyButton(),
      ),
    );
    await tester.tap(find.byType(ElevatedButton));

    // Assert
    verify(mockActions.askFriendship(any)).called(1);
  });
}
```

---

## 📝 Checklist pour ajouter une nouvelle entité Realtime

- [ ] Créer l'interface `XxxStreamRepository`
- [ ] Créer l'implémentation `SupabaseXxxStreamRepository`
- [ ] Créer le provider `xxxStreamRepositoryProvider`
- [ ] Créer les StreamProviders pratiques `xxxStreamsProviders`
- [ ] Créer le `xxxRealtimeProvider` qui combine tout
- [ ] Créer le `xxxActionsProvider` pour les mutations
- [ ] Migrer les widgets pour utiliser le `xxxRealtimeProvider` (lecture)
- [ ] Migrer les widgets pour utiliser le `xxxActionsProvider` (écriture)
- [ ] Supprimer les anciens `ref.invalidate()` (plus nécessaires !)
- [ ] Tester sur plusieurs appareils la synchronisation

---

## 🎉 Résumé

### Architecture actuelle

| Entité | Lecture (StreamProvider) | Écriture (ActionsProvider) |
|--------|-------------------------|----------------------------|
| **Wishlists** | `wishlistsRealtimeProvider` | `wishlistActionsProvider` |
| **Wishs** | `watchWishsFromWishlistProvider` | `wishActionsProvider` |
| **Friendships** | `friendshipsRealtimeProvider` | `friendshipActionsProvider` |
| **WishTakenByUser** | `watchTakenByUsersForWish` | `wishTakenByUserActionsProvider` |
| **Profiles** | `watchProfileByIdProvider` | *(via UserRepository)* |

### Avantages obtenus

- ✅ Séparation claire lecture/écriture (CQRS)
- ✅ Pas d'appel direct au service depuis l'UI
- ✅ Code plus testable et maintenable
- ✅ API claire et documentée
- ✅ Synchronisation automatique en temps réel
- ✅ Architecture scalable et cohérente
- ✅ Support des relations (JOIN) en Realtime

---

## 🔗 Gestion des relations (JOIN) en Realtime

### Problème : Tables liées par JOIN

Certaines données sont chargées via des JOIN SQL :
```sql
SELECT * FROM wishs 
LEFT JOIN wish_taken_by_user ON wishs.id = wish_taken_by_user.wish_id
```

**Problème** : Si `wish_taken_by_user` change, le stream des `wishs` doit se mettre à jour !

### Solution : Écouter plusieurs tables sur le même channel

```dart
final channel = _client
    .channel('wishs_wishlist_$wishlistId')
    // Écouter la table principale
    .onPostgresChanges(
      event: PostgresChangeEvent.all,
      table: 'wishs',
      filter: ...,
      callback: (payload) => _reloadData(),
    )
    // Écouter AUSSI la table liée
    .onPostgresChanges(
      event: PostgresChangeEvent.all,
      table: 'wish_taken_by_user',
      callback: (payload) => _reloadData(), // ← Même callback !
    )
    .subscribe();
```

**Résultat** : Quand quelqu'un réserve un wish (INSERT dans `wish_taken_by_user`), le stream des wishs se met à jour automatiquement avec les nouvelles réservations ! ✨

### Exemple concret

1. Alice ouvre la wishlist de Bob
2. Elle voit un wish "PS5" sans réservation
3. Charlie (sur un autre appareil) réserve la PS5
   - → INSERT dans `wish_taken_by_user`
4. Le stream d'Alice détecte le changement
5. Alice voit maintenant "PS5 (réservée par Charlie)" **en temps réel** !

---

**Créé le** : Octobre 2025  
**Version** : 1.0  
**Statut** : ✅ Implémenté sur Wishlists, Wishs, Friendships, WishTakenByUser

