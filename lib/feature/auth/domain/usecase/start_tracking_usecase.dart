
import '../../../../core/error/failures.dart';
import '../repository/location_repository.dart';
import 'package:dartz/dartz.dart';

class StartTrackingUseCase {
  final LocationRepository repository;

  StartTrackingUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    try {
      final hasPermission = await repository.checkAndRequestPermission();
      if (!hasPermission) {
        return Left(PermissionFailure('Location permission denied'));
      }

      await repository.startBackgroundTracking();
      return Right(true);
    } catch (e) {
      return Left(LocationServiceFailure(e.toString()));
    }
  }
}