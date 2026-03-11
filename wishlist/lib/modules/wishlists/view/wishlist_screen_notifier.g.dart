// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_screen_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wishlistScreenNotifierHash() =>
    r'b86f09a7d2801acf0fc93e4b623c72b1dc5e938c';

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

abstract class _$WishlistScreenNotifier
    extends BuildlessAutoDisposeNotifier<WishlistScreenState> {
  late final int wishlistId;

  WishlistScreenState build(
    int wishlistId,
  );
}

/// See also [WishlistScreenNotifier].
@ProviderFor(WishlistScreenNotifier)
const wishlistScreenNotifierProvider = WishlistScreenNotifierFamily();

/// See also [WishlistScreenNotifier].
class WishlistScreenNotifierFamily extends Family<WishlistScreenState> {
  /// See also [WishlistScreenNotifier].
  const WishlistScreenNotifierFamily();

  /// See also [WishlistScreenNotifier].
  WishlistScreenNotifierProvider call(
    int wishlistId,
  ) {
    return WishlistScreenNotifierProvider(
      wishlistId,
    );
  }

  @override
  WishlistScreenNotifierProvider getProviderOverride(
    covariant WishlistScreenNotifierProvider provider,
  ) {
    return call(
      provider.wishlistId,
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
  String? get name => r'wishlistScreenNotifierProvider';
}

/// See also [WishlistScreenNotifier].
class WishlistScreenNotifierProvider extends AutoDisposeNotifierProviderImpl<
    WishlistScreenNotifier, WishlistScreenState> {
  /// See also [WishlistScreenNotifier].
  WishlistScreenNotifierProvider(
    int wishlistId,
  ) : this._internal(
          () => WishlistScreenNotifier()..wishlistId = wishlistId,
          from: wishlistScreenNotifierProvider,
          name: r'wishlistScreenNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wishlistScreenNotifierHash,
          dependencies: WishlistScreenNotifierFamily._dependencies,
          allTransitiveDependencies:
              WishlistScreenNotifierFamily._allTransitiveDependencies,
          wishlistId: wishlistId,
        );

  WishlistScreenNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.wishlistId,
  }) : super.internal();

  final int wishlistId;

  @override
  WishlistScreenState runNotifierBuild(
    covariant WishlistScreenNotifier notifier,
  ) {
    return notifier.build(
      wishlistId,
    );
  }

  @override
  Override overrideWith(WishlistScreenNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WishlistScreenNotifierProvider._internal(
        () => create()..wishlistId = wishlistId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        wishlistId: wishlistId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WishlistScreenNotifier,
      WishlistScreenState> createElement() {
    return _WishlistScreenNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WishlistScreenNotifierProvider &&
        other.wishlistId == wishlistId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wishlistId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WishlistScreenNotifierRef
    on AutoDisposeNotifierProviderRef<WishlistScreenState> {
  /// The parameter `wishlistId` of this provider.
  int get wishlistId;
}

class _WishlistScreenNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<WishlistScreenNotifier,
        WishlistScreenState> with WishlistScreenNotifierRef {
  _WishlistScreenNotifierProviderElement(super.provider);

  @override
  int get wishlistId => (origin as WishlistScreenNotifierProvider).wishlistId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
