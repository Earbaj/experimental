import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entity/location_entity.dart';
import '../repository/location_repository.dart';

class GetSavedLocationsUseCase {
  final LocationRepository repository;

  GetSavedLocationsUseCase(this.repository);

  Future<Either<Failure, List<LocationEntity>>> call() async {
    try {
      final locations = await repository.getSavedLocations();
      return Right(locations);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}