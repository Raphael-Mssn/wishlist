// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_wishes_realtime_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$completedWishesRealtimeHash() =>
    r'4ea08e11cec9142c5e7dc7f0bb574be6e5cbda99';

/// StreamProvider qui écoute en temps réel tous les wishs complétés
/// par l'utilisateur courant.
///
/// Se met à jour automatiquement quand :
/// - L'utilisateur complète/dé-complète un wish (user_completed_wishs)
/// - Un wish complété est modifié/supprimé (wishs)
/// - La wishlist d'origine est renommée (wishlists)
/// - Le pseudo/avatar du propriétaire change (profiles)
///
/// Copied from [completedWishesRealtime].
@ProviderFor(completedWishesRealtime)
final completedWishesRealtimeProvider =
    AutoDisposeStreamProvider<IList<CompletedWishWithDetails>>.internal(
  completedWishesRealtime,
  name: r'completedWishesRealtimeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedWishesRealtimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletedWishesRealtimeRef
    = AutoDisposeStreamProviderRef<IList<CompletedWishWithDetails>>;
String _$completedWishesByUserRealtimeHash() =>
    r'2fbeeb6972e5071b78e254ff6a9ad6855bfe98f1';

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

/// StreamProvider paramétré pour les wishs complétés d'un autre utilisateur.
///
/// Copied from [completedWishesByUserRealtime].
@ProviderFor(completedWishesByUserRealtime)
const completedWishesByUserRealtimeProvider =
    CompletedWishesByUserRealtimeFamily();

/// StreamProvider paramétré pour les wishs complétés d'un autre utilisateur.
///
/// Copied from [completedWishesByUserRealtime].
class CompletedWishesByUserRealtimeFamily
    extends Family<AsyncValue<IList<CompletedWishWithDetails>>> {
  /// StreamProvider paramétré pour les wishs complétés d'un autre utilisateur.
  ///
  /// Copied from [completedWishesByUserRealtime].
  const CompletedWishesByUserRealtimeFamily();

  /// StreamProvider paramétré pour les wishs complétés d'un autre utilisateur.
  ///
  /// Copied from [completedWishesByUserRealtime].
  CompletedWishesByUserRealtimeProvider call(
    String userId,
  ) {
    return CompletedWishesByUserRealtimeProvider(
      userId,
    );
  }

  @override
  CompletedWishesByUserRealtimeProvider getProviderOverride(
    covariant CompletedWishesByUserRealtimeProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'completedWishesByUserRealtimeProvider';
}

/// StreamProvider paramétré pour les wishs complétés d'un autre utilisateur.
///
/// Copied from [completedWishesByUserRealtime].
class CompletedWishesByUserRealtimeProvider
    extends AutoDisposeStreamProvider<IList<CompletedWishWithDetails>> {
  /// StreamProvider paramétré pour les wishs complétés d'un autre utilisateur.
  ///
  /// Copied from [completedWishesByUserRealtime].
  CompletedWishesByUserRealtimeProvider(
    String userId,
  ) : this._internal(
          (ref) => completedWishesByUserRealtime(
            ref as CompletedWishesByUserRealtimeRef,
            userId,
          ),
          from: completedWishesByUserRealtimeProvider,
          name: r'completedWishesByUserRealtimeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$completedWishesByUserRealtimeHash,
          dependencies: CompletedWishesByUserRealtimeFamily._dependencies,
          allTransitiveDependencies:
              CompletedWishesByUserRealtimeFamily._allTransitiveDependencies,
          userId: userId,
        );

  CompletedWishesByUserRealtimeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<IList<CompletedWishWithDetails>> Function(
            CompletedWishesByUserRealtimeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompletedWishesByUserRealtimeProvider._internal(
        (ref) => create(ref as CompletedWishesByUserRealtimeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<IList<CompletedWishWithDetails>>
      createElement() {
    return _CompletedWishesByUserRealtimeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompletedWishesByUserRealtimeProvider &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CompletedWishesByUserRealtimeRef
    on AutoDisposeStreamProviderRef<IList<CompletedWishWithDetails>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _CompletedWishesByUserRealtimeProviderElement
    extends AutoDisposeStreamProviderElement<IList<CompletedWishWithDetails>>
    with CompletedWishesByUserRealtimeRef {
  _CompletedWishesByUserRealtimeProviderElement(super.provider);

  @override
  String get userId => (origin as CompletedWishesByUserRealtimeProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
