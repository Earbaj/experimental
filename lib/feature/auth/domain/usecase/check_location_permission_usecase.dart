import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repository/location_repository.dart';

class CheckLocationPermissionUseCase {
  final LocationRepository repository;

  CheckLocationPermissionUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    try {
      final hasPermission = await repository.checkAndRequestPermission();
      return Right(hasPermission);
    } catch (e) {
      return Left(PermissionFailure(e.toString()));
    }
  }
}