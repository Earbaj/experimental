// Extension Method Mapper
import 'package:geolocator/geolocator.dart';

import '../../domain/entity/location_entity.dart';
import '../model/location_model.dart';

extension LocationModelToEntity on LocationModel {
  LocationEntity toEntity() {
    return LocationEntity(
      id: id,
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
      accuracy: accuracy,
      speed: speed,
      userId: userId,
    );
  }
}

extension LocationEntityToModel on LocationEntity {
  LocationModel toModel({bool isSynced = false}) {
    return LocationModel(
      id: id,
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
      accuracy: accuracy,
      speed: speed,
      userId: userId,
      isSynced: isSynced,
    );
  }
}

extension LocationModelListToEntityList on List<LocationModel> {
  List<LocationEntity> toEntityList() {
    return map((model) => model.toEntity()).toList();
  }
}

extension LocationEntityListToModelList on List<LocationEntity> {
  List<LocationModel> toModelList({bool isSynced = false}) {
    return map((entity) => entity.toModel(isSynced: isSynced)).toList();
  }
}

// Position (geolocator) to Entity Extension
extension PositionToLocationEntity on Position {
  LocationEntity toLocationEntity({String? userId}) {
    return LocationEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
      accuracy: accuracy,
      speed: speed,
      userId: userId,
    );
  }
}