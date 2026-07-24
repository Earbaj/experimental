import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../../core/config/dio_client.dart';
import '../model/age_prediction_model.dart';

abstract class AgePredictionRemoteDataSource {
  Future<AgePredictionModel> getAgePrediction(String name, String countryId);
}

class AgePredictionRemoteDataSourceImpl
    implements AgePredictionRemoteDataSource {
  final DioClient dioClient;

  AgePredictionRemoteDataSourceImpl(this.dioClient);

  @override
  Future<AgePredictionModel> getAgePrediction(
      String name, String countryId) async {
    try {
      final response = await dioClient.dio.get(
        'https://api.agify.io',
        queryParameters: {
          'name': name,
          'country_id': countryId,
        },
      );

      if (response.statusCode == 200) {
        return AgePredictionModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load age prediction');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}