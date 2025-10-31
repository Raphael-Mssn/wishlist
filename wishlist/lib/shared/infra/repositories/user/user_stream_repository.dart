import 'package:wishlist/shared/models/profile.dart';

/// Interface pour écouter les changements en temps réel sur les profiles
abstract class UserStreamRepository {
  /// Écoute les changements sur un profile spécifique
  ///
  /// Émet le profile mis à jour à chaque changement
  Stream<Profile?> watchProfileById(String userId);

  /// Écoute les changements sur le profile de l'utilisateur courant
  Stream<Profile?> watchCurrentUserProfile();

  /// Ferme tous les streams et libère les ressources
  Future<void> dispose();
}
