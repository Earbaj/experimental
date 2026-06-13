// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reactions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReactionsModelImpl _$$ReactionsModelImplFromJson(Map<String, dynamic> json) =>
    _$ReactionsModelImpl(
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      dislikes: (json['dislikes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReactionsModelImplToJson(
        _$ReactionsModelImpl instance) =>
    <String, dynamic>{
      'likes': instance.likes,
      'dislikes': instance.dislikes,
    };
