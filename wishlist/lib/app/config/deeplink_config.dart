abstract class DeeplinkConfig {
  /// Must match android:scheme in AndroidManifest.xml
  /// and CFBundleURLSchemes in Info.plist
  static const String scheme = 'wishy';

  /// Must match android:host in AndroidManifest.xml
  /// and CFBundleURLName in Info.plist
  static const String host = 'com.raphtang.wishy';

  static Uri buildDeeplinkUri({
    required String path,
  }) {
    return Uri(
      scheme: scheme,
      host: host,
      pathSegments:
          path.split('/').where((segment) => segment.isNotEmpty).toList(),
    );
  }

  static bool isValidDeeplink(Uri uri) {
    return uri.scheme == scheme && uri.host == host;
  }
}
