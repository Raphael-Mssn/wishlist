import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/main.dart';

final supabaseClientProvider = Provider.autoDispose<SupabaseClient>((ref) {
  return supabase;
});
