import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repository/location_repository.dart';

class SyncOfflineLocationsUseCase {
  final LocationRepository repository;

  SyncOfflineLocationsUseCase(this.repository);

  Future<Either<Failure, int>> call() async {
    try {
      // ১. অফলাইন ডাটা সিঙ্ক করা
      await repository.syncOfflineLocations();

      // ২. সেভ করা লোকেশন গুলো পাওয়া
      final savedLocations = await repository.getSavedLocations();

      // ৩. কতগুলো সিঙ্ক হলো তা রিটার্ন
      return Right(savedLocations.length);

    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}