import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/user_service.dart';

import 'fake_data.dart';

// =============================================================================
// MOCK CLASSES
// =============================================================================

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

// ignore: avoid_implementing_value_types
class MockUser extends Mock implements User {}

class MockUserService extends Mock implements UserService {}

// =============================================================================
// MOCK SUPABASE
// =============================================================================

/// Crée un MockSupabaseClient configuré avec un utilisateur de test
MockSupabaseClient createMockSupabaseClient({
  String? userId,
}) {
  final mockSupabaseClient = MockSupabaseClient();
  final mockAuth = MockGoTrueClient();
  final mockUser = MockUser();

  final effectiveUserId = userId ?? fakeCurrentUserId;

  when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
  when(() => mockAuth.currentUser).thenReturn(mockUser);
  when(() => mockUser.id).thenReturn(effectiveUserId);

  return mockSupabaseClient;
}

// =============================================================================
// MOCK USER SERVICE
// =============================================================================

/// Crée un MockUserService configuré avec des données de test
MockUserService createMockUserService({
  String? userId,
  String? userEmail,
}) {
  final mockUserService = MockUserService();

  when(mockUserService.getCurrentUserId)
      .thenReturn(userId ?? fakeCurrentUserId);
  when(mockUserService.getCurrentUserEmail)
      .thenReturn(userEmail ?? 'test@example.com');

  return mockUserService;
}

// =============================================================================
// FAKE PACKAGE INFO
// =============================================================================

final fakePackageInfo = PackageInfo(
  appName: 'Wishlist',
  packageName: 'com.example.wishlist',
  version: '1.0.0',
  buildNumber: '1',
);
