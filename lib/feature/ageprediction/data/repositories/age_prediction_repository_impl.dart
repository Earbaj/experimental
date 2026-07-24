import 'package:untitled1/feature/ageprediction/data/mapper/age_prediction_mapper.dart';

import '../../domain/entity/age_prediction.dart';
import '../../domain/repositories/age_prediction_repository.dart';
import '../datasources/age_prediction_remote_datasource.dart';
class AgePredictionRepositoryImpl implements AgePredictionRepository {
  final AgePredictionRemoteDataSource remoteDataSource;

  AgePredictionRepositoryImpl(this.remoteDataSource);

  @override
  Future<AgePrediction> getAgePrediction(String name, String countryId) async {
    final model = await remoteDataSource.getAgePrediction(name, countryId);
    return model.toEntity();
  }
}