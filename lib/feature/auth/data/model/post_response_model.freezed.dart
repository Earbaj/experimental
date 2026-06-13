// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostResponseModel _$PostResponseModelFromJson(Map<String, dynamic> json) {
  return _PostResponseModel.fromJson(json);
}

/// @nodoc
mixin _$PostResponseModel {
  List<PostModel> get posts => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get skip => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  /// Serializes this PostResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostResponseModelCopyWith<PostResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostResponseModelCopyWith<$Res> {
  factory $PostResponseModelCopyWith(
          PostResponseModel value, $Res Function(PostResponseModel) then) =
      _$PostResponseModelCopyWithImpl<$Res, PostResponseModel>;
  @useResult
  $Res call({List<PostModel> posts, int total, int skip, int limit});
}

/// @nodoc
class _$PostResponseModelCopyWithImpl<$Res, $Val extends PostResponseModel>
    implements $PostResponseModelCopyWith<$Res> {
  _$PostResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
  }) {
    return _then(_value.copyWith(
      posts: null == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<PostModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      skip: null == skip
          ? _value.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostResponseModelImplCopyWith<$Res>
    implements $PostResponseModelCopyWith<$Res> {
  factory _$$PostResponseModelImplCopyWith(_$PostResponseModelImpl value,
          $Res Function(_$PostResponseModelImpl) then) =
      __$$PostResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PostModel> posts, int total, int skip, int limit});
}

/// @nodoc
class __$$PostResponseModelImplCopyWithImpl<$Res>
    extends _$PostResponseModelCopyWithImpl<$Res, _$PostResponseModelImpl>
    implements _$$PostResponseModelImplCopyWith<$Res> {
  __$$PostResponseModelImplCopyWithImpl(_$PostResponseModelImpl _value,
      $Res Function(_$PostResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
  }) {
    return _then(_$PostResponseModelImpl(
      posts: null == posts
          ? _value._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<PostModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      skip: null == skip
          ? _value.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostResponseModelImpl implements _PostResponseModel {
  const _$PostResponseModelImpl(
      {final List<PostModel> posts = const [],
      this.total = 0,
      this.skip = 0,
      this.limit = 0})
      : _posts = posts;

  factory _$PostResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostResponseModelImplFromJson(json);

  final List<PostModel> _posts;
  @override
  @JsonKey()
  List<PostModel> get posts {
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_posts);
  }

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int skip;
  @override
  @JsonKey()
  final int limit;

  @override
  String toString() {
    return 'PostResponseModel(posts: $posts, total: $total, skip: $skip, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostResponseModelImpl &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_posts), total, skip, limit);

  /// Create a copy of PostResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostResponseModelImplCopyWith<_$PostResponseModelImpl> get copyWith =>
      __$$PostResponseModelImplCopyWithImpl<_$PostResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostResponseModelImplToJson(
      this,
    );
  }
}

abstract class _PostResponseModel implements PostResponseModel {
  const factory _PostResponseModel(
      {final List<PostModel> posts,
      final int total,
      final int skip,
      final int limit}) = _$PostResponseModelImpl;

  factory _PostResponseModel.fromJson(Map<String, dynamic> json) =
      _$PostResponseModelImpl.fromJson;

  @override
  List<PostModel> get posts;
  @override
  int get total;
  @override
  int get skip;
  @override
  int get limit;

  /// Create a copy of PostResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostResponseModelImplCopyWith<_$PostResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
