import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// আপনার প্রজেক্টের পাথ অনুযায়ী ইমপোর্টগুলো পরিবর্তন করবেন
import 'package:untitled1/feature/auth/domain/entity/post_entity.dart';
import 'package:untitled1/core/error/failure.dart';
import 'package:untitled1/feature/auth/domain/entity/post_response_entity.dart';
import 'package:untitled1/feature/auth/domain/usecase/get_posts_usecase.dart';
import 'package:untitled1/feature/auth/presentation/state/post_state.dart';
import 'package:untitled1/feature/auth/presentation/viewmodel/post_viewmodel.dart';

// UseCase মক করার জন্য ক্লাস
class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(const GetPostsParams(skip: 0, limit: 10));
  });

  late PostViewModel postViewModel;
  late MockGetPostsUseCase mockGetPostsUseCase;

  setUp(() {
    mockGetPostsUseCase = MockGetPostsUseCase();
    postViewModel = PostViewModel(getPostsUseCase: mockGetPostsUseCase);
  });

  tearDown(() {
    postViewModel.dispose();
  });

  // টেস্টের জন্য ডামি ডাটা (নকল পোস্ট লিস্ট)
  final tPostsList = List.generate(
    10,
        (index) => const PostEntity(
      id: 1,
      title: 'Test Title',
      body: 'Test Body',
      tags: [],
      likes: 0,
      dislikes: 0,
      views: 0,
      userId: 1,
    ),
  );

  final tPostResponseEntity = PostResponseEntity(
    posts: tPostsList,
    total: 20, // Total ২০ দিলাম যাতে প্রথমবার Fetch-এ hasReachedMax ট্রু না হয়ে যায়
    skip: 0,
    limit: 10,
  );

  group('PostViewModel Tests with Single State & Enum -', () {

    // ১. ইনিশিয়াল স্টেট টেস্ট
    test('initial state should have PostStatus.initial', () {
      expect(postViewModel.debugState, const PostState());
    });

    // ২. সফলভাবে প্রথমবার ডাটা লোড হওয়ার টেস্ট (Pagination এর প্রথম ধাপ)
    test(
      'should emit PostState with loading and then success status when data is fetched successfully',
          () async {
        // Arrange
        when(() => mockGetPostsUseCase(any()))
            .thenAnswer((_) async => Right(tPostResponseEntity));

        // আমরা স্টেটের পরিবর্তনগুলো রেকর্ড করার জন্য একটি লিস্ট রাখছি
        final List<PostState> emitedStates = [];
        postViewModel.addListener((state) => emitedStates.add(state));

        // Act
        await postViewModel.fetchPosts();

        // Assert
        expect(emitedStates.length, 3);

        // ১ম স্টেট: status = loading
        expect(emitedStates[0].status, PostStatus.initial);
        expect(emitedStates[1].status, PostStatus.loading);

        // ২য় স্টেট: status = success এবং ডাটা আপডেট
        expect(emitedStates[2].status, PostStatus.success);
        expect(emitedStates[2].posts, equals(tPostsList));
        expect(emitedStates[2].hasReachedMax, false); // ২০ টার মধ্যে ১০ টা এসেছে, সো false
        expect(emitedStates[2].currentSkip, 10);

        verify(() => mockGetPostsUseCase(any())).called(1);
      },
    );

    // 🎯 ৩. পরবর্তী পেজের ডাটা লোড হওয়া (Pagination Test - BLoC-এর Seed-এর বিকল্প)
    test(
      'should APPEND new posts to existing posts when fetching subsequent pages',
          () async {
        // Arrange
        // BLoC টেস্টের seed-এর মতো এখানে আমরা ViewModel-কে একটা শুরুতে পুরনো স্টেট দিয়ে দিচ্ছি
        // এখানে StateNotifier-এর স্টেটকে ডিরেক্ট পরিবর্তন করার ট্রিক (টেস্টের সুবিধার জন্য):
        // (যেহেতু ViewModel-এ initial state-এ text data বা parameters পাস করা যায় না,
        // তাই debugState-কে আমরা internal mock/override উপায়ে বা test helper দিয়ে রি-এসাইন করতে পারি।
        // অথবা এর চেয়েও সহজ ও প্রো-লেভেল উপায় হলো ১ম বার কল দিয়ে স্টেটকে ওল্ড বানানো, অথবা কাস্টম কনস্ট্রাক্টর রাখা)

        // চলুন আমরা একদম রিয়েল-ওয়ার্ল্ড উপায়ে প্রথম পেজ লোড করাই, তারপর ২য় পেজ টেস্ট করি:
        when(() => mockGetPostsUseCase(any()))
            .thenAnswer((_) async => Right(tPostResponseEntity)); // প্রতিবার ১০টা করে দেবে

        // ১ম পেজ ফেচ (এখানে পেটে ১০টা চলে আসবে)
        await postViewModel.fetchPosts();
        expect(postViewModel.debugState.posts.length, 10);

        // এবার ২য় পেজের জন্য UseCase নতুন একটা রেসপন্স দেবে (total: 20, অর্থাৎ এবার hasReachedMax ট্রু হবে)
        final secondPageResponseEntity = PostResponseEntity(
          posts: tPostsList, // আরও ১০টা নতুন পোস্ট
          total: 20,
          skip: 10,
          limit: 10,
        );

        when(() => mockGetPostsUseCase(any()))
            .thenAnswer((_) async => Right(secondPageResponseEntity));

        // Act - ২য় বার ফেচ করছি
        await postViewModel.fetchPosts();

        // Assert
        // আগের ১০টা + নতুন ১০টা = মোট ২০টা পোস্ট হতে হবে
        expect(postViewModel.debugState.posts.length, 20);
        expect(postViewModel.debugState.status, PostStatus.success);
        expect(postViewModel.debugState.currentSkip, 20);
        expect(postViewModel.debugState.hasReachedMax, true); // টোটাল ২০ টা কাভার হয়ে গেছে
      },
    );

    // ৪. সার্ভার ফেইল করলে ফেইলুর স্টেট টেস্ট
    test(
      'should emit PostState with loading and then failure status when fetching data fails',
          () async {
        // Arrange
        when(() => mockGetPostsUseCase(any()))
            .thenAnswer((_) async => Left(ServerFailure('Server Down')));

        final List<PostState> emitedStates = [];
        postViewModel.addListener((state) => emitedStates.add(state));

        // Act
        await postViewModel.fetchPosts();

        // Assert
        expect(emitedStates[0].status, PostStatus.initial);
        expect(emitedStates[1].status, PostStatus.loading);
        expect(emitedStates[2].status, PostStatus.failure);
        expect(emitedStates[2].errorMessage, 'Server Down');
      },
    );

    // ৫. ইন্টারনেট বা নেটওয়ার্ক এরর টেস্ট কেস
    test(
      'should emit failure with No Internet Connection message',
          () async {
        // Arrange
        when(() => mockGetPostsUseCase(any()))
            .thenAnswer((_) async => const Left(NetworkFailure('No Internet Connection')));

        final List<PostState> emitedStates = [];
        postViewModel.addListener((state) => emitedStates.add(state));

        // Act
        await postViewModel.fetchPosts();

        // Assert
        expect(emitedStates[0].status, PostStatus.initial);
        expect(emitedStates[1].status, PostStatus.loading);
        expect(emitedStates[2].status, PostStatus.failure);
        expect(emitedStates[2].errorMessage, 'No Internet Connection');
      },
    );
  });
}