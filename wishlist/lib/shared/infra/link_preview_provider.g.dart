// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_preview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$linkPreviewDataHash() => r'd183eac53db9ae74559c290dcfb192e10fdcef8c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Récupère image + titre pour une URL via l'Edge Function "link-preview".
///
/// Copied from [linkPreviewData].
@ProviderFor(linkPreviewData)
const linkPreviewDataProvider = LinkPreviewDataFamily();

/// Récupère image + titre pour une URL via l'Edge Function "link-preview".
///
/// Copied from [linkPreviewData].
class LinkPreviewDataFamily extends Family<AsyncValue<LinkPreviewData>> {
  /// Récupère image + titre pour une URL via l'Edge Function "link-preview".
  ///
  /// Copied from [linkPreviewData].
  const LinkPreviewDataFamily();

  /// Récupère image + titre pour une URL via l'Edge Function "link-preview".
  ///
  /// Copied from [linkPreviewData].
  LinkPreviewDataProvider call(
    String pageUrl,
  ) {
    return LinkPreviewDataProvider(
      pageUrl,
    );
  }

  @override
  LinkPreviewDataProvider getProviderOverride(
    covariant LinkPreviewDataProvider provider,
  ) {
    return call(
      provider.pageUrl,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'linkPreviewDataProvider';
}

/// Récupère image + titre pour une URL via l'Edge Function "link-preview".
///
/// Copied from [linkPreviewData].
class LinkPreviewDataProvider
    extends AutoDisposeFutureProvider<LinkPreviewData> {
  /// Récupère image + titre pour une URL via l'Edge Function "link-preview".
  ///
  /// Copied from [linkPreviewData].
  LinkPreviewDataProvider(
    String pageUrl,
  ) : this._internal(
          (ref) => linkPreviewData(
            ref as LinkPreviewDataRef,
            pageUrl,
          ),
          from: linkPreviewDataProvider,
          name: r'linkPreviewDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$linkPreviewDataHash,
          dependencies: LinkPreviewDataFamily._dependencies,
          allTransitiveDependencies:
              LinkPreviewDataFamily._allTransitiveDependencies,
          pageUrl: pageUrl,
        );

  LinkPreviewDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageUrl,
  }) : super.internal();

  final String pageUrl;

  @override
  Override overrideWith(
    FutureOr<LinkPreviewData> Function(LinkPreviewDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LinkPreviewDataProvider._internal(
        (ref) => create(ref as LinkPreviewDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageUrl: pageUrl,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LinkPreviewData> createElement() {
    return _LinkPreviewDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LinkPreviewDataProvider && other.pageUrl == pageUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LinkPreviewDataRef on AutoDisposeFutureProviderRef<LinkPreviewData> {
  /// The parameter `pageUrl` of this provider.
  String get pageUrl;
}

class _LinkPreviewDataProviderElement
    extends AutoDisposeFutureProviderElement<LinkPreviewData>
    with LinkPreviewDataRef {
  _LinkPreviewDataProviderElement(super.provider);

  @override
  String get pageUrl => (origin as LinkPreviewDataProvider).pageUrl;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
