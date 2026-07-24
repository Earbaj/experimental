import '../entity/age_prediction.dart';
import '../repositories/age_prediction_repository.dart';

class GetAgePredictionUseCase {
  final AgePredictionRepository repository;

  GetAgePredictionUseCase(this.repository);

  Future<AgePrediction> call(String name, String countryId) {
    return repository.getAgePrediction(name, countryId);
  }
}