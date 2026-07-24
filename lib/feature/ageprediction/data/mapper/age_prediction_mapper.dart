import '../../domain/entity/age_prediction.dart';
import '../model/age_prediction_model.dart';

extension AgePredictionModelMapper on AgePredictionModel {
  AgePrediction toEntity() {
    return AgePrediction(
      count: count,
      name: name,
      age: age,
      countryId: countryId,
    );
  }
}

extension AgePredictionEntityMapper on AgePrediction {
  AgePredictionModel toModel() {
    return AgePredictionModel(
      count: count,
      name: name,
      age: age,
      countryId: countryId,
    );
  }
}