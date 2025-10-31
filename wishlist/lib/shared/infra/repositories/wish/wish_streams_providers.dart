import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_stream_repository_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

/// Stream provider pour les wishs d'une wishlist en temps réel
///
/// Usage dans un widget:
/// ```dart
/// class MyWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final wishsAsync = ref.watch(
///       watchWishsFromWishlistProvider(wishlistId)
///     );
///
///     return wishsAsync.when(
///       data: (wishs) => ListView.builder(...),
///       loading: () => CircularProgressIndicator(),
///       error: (error, stack) => Text('Erreur: $error'),
///     );
///   }
/// }
/// ```
final watchWishsFromWishlistProvider =
    StreamProvider.autoDispose.family<IList<Wish>, int>((ref, wishlistId) {
  final repository = ref.watch(wishStreamRepositoryProvider);
  return repository.watchWishsFromWishlist(wishlistId);
});

/// Stream provider pour un wish spécifique en temps réel
///
/// Émet `null` si le wish est supprimé
final watchWishByIdProvider =
    StreamProvider.autoDispose.family<Wish?, int>((ref, wishId) {
  final repository = ref.watch(wishStreamRepositoryProvider);
  return repository.watchWishById(wishId);
});
