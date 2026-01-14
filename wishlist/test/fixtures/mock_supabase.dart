import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'fake_data.dart';

// =============================================================================
// MOCK CLASSES
// =============================================================================

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

// =============================================================================
// MOCK SETUP
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
