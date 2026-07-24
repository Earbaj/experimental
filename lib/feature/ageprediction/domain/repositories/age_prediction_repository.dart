
import '../entity/age_prediction.dart';

abstract class AgePredictionRepository {
  Future<AgePrediction> getAgePrediction(String name, String countryId);
}