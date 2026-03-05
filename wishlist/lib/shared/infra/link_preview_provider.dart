import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:wishlist/shared/infra/link_preview_client.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

part 'link_preview_provider.g.dart';

const _edgeFunctionTimeout = Duration(seconds: 25);

/// Récupère image + titre pour une URL via l'Edge Function "link-preview".
@riverpod
Future<LinkPreviewData> linkPreviewData(Ref ref, String pageUrl) async {
  final url = pageUrl.trim();
  if (url.isEmpty) {
    return const LinkPreviewData();
  }
  try {
    final client = ref.read(supabaseClientProvider);
    return await fetchPreviewDataViaEdgeFunction(client, url)
        .timeout(_edgeFunctionTimeout);
  } on TimeoutException {
    if (kDebugMode) {
      debugPrint('[Wishy link_preview] linkPreviewData: timeout');
    }
    return const LinkPreviewData();
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('[Wishy link_preview] linkPreviewData: $e');
      debugPrint(st.toString());
    }
    return const LinkPreviewData();
  }
}
