
import 'package:dartz/dartz.dart';

import '../entity/location_entity.dart';
import '../repository/location_repository.dart';

class GetLocationStreamUseCase {
  final LocationRepository repository;

  GetLocationStreamUseCase(this.repository);

  // Stream এর জন্য Either ব্যবহার করা যায় না, কারণ Stream async
  // তাই সরাসরি Stream রিটার্ন করবেন
  Stream<LocationEntity> call() {
    return repository.getLocationStream();
  }
}