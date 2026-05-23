import 'package:dio/dio.dart';
import 'package:untitled1/core/config/dio_client.dart';
import 'package:untitled1/feature/auth/domain/entity/location_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';

abstract class LocationRemoteDataSource {
  Future<void> sendLocation(Map<String, dynamic> locationData);
  Future<void> startTrackingSession(String userId);
  Future<void> stopTrackingSession(String userId);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final DioClient dio;

  LocationRemoteDataSourceImpl(this.dio);

  @override
  Future<void> sendLocation(Map<String, dynamic> locationData) async {
    try {
      await dio.dio.post(
        '${AppConstants.baseUrl}${AppConstants.locationEndpoint}/update',
        data: locationData,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to send location');
    }
  }

  @override
  Future<void> startTrackingSession(String userId) async {
    try {
      await dio.dio.post(
        '${AppConstants.baseUrl}${AppConstants.locationEndpoint}/start',
        data: {'userId': userId},
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to start tracking session');
    }
  }

  @override
  Future<void> stopTrackingSession(String userId) async {
    try {
      await dio.dio.post(
        '${AppConstants.baseUrl}${AppConstants.locationEndpoint}/stop',
        data: {'userId': userId},
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to stop tracking session');
    }
  }
}