import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/presence_service.dart';

/// Provider qui initialise le tracking de présence au démarrage de l'app
final presenceInitializerProvider = FutureProvider<void>((ref) async {
  final presenceService = ref.watch(presenceServiceProvider);
  await presenceService.startTracking();

  // Nettoyer lors de la fermeture
  ref.onDispose(presenceService.stopTracking);
});
