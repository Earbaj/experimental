import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:untitled1/feature/auth/data/mapper/location_mappper.dart';
import 'package:untitled1/feature/auth/domain/entity/location_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/background_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../domain/repository/location_repository.dart';
import '../datasource/location_local_data_source.dart';
import '../datasource/location_remote_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource localDataSource;
  final LocationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final PermissionService permissionService;
  final BackgroundService backgroundService;

  StreamSubscription<Position>? _positionSubscription;
  final _locationStreamController = StreamController<LocationEntity>.broadcast();

  LocationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.permissionService,
    required this.backgroundService,
  });

  @override
  Future<bool> checkAndRequestPermission() async {
    return await permissionService.requestLocationPermission();
  }

  @override
  Future<LocationEntity> getCurrentLocation() async {
    try {
      final position = await localDataSource.getCurrentPosition();
      return position.toLocationEntity();
    } catch (e) {
      throw LocationServiceException(e.toString());
    }
  }

  @override
  Stream<LocationEntity> getLocationStream() {
    _positionSubscription?.cancel();

    _positionSubscription = localDataSource.getPositionStream().listen(
          (position) {
        final location = position.toLocationEntity();
        _locationStreamController.add(location);

        // Auto-save on every location update
        saveLocationToLocal(location);

        // Auto-sync if online
        if (networkInfo.isConnected as bool) {
          updateServerLocation(location);
        }
      },
      onError: (error) {
        _locationStreamController.addError(error);
      },
    );

    return _locationStreamController.stream;
  }

  @override
  Future<void> saveLocationToLocal(LocationEntity location) async {
    try {
      final model = location.toModel();
      await localDataSource.saveLocation(model);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> updateServerLocation(LocationEntity location) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        await saveLocationToLocal(location);
        return;
      }

      final json = location.toModel().toJson();
      await remoteDataSource.sendLocation(json);

      // Mark as synced in local DB
      await localDataSource.markAsSynced(location.id);
    } on ServerException {
      await saveLocationToLocal(location);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> startBackgroundTracking() async {
    try {
      await backgroundService.startTracking();
    } catch (e) {
      throw LocationServiceException(e.toString());
    }
  }

  @override
  Future<void> stopBackgroundTracking() async {
    try {
      await backgroundService.stopTracking();
      await _positionSubscription?.cancel();
    } catch (e) {
      throw LocationServiceException(e.toString());
    }
  }

  @override
  Future<List<LocationEntity>> getSavedLocations() async {
    try {
      final models = await localDataSource.getSavedLocations();
      return models.toEntityList();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> syncOfflineLocations() async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return;

      final unsyncedModels = await localDataSource.getUnsyncedLocations();

      for (final model in unsyncedModels) {
        try {
          await remoteDataSource.sendLocation(model.toJson());
          await localDataSource.markAsSynced(model.id);
        } catch (e) {
          // Continue with next if one fails
          continue;
        }
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  void dispose() {
    _positionSubscription?.cancel();
    _locationStreamController.close();
  }
}