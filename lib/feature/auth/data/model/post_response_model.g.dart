// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostResponseModelImpl _$$PostResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PostResponseModelImpl(
      posts: (json['posts'] as List<dynamic>?)
              ?.map((e) => PostModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      skip: (json['skip'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PostResponseModelImplToJson(
        _$PostResponseModelImpl instance) =>
    <String, dynamic>{
      'posts': instance.posts,
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };
