import '../../../../core/error/failures.dart';
import '../entity/location_entity.dart';
import '../repository/location_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<Either<Failure, LocationEntity>> call() async {
    try {
      final location = await repository.getCurrentLocation();
      return Right(location);
    } catch (e) {
      return Left(LocationServiceFailure(e.toString()));
    }
  }
}