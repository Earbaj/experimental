import '../../../../core/error/failures.dart';
import '../repository/location_repository.dart';
import 'package:dartz/dartz.dart';

class StopTrackingUseCase {
  final LocationRepository repository;

  StopTrackingUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    try {
      await repository.stopBackgroundTracking();
      return const Right(null);
    } catch (e) {
      return Left(LocationServiceFailure(e.toString()));
    }
  }
}