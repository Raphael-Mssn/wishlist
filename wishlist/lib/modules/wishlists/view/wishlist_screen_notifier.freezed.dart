// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_screen_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WishlistScreenState {
  WishlistStatsCardType get statCardSelected =>
      throw _privateConstructorUsedError;
  WishSort get wishSort => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  bool get isSelectionMode => throw _privateConstructorUsedError;
  Set<int> get selectedWishIds => throw _privateConstructorUsedError;

  /// Create a copy of WishlistScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishlistScreenStateCopyWith<WishlistScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistScreenStateCopyWith<$Res> {
  factory $WishlistScreenStateCopyWith(
          WishlistScreenState value, $Res Function(WishlistScreenState) then) =
      _$WishlistScreenStateCopyWithImpl<$Res, WishlistScreenState>;
  @useResult
  $Res call(
      {WishlistStatsCardType statCardSelected,
      WishSort wishSort,
      String searchQuery,
      bool isSelectionMode,
      Set<int> selectedWishIds});
}

/// @nodoc
class _$WishlistScreenStateCopyWithImpl<$Res, $Val extends WishlistScreenState>
    implements $WishlistScreenStateCopyWith<$Res> {
  _$WishlistScreenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishlistScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statCardSelected = null,
    Object? wishSort = null,
    Object? searchQuery = null,
    Object? isSelectionMode = null,
    Object? selectedWishIds = null,
  }) {
    return _then(_value.copyWith(
      statCardSelected: null == statCardSelected
          ? _value.statCardSelected
          : statCardSelected // ignore: cast_nullable_to_non_nullable
              as WishlistStatsCardType,
      wishSort: null == wishSort
          ? _value.wishSort
          : wishSort // ignore: cast_nullable_to_non_nullable
              as WishSort,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      isSelectionMode: null == isSelectionMode
          ? _value.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedWishIds: null == selectedWishIds
          ? _value.selectedWishIds
          : selectedWishIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WishlistScreenStateImplCopyWith<$Res>
    implements $WishlistScreenStateCopyWith<$Res> {
  factory _$$WishlistScreenStateImplCopyWith(_$WishlistScreenStateImpl value,
          $Res Function(_$WishlistScreenStateImpl) then) =
      __$$WishlistScreenStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {WishlistStatsCardType statCardSelected,
      WishSort wishSort,
      String searchQuery,
      bool isSelectionMode,
      Set<int> selectedWishIds});
}

/// @nodoc
class __$$WishlistScreenStateImplCopyWithImpl<$Res>
    extends _$WishlistScreenStateCopyWithImpl<$Res, _$WishlistScreenStateImpl>
    implements _$$WishlistScreenStateImplCopyWith<$Res> {
  __$$WishlistScreenStateImplCopyWithImpl(_$WishlistScreenStateImpl _value,
      $Res Function(_$WishlistScreenStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WishlistScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statCardSelected = null,
    Object? wishSort = null,
    Object? searchQuery = null,
    Object? isSelectionMode = null,
    Object? selectedWishIds = null,
  }) {
    return _then(_$WishlistScreenStateImpl(
      statCardSelected: null == statCardSelected
          ? _value.statCardSelected
          : statCardSelected // ignore: cast_nullable_to_non_nullable
              as WishlistStatsCardType,
      wishSort: null == wishSort
          ? _value.wishSort
          : wishSort // ignore: cast_nullable_to_non_nullable
              as WishSort,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      isSelectionMode: null == isSelectionMode
          ? _value.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedWishIds: null == selectedWishIds
          ? _value._selectedWishIds
          : selectedWishIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
    ));
  }
}

/// @nodoc

class _$WishlistScreenStateImpl implements _WishlistScreenState {
  const _$WishlistScreenStateImpl(
      {this.statCardSelected = WishlistStatsCardType.pending,
      this.wishSort = const WishSort(
          type: WishSortType.favorite, order: SortOrder.descending),
      this.searchQuery = '',
      this.isSelectionMode = false,
      final Set<int> selectedWishIds = const <int>{}})
      : _selectedWishIds = selectedWishIds;

  @override
  @JsonKey()
  final WishlistStatsCardType statCardSelected;
  @override
  @JsonKey()
  final WishSort wishSort;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final bool isSelectionMode;
  final Set<int> _selectedWishIds;
  @override
  @JsonKey()
  Set<int> get selectedWishIds {
    if (_selectedWishIds is EqualUnmodifiableSetView) return _selectedWishIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedWishIds);
  }

  @override
  String toString() {
    return 'WishlistScreenState(statCardSelected: $statCardSelected, wishSort: $wishSort, searchQuery: $searchQuery, isSelectionMode: $isSelectionMode, selectedWishIds: $selectedWishIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistScreenStateImpl &&
            (identical(other.statCardSelected, statCardSelected) ||
                other.statCardSelected == statCardSelected) &&
            (identical(other.wishSort, wishSort) ||
                other.wishSort == wishSort) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.isSelectionMode, isSelectionMode) ||
                other.isSelectionMode == isSelectionMode) &&
            const DeepCollectionEquality()
                .equals(other._selectedWishIds, _selectedWishIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      statCardSelected,
      wishSort,
      searchQuery,
      isSelectionMode,
      const DeepCollectionEquality().hash(_selectedWishIds));

  /// Create a copy of WishlistScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistScreenStateImplCopyWith<_$WishlistScreenStateImpl> get copyWith =>
      __$$WishlistScreenStateImplCopyWithImpl<_$WishlistScreenStateImpl>(
          this, _$identity);
}

abstract class _WishlistScreenState implements WishlistScreenState {
  const factory _WishlistScreenState(
      {final WishlistStatsCardType statCardSelected,
      final WishSort wishSort,
      final String searchQuery,
      final bool isSelectionMode,
      final Set<int> selectedWishIds}) = _$WishlistScreenStateImpl;

  @override
  WishlistStatsCardType get statCardSelected;
  @override
  WishSort get wishSort;
  @override
  String get searchQuery;
  @override
  bool get isSelectionMode;
  @override
  Set<int> get selectedWishIds;

  /// Create a copy of WishlistScreenState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishlistScreenStateImplCopyWith<_$WishlistScreenStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
