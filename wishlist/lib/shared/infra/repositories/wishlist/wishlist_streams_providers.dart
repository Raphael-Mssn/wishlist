import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_stream_repository_provider.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

/// Stream provider pour les wishlists d'un utilisateur en temps réel
///
/// Usage dans un widget:
/// ```dart
/// class MyWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final wishlistsAsync = ref.watch(
///       watchWishlistsByUserProvider('user-id')
///     );
///
///     return wishlistsAsync.when(
///       data: (wishlists) => ListView.builder(...),
///       loading: () => CircularProgressIndicator(),
///       error: (error, stack) => Text('Erreur: $error'),
///     );
///   }
/// }
/// ```
final watchWishlistsByUserProvider =
    StreamProvider.autoDispose.family<IList<Wishlist>, String>((ref, userId) {
  final repository = ref.watch(wishlistStreamRepositoryProvider);
  return repository.watchWishlistsByUser(userId);
});

/// Stream provider pour une wishlist spécifique en temps réel
///
/// Émet `null` si la wishlist est supprimée
final watchWishlistByIdProvider =
    StreamProvider.autoDispose.family<Wishlist, int>((ref, wishlistId) {
  final repository = ref.watch(wishlistStreamRepositoryProvider);
  return repository.watchWishlistById(wishlistId);
});

/// Stream provider pour les wishlists publiques d'un utilisateur en temps réel
final watchPublicWishlistsByUserProvider =
    StreamProvider.autoDispose.family<IList<Wishlist>, String>((ref, userId) {
  final repository = ref.watch(wishlistStreamRepositoryProvider);
  return repository.watchPublicWishlistsByUser(userId);
});
