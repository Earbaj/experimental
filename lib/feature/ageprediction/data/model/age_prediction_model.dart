// lib/data/models/age_prediction_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'age_prediction_model.g.dart';

@JsonSerializable()
class AgePredictionModel {
  final int count;
  final String name;
  final int age;
  @JsonKey(name: 'country_id')
  final String countryId;

  AgePredictionModel({
    required this.count,
    required this.name,
    required this.age,
    required this.countryId,
  });

  factory AgePredictionModel.fromJson(Map<String, dynamic> json) =>
      _$AgePredictionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AgePredictionModelToJson(this);
}