import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../feature/ageprediction/data/datasources/age_prediction_remote_datasource.dart';
import '../../feature/ageprediction/data/repositories/age_prediction_repository_impl.dart';
import '../../feature/ageprediction/domain/repositories/age_prediction_repository.dart';
import '../../feature/ageprediction/domain/usecases/get_age_prediction_usecase.dart';
import '../../feature/ageprediction/presentation/viewmodel/age_prediction_viewmodel.dart';
import '../../feature/ageprediction/presentation/viewmodel/state/age_prediction_state.dart';
import '../config/dio_client.dart';


// ==========================================
// ১. External (GetIt-এর LazySingleton এর বিকল্প)
// ==========================================
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// ==========================================
// ২. Core / Network Clients
// ==========================================
final dioClientProvider = Provider<DioClient>((ref) {
  // sl() এর জায়গায় ref.watch() দিয়ে ডিপেন্ডেন্সি পাস করছি
  final dio = ref.watch(dioProvider);
  return DioClient(dio);
});

// ==========================================
// ৩. Data Sources
// ==========================================
final agePredictionRemoteDataSourceProvider =
Provider<AgePredictionRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AgePredictionRemoteDataSourceImpl(dioClient);
});

// ==========================================
// ৪. Repositories
// ==========================================
final agePredictionRepositoryProvider = Provider<AgePredictionRepository>((ref) {
  final remoteDataSource = ref.watch(agePredictionRemoteDataSourceProvider);
  return AgePredictionRepositoryImpl(remoteDataSource);
});

// ==========================================
// ৫. Use Cases
// ==========================================
final getAgePredictionUseCaseProvider = Provider<GetAgePredictionUseCase>((ref) {
  final repository = ref.watch(agePredictionRepositoryProvider);
  return GetAgePredictionUseCase(repository);
});

// ==========================================
// ৬. Presentation Layer / ViewModel (Factory-র বিকল্প)
// ==========================================
// StateNotifierProvider নিজে থেকেই ফ্যাক্টরির মতো কাজ করে, UI যখনই এটি রিড করবে, স্টেট অনুযায়ী আপডেট করবে।
final agePredictionViewModelProvider =
StateNotifierProvider<AgePredictionViewModel, AgePredictionState>((ref) {
  final getAgePredictionUseCase = ref.watch(getAgePredictionUseCaseProvider);
  return AgePredictionViewModel(
    getAgePredictionUseCase: getAgePredictionUseCase,
  );
});