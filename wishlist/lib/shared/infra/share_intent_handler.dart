import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_intent_package/share_intent_package.dart';
import 'package:wishlist/app/navigation/router.dart';
import 'package:wishlist/shared/infra/link_preview_client.dart';
import 'package:wishlist/shared/infra/share_intent_payload_provider.dart';
import 'package:wishlist/shared/models/wish_prefill_data/wish_prefill_data.dart';
import 'package:wishlist/shared/navigation/routes.dart';

/// Écoute le share intent (share_intent_package) et navigue vers add-wish
/// avec les données préremplies.
class ShareIntentHandler extends ConsumerStatefulWidget {
  const ShareIntentHandler({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<ShareIntentHandler> createState() => _ShareIntentHandlerState();
}

class _ShareIntentHandlerState extends ConsumerState<ShareIntentHandler>
    with WidgetsBindingObserver {
  static const _kResumedShareDelayMs = 250;
  static const _kNavigateAfterPayloadDelayMs = 350;

  StreamSubscription<SharedData>? _mediaStreamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (kDebugMode) {
      debugPrint(
        '[Wishy Share] ShareIntentHandler initState (iOS=${Platform.isIOS})',
      );
    }
    unawaited(_initShareIntent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mediaStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && Platform.isIOS) {
      Future<void>.delayed(
        const Duration(milliseconds: _kResumedShareDelayMs),
        () {
          if (!mounted) {
            return;
          }
          unawaited(_tryGetInitialSharing());
        },
      );
    }
  }

  Future<void> _initShareIntent() async {
    if (Platform.isIOS) {
      await ShareIntentPackage.instance.init(
        appGroupId: 'group.com.raphtang.wishy',
      );
    }

    var initial = await ShareIntentPackage.instance.getInitialSharing();
    // Fallback iOS : données lues par le Runner dans application(open url) ou
    // via le canal depuis le conteneur
    if (Platform.isIOS && (initial == null || !initial.hasContent) && mounted) {
      final fromContainer = await _getSharedDataFromContainerWithRetry();
      if (fromContainer != null && fromContainer.hasContent) {
        initial = fromContainer;
        if (kDebugMode) {
          debugPrint(
            '[Wishy Share] Using shared data from container (fallback)',
          );
        }
      }
    }
    if (initial != null && initial.hasContent && mounted) {
      await _handleSharedData(initial);
      await ShareIntentPackage.instance.reset();
    }

    _mediaStreamSubscription =
        ShareIntentPackage.instance.getMediaStream().listen((data) async {
      var effective = data;
      // iOS warm start : le plugin reçoit l’URL mais UserDefaults renvoie
      // souvent {} ; utiliser le conteneur.
      if (Platform.isIOS && (!data.hasContent) && mounted) {
        // Délai pour laisser application(open url) s’exécuter et lire le
        // fichier avant nous.
        await Future<void>.delayed(const Duration(milliseconds: 450));
        if (!mounted) {
          return;
        }
        final fromContainer = await _getSharedDataFromContainerWithRetry();
        if (fromContainer != null && fromContainer.hasContent) {
          effective = fromContainer;
          if (kDebugMode) {
            debugPrint(
              '[Wishy Share] Using shared data from container '
              '(stream fallback)',
            );
          }
        }
      }
      if (effective.hasContent && mounted) {
        await _handleSharedData(effective);
        if (mounted) {
          await ShareIntentPackage.instance.reset();
        }
      }
    });
  }

  Future<void> _tryGetInitialSharing() async {
    try {
      var data = await ShareIntentPackage.instance.getInitialSharing();
      if (Platform.isIOS && (data == null || !data.hasContent) && mounted) {
        data = await _getSharedDataFromContainer();
      }
      if (data != null && data.hasContent && mounted) {
        await _handleSharedData(data);
        await ShareIntentPackage.instance.reset();
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[Wishy Share] _tryGetInitialSharing: $e');
        debugPrint(st.toString());
      }
    }
  }

  /// Lecture des données partagées depuis le conteneur
  /// (lues par le Runner à l’ouverture ou depuis le fichier).
  /// Plusieurs tentatives pour laisser le temps au MethodChannel de
  /// s’enregistrer au cold start.
  Future<SharedData?> _getSharedDataFromContainerWithRetry() async {
    const maxAttempts = 5;
    const delayMs = 200;
    for (var attempt = 0; attempt < maxAttempts && mounted; attempt++) {
      if (attempt > 0) {
        await Future<void>.delayed(const Duration(milliseconds: delayMs));
        if (!mounted) {
          return null;
        }
      }
      final data = await _getSharedDataFromContainer();
      if (data != null && data.hasContent) {
        return data;
      }
    }
    return null;
  }

  Future<SharedData?> _getSharedDataFromContainer() async {
    try {
      final json =
          await _channel.invokeMethod<String>('getSharedDataFromContainer');
      if (json == null || json.isEmpty) {
        return null;
      }
      final map = jsonDecode(json) as Map<String, dynamic>?;
      if (map == null || map.isEmpty) {
        return null;
      }
      return SharedData.fromMap(map);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('[Wishy Share] getSharedDataFromContainer: $e');
      }
      return null;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[Wishy Share] getSharedDataFromContainer parse/error: $e');
        debugPrint(st.toString());
      }
      return null;
    }
  }

  Future<void> _handleSharedData(SharedData data) async {
    if (!data.hasContent) {
      return;
    }

    if (kDebugMode) {
      debugPrint(
        '[Wishy Share] SharedData: text=${data.text?.length ?? 0} chars '
        'filePaths=${data.filePaths.length} isImage=${data.isImage}',
      );
    }

    var text = data.text?.trim();
    var imagePath = _firstImagePath(data);

    if (Platform.isAndroid &&
        (text == null || text.isEmpty || text.startsWith('content://'))) {
      final platformText = await _getSharedTextFromPlatform();
      if (platformText != null && platformText.isNotEmpty) {
        text = platformText;
      }
    }

    var prefill = text != null && text.isNotEmpty
        ? WishPrefillData.fromSharedText(text)
        : null;

    if (Platform.isAndroid && prefill != null && prefill.hasData) {
      final extrasResult = await _applyAndroidExtras(prefill);
      prefill = extrasResult.prefill;
      imagePath ??= extrasResult.imagePath;
    }

    final hasPrefill = prefill != null && prefill.hasData;
    if (!hasPrefill && imagePath == null) {
      return;
    }
    if (!mounted) {
      return;
    }

    ref.read(shareIntentPayloadNotifierProvider.notifier).setPayload(
          prefill: hasPrefill ? prefill : null,
          imagePath: imagePath,
        );

    final location = AddWishRoute().location;
    Future<void>.delayed(
      const Duration(milliseconds: _kNavigateAfterPayloadDelayMs),
      () {
        if (kDebugMode) {
          debugPrint('[Wishy Share] navigating to $location');
        }
        router.go(location);
      },
    );
  }

  String? _firstImagePath(SharedData data) {
    if (data.filePaths.isEmpty) {
      return null;
    }
    if (data.isImage) {
      return data.filePaths.first;
    }
    final first = data.filePaths.first;
    final ext = first.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif', 'bmp']
        .contains(ext)) {
      return first;
    }
    return null;
  }

  static const _channel = MethodChannel('com.raphtang.wishy/share_intent');

  Future<String?> _getSharedTextFromPlatform() async {
    try {
      final result =
          await _channel.invokeMethod<String>('getInitialSharedText');
      return result?.trim();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('[ShareIntent] getInitialSharedText failed: $e');
      }
      return null;
    }
  }

  Future<Map<String, String>?> _getShareExtrasFromPlatform() async {
    try {
      final result = await _channel
          .invokeMethod<Map<Object?, Object?>>('getInitialShareExtras');
      if (result == null || result.isEmpty) {
        return null;
      }
      return result
          .map((k, v) => MapEntry(k?.toString() ?? '', v?.toString() ?? ''));
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('[ShareIntent] getInitialShareExtras failed: $e');
      }
      return null;
    }
  }

  Future<({WishPrefillData? prefill, String? imagePath})> _applyAndroidExtras(
    WishPrefillData? prefill,
  ) async {
    if (!Platform.isAndroid) {
      return (prefill: prefill, imagePath: null);
    }
    final extras = await _getShareExtrasFromPlatform();
    if (extras == null || extras.isEmpty) {
      return (prefill: prefill, imagePath: null);
    }
    var result = prefill;
    final linkUrl = extras['url'];
    if (linkUrl != null && linkUrl.startsWith('http')) {
      result = (result ?? const WishPrefillData()).copyWith(linkUrl: linkUrl);
    }
    String? downloadedImagePath;
    final imgUrl = extras['imgUrl'];
    if (imgUrl != null && imgUrl.startsWith('http')) {
      final imgUrlToUse = imgUrl.replaceAll(RegExp(r'_SS\d+_'), '_SS500_');
      final file = await downloadImageToTempFile(imgUrlToUse);
      if (file != null) {
        downloadedImagePath = file.path;
      }
    }
    return (prefill: result, imagePath: downloadedImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
