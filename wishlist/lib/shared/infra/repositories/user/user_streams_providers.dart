import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/user/user_stream_repository_provider.dart';
import 'package:wishlist/shared/models/profile.dart';

/// Stream provider pour un profile spécifique en temps réel
///
/// Usage dans un widget:
/// ```dart
/// class MyWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final profileAsync = ref.watch(
///       watchProfileByIdProvider('user-id')
///     );
///
///     return profileAsync.when(
///       data: (profile) => profile != null
///         ? Text(profile.pseudo)
///         : Text('Profil non trouvé'),
///       loading: () => CircularProgressIndicator(),
///       error: (error, stack) => Text('Erreur: $error'),
///     );
///   }
/// }
/// ```
final watchProfileByIdProvider =
    StreamProvider.autoDispose.family<Profile?, String>((ref, userId) {
  final repository = ref.watch(userStreamRepositoryProvider);
  return repository.watchProfileById(userId);
});

/// Stream provider pour le profile de l'utilisateur courant en temps réel
final watchCurrentUserProfileProvider =
    StreamProvider.autoDispose<Profile?>((ref) {
  final repository = ref.watch(userStreamRepositoryProvider);
  return repository.watchCurrentUserProfile();
});
