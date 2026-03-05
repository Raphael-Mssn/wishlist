import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

const _browserHeaders = {
  'User-Agent':
      'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
  'Accept':
      'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
  'Accept-Language': 'fr-FR,fr;q=0.9,en;q=0.8',
};

/// Résultat du chargement de prévisualisation (image + titre de la page).
class LinkPreviewData {
  const LinkPreviewData({this.image, this.title});
  final File? image;
  final String? title;
}

/// Appelle l'Edge Function Supabase "link-preview" pour récupérer
/// titre et imageUrl. Télécharge l'image côté client et retourne un
/// [LinkPreviewData].
Future<LinkPreviewData> fetchPreviewDataViaEdgeFunction(
  SupabaseClient client,
  String pageUrl,
) async {
  final url = pageUrl.trim();
  if (url.isEmpty ||
      !(url.startsWith('http://') || url.startsWith('https://'))) {
    return const LinkPreviewData();
  }

  final response = await client.functions.invoke(
    'link-preview',
    body: {'url': url},
  );

  if (response.status != 200) {
    final data = response.data;
    final errorMsg = data is Map && data['error'] != null
        ? data['error'].toString()
        : 'link-preview failed: ${response.status}';
    throw Exception(errorMsg);
  }

  final data = response.data;
  if (data is! Map<String, dynamic>) {
    return const LinkPreviewData();
  }

  final title = _normalizeTitle(data['title'] as String?);
  final imageUrl = data['imageUrl'] as String?;

  File? imageFile;
  if (imageUrl != null && imageUrl.isNotEmpty) {
    imageFile = await downloadImageToTempFile(imageUrl);
  }

  return LinkPreviewData(image: imageFile, title: title);
}

String? _normalizeTitle(String? t) {
  final s = t?.trim();
  if (s == null || s.isEmpty) {
    return null;
  }
  if (s.length < 10) {
    return null;
  }
  if (RegExp(r'^[a-z0-9_-]+$').hasMatch(s) && s.length < 20) {
    return null;
  }
  return s;
}

/// Télécharge une image depuis [imageUrl] vers un fichier temporaire.
/// Les fichiers sont créés dans [Directory.systemTemp] ; on ne les supprime pas
/// explicitement, le système d'exploitation assure le nettoyage.
Future<File?> downloadImageToTempFile(String imageUrl) async {
  try {
    final imageResponse = await http
        .get(Uri.parse(imageUrl), headers: _browserHeaders)
        .timeout(const Duration(seconds: 10));
    if (imageResponse.statusCode != 200 || imageResponse.bodyBytes.isEmpty) {
      return null;
    }
    final bytes = imageResponse.bodyBytes;
    if (bytes.length < 500) {
      return null;
    }
    final extFromBytes = _imageExtensionFromMagicBytes(bytes);
    if (extFromBytes == null) {
      return null;
    }
    final ext = _extensionFromMime(imageResponse.headers['content-type']) ??
        extFromBytes;
    final tempFile = File(
      '${Directory.systemTemp.path}/wish_preview_'
      '${DateTime.now().millisecondsSinceEpoch}.$ext',
    );
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('[Wishy link_preview] downloadImageToTempFile: $e');
      debugPrint(st.toString());
    }
    return null;
  }
}

String? _extensionFromMime(String? contentType) {
  if (contentType == null) {
    return null;
  }
  final lower = contentType.split(';').first.trim().toLowerCase();
  if (lower.contains('png')) {
    return 'png';
  }
  if (lower.contains('gif')) {
    return 'gif';
  }
  if (lower.contains('webp')) {
    return 'webp';
  }
  return 'jpg';
}

/// Reconnaît le format image à partir des magic bytes et retourne l’extension.
/// Utilisé pour valider que le corps de la réponse est bien une image et pour
/// choisir l’extension du fichier temporaire.
String? _imageExtensionFromMagicBytes(List<int> bytes) {
  if (bytes.length < 4) return null;

  // PNG: 89 50 4E 47
  const png = [0x89, 0x50, 0x4E, 0x47];
  if (bytes.length >= png.length &&
      bytes[0] == png[0] &&
      bytes[1] == png[1] &&
      bytes[2] == png[2] &&
      bytes[3] == png[3]) {
    return 'png';
  }

  // JPEG: FF D8 FF
  const jpeg = [0xFF, 0xD8, 0xFF];
  if (bytes.length >= jpeg.length &&
      bytes[0] == jpeg[0] &&
      bytes[1] == jpeg[1] &&
      bytes[2] == jpeg[2]) {
    return 'jpg';
  }

  // GIF: 47 49 46 38 (GIF8)
  const gif = [0x47, 0x49, 0x46, 0x38];
  if (bytes.length >= gif.length &&
      bytes[0] == gif[0] &&
      bytes[1] == gif[1] &&
      bytes[2] == gif[2] &&
      bytes[3] == gif[3]) {
    return 'gif';
  }

  // WebP: RIFF (0–3) … WEBP (8–11)
  const riff = [0x52, 0x49, 0x46, 0x46];
  const webp = [0x57, 0x45, 0x42, 0x50];
  if (bytes.length >= 12 &&
      bytes[0] == riff[0] &&
      bytes[1] == riff[1] &&
      bytes[2] == riff[2] &&
      bytes[3] == riff[3] &&
      bytes[8] == webp[0] &&
      bytes[9] == webp[1] &&
      bytes[10] == webp[2] &&
      bytes[11] == webp[3]) {
    return 'webp';
  }

  return null;
}
