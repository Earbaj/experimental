
import 'package:untitled1/feature/auth/domain/entity/location_entity.dart';

abstract class LocationRepository {
  Future<bool> checkAndRequestPermission();
  Future<LocationEntity> getCurrentLocation();
  Stream<LocationEntity> getLocationStream();
  Future<void> saveLocationToLocal(LocationEntity location);
  Future<void> updateServerLocation(LocationEntity location);
  Future<void> startBackgroundTracking();
  Future<void> stopBackgroundTracking();
  Future<List<LocationEntity>> getSavedLocations();
  Future<void> syncOfflineLocations();
}