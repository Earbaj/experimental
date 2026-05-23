import 'package:geolocator/geolocator.dart';
import 'package:untitled1/feature/auth/data/model/location_model.dart';
import 'package:untitled1/feature/auth/domain/entity/location_entity.dart';

import '../../../../core/helper/database_helper.dart';

abstract class LocationLocalDataSource {
  Stream<Position> getPositionStream();
  Future<Position> getCurrentPosition();
  Future<void> saveLocation(LocationModel location);
  Future<List<LocationModel>> getSavedLocations();
  Future<List<LocationModel>> getUnsyncedLocations();
  Future<void> markAsSynced(String id);
  Future<void> deleteLocation(String id);
  Future<void> deleteAllLocations();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final DatabaseHelper databaseHelper;

  LocationLocalDataSourceImpl(this.databaseHelper);

  @override
  Stream<Position> getPositionStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // 10 meters
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  @override
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Future<void> saveLocation(LocationModel location) async {
    await databaseHelper.insertLocation(location.toMap());
  }

  @override
  Future<List<LocationModel>> getSavedLocations() async {
    final maps = await databaseHelper.getLocations();
    return maps.map((map) => LocationModel.fromMap(map)).toList();
  }

  @override
  Future<List<LocationModel>> getUnsyncedLocations() async {
    final maps = await databaseHelper.getUnsyncedLocations();
    return maps.map((map) => LocationModel.fromMap(map)).toList();
  }

  @override
  Future<void> markAsSynced(String id) async {
    await databaseHelper.markLocationAsSynced(id);
  }

  @override
  Future<void> deleteLocation(String id) async {
    await databaseHelper.deleteLocation(id);
  }

  @override
  Future<void> deleteAllLocations() async {
    await databaseHelper.deleteAllLocations();
  }
}