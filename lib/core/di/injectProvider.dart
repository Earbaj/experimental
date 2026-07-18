import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Import your custom files
import '../../feature/auth/presentation/state/add_post_state.dart';
import '../../feature/auth/presentation/state/post_state.dart';
import '../../feature/auth/presentation/viewmodel/add_post_viewmodel.dart';
import '../../feature/auth/presentation/viewmodel/post_viewmodel.dart';
import '../config/dio_client.dart';
import '../../feature/auth/data/datasource/post_remote_data_source.dart';
import '../../feature/auth/data/repositoryImpl/post_repository_impl.dart';
import '../../feature/auth/domain/repository/post_repository.dart';
import '../../feature/auth/domain/usecase/add_post_usecase.dart';
import '../../feature/auth/domain/usecase/get_posts_usecase.dart';

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
final postRemoteDataSourceProvider = Provider<PostRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PostRemoteDataSourceImpl(dioClient);
});

// ==========================================
// ৪. Repositories
// ==========================================
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final remoteDataSource = ref.watch(postRemoteDataSourceProvider);
  return PostRepositoryImpl(remoteDataSource);
});

// ==========================================
// ৫. Use Cases
// ==========================================
final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return GetPostsUseCase(repository);
});

final addPostUseCaseProvider = Provider<AddPostUseCase>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return AddPostUseCase(repository);
});

// ==========================================
// ৬. Presentation Layer / ViewModel (Factory-র বিকল্প)
// ==========================================
// StateNotifierProvider নিজে থেকেই ফ্যাক্টরির মতো কাজ করে, UI যখনই এটি রিড করবে, স্টেট অনুযায়ী আপডেট করবে।
final addPostViewModelProvider = StateNotifierProvider<AddPostViewModel, AddPostState>((ref) {
  final addPostUseCase = ref.watch(addPostUseCaseProvider);
  return AddPostViewModel(addPostUseCase: addPostUseCase);
});


// 7. for post viewmodel
final postViewModelProvider = StateNotifierProvider<PostViewModel, PostState>((ref) {
  final getPostsUseCase = ref.watch(getPostsUseCaseProvider); // di_provider থেকে আসছে
  return PostViewModel(getPostsUseCase: getPostsUseCase);
});