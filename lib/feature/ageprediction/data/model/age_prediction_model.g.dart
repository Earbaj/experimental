// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'age_prediction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgePredictionModel _$AgePredictionModelFromJson(Map<String, dynamic> json) =>
    AgePredictionModel(
      count: (json['count'] as num).toInt(),
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      countryId: json['country_id'] as String,
    );

Map<String, dynamic> _$AgePredictionModelToJson(AgePredictionModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'name': instance.name,
      'age': instance.age,
      'country_id': instance.countryId,
    };
