// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reactions_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReactionsModel _$ReactionsModelFromJson(Map<String, dynamic> json) {
  return _ReactionsModel.fromJson(json);
}

/// @nodoc
mixin _$ReactionsModel {
  int get likes => throw _privateConstructorUsedError;
  int get dislikes => throw _privateConstructorUsedError;

  /// Serializes this ReactionsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReactionsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReactionsModelCopyWith<ReactionsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionsModelCopyWith<$Res> {
  factory $ReactionsModelCopyWith(
          ReactionsModel value, $Res Function(ReactionsModel) then) =
      _$ReactionsModelCopyWithImpl<$Res, ReactionsModel>;
  @useResult
  $Res call({int likes, int dislikes});
}

/// @nodoc
class _$ReactionsModelCopyWithImpl<$Res, $Val extends ReactionsModel>
    implements $ReactionsModelCopyWith<$Res> {
  _$ReactionsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReactionsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? likes = null,
    Object? dislikes = null,
  }) {
    return _then(_value.copyWith(
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      dislikes: null == dislikes
          ? _value.dislikes
          : dislikes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReactionsModelImplCopyWith<$Res>
    implements $ReactionsModelCopyWith<$Res> {
  factory _$$ReactionsModelImplCopyWith(_$ReactionsModelImpl value,
          $Res Function(_$ReactionsModelImpl) then) =
      __$$ReactionsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int likes, int dislikes});
}

/// @nodoc
class __$$ReactionsModelImplCopyWithImpl<$Res>
    extends _$ReactionsModelCopyWithImpl<$Res, _$ReactionsModelImpl>
    implements _$$ReactionsModelImplCopyWith<$Res> {
  __$$ReactionsModelImplCopyWithImpl(
      _$ReactionsModelImpl _value, $Res Function(_$ReactionsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReactionsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? likes = null,
    Object? dislikes = null,
  }) {
    return _then(_$ReactionsModelImpl(
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      dislikes: null == dislikes
          ? _value.dislikes
          : dislikes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReactionsModelImpl implements _ReactionsModel {
  const _$ReactionsModelImpl({this.likes = 0, this.dislikes = 0});

  factory _$ReactionsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReactionsModelImplFromJson(json);

  @override
  @JsonKey()
  final int likes;
  @override
  @JsonKey()
  final int dislikes;

  @override
  String toString() {
    return 'ReactionsModel(likes: $likes, dislikes: $dislikes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionsModelImpl &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.dislikes, dislikes) ||
                other.dislikes == dislikes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, likes, dislikes);

  /// Create a copy of ReactionsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactionsModelImplCopyWith<_$ReactionsModelImpl> get copyWith =>
      __$$ReactionsModelImplCopyWithImpl<_$ReactionsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReactionsModelImplToJson(
      this,
    );
  }
}

abstract class _ReactionsModel implements ReactionsModel {
  const factory _ReactionsModel({final int likes, final int dislikes}) =
      _$ReactionsModelImpl;

  factory _ReactionsModel.fromJson(Map<String, dynamic> json) =
      _$ReactionsModelImpl.fromJson;

  @override
  int get likes;
  @override
  int get dislikes;

  /// Create a copy of ReactionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReactionsModelImplCopyWith<_$ReactionsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
