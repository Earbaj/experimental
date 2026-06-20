import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:untitled1/feature/auth/domain/entity/post_entity.dart';
import 'package:untitled1/core/error/failure.dart';
import 'package:untitled1/feature/auth/domain/entity/post_response_entity.dart';
import 'package:untitled1/feature/auth/domain/usecase/get_posts_usecase.dart';
import 'package:untitled1/feature/auth/presentation/block/post_bloc.dart';
import 'package:untitled1/feature/auth/presentation/event/post_event.dart';
import 'package:untitled1/feature/auth/presentation/state/post_state.dart';

// UseCase মক করার জন্য ক্লাস
class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

void main() {

  setUpAll(() {
    registerFallbackValue(const GetPostsParams(skip: 0, limit: 10));
  });

  late PostBloc postBloc;
  late MockGetPostsUseCase mockGetPostsUseCase;

  setUp(() {
    mockGetPostsUseCase = MockGetPostsUseCase();
    postBloc = PostBloc(mockGetPostsUseCase);
  });

  tearDown(() {
    postBloc.close();
  });

  // টেস্টের জন্য ডামি ডাটা (নকল পোস্ট লিস্ট)
  final tPostsList = [
    const PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1),
    const PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1),
    const PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1),
    const PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1),
    const PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1),
    const PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1),
    const PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1),
    const PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1),
    const PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1),
    const PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1),
  ];

  final tPostResponseEntity = PostResponseEntity(
    posts: tPostsList,
    total: 1,
    skip: 0,
    limit: 10,
  );

  group('PostBloc Tests with Single State & Enum -', () {

    // ১. ইনিশিয়াল স্টেট টেস্ট
    test('initial state should have PostStatus.initial', () {
      expect(postBloc.state, const PostState());
    });

    // ২. সফলভাবে প্রথমবার ডাটা লোড হওয়ার টেস্ট (Pagination এর প্রথম ধাপ)
    blocTest<PostBloc, PostState>(
      'should emit PostState with loading and then success status when data is fetched successfully',
      build: () {
        when(() => mockGetPostsUseCase(any()))
            .thenAnswer((_) async => Right(tPostResponseEntity));
        return postBloc;
      },
      act: (bloc) => bloc.add(FetchPostsEvent()), // তোমার ইভেন্টের নাম অনুযায়ী চেঞ্জ করতে পারো
      expect: () => [
        // প্রথম স্টেট: স্ট্যাটাস চেঞ্জ হয়ে loading হবে, বাকি সব আগের মতো থাকবে
        const PostState(status: PostStatus.loading),

        // দ্বিতীয় স্টেট: স্ট্যাটাস success হবে, লিস্টে ডাটা ঢুকবে এবং কপাল ভালো হলে skip আপডেট হবে (ধরে নিলাম ১০ টা করে লোড করছ)
        PostState(
          status: PostStatus.success,
          posts: tPostsList,
          hasReachedMax: true,
          currentSkip: tPostsList.length, // তোমার ব্লক লজিক অনুযায়ী যদি skip আপডেট করো
        ),
      ],
      verify: (_) {
        verify(() => mockGetPostsUseCase(any())).called(1);
      },
    );

    // 🎯 নতুন টেস্ট কেস: পেজ ২ বা পরবর্তী পেজের ডাটা লোড হওয়া (Pagination Test)
    blocTest<PostBloc, PostState>(
      'should APPEND new posts to existing posts when fetching subsequent pages',
      build: () {
        when(() => mockGetPostsUseCase(any()))
            .thenAnswer((_) async => Right(tPostResponseEntity)); // এটিও ১০টা নতুন পোস্ট দেবে
        return postBloc;
      },
      // 💡 আসল ট্রিক: আমরা টেস্ট ইঞ্জিনকে বলছি, ব্লকটা যখন শুরু হবে তখন তার পেটে অলরেডি ৫টি পুরনো পোস্ট আছে!
      seed: () => PostState(
        status: PostStatus.success,
        posts: List.generate(5, (index) => PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1)), // ৫টি পুরনো পোস্ট
        currentSkip: 5,
      ),
      act: (bloc) => bloc.add(FetchPostsEvent()),
      expect: () => [
       /* // প্রথম স্টেট: শুধু স্ট্যাটাস loading হবে, পুরনো ৫টি পোস্ট কিন্তু রয়ে যাবে!
        PostState(
          status: PostStatus.loading,
          posts: List.generate(5, (index) => PostEntity(id: index, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1)),
          currentSkip: 5,
        ),*/
        // দ্বিতীয় স্টেট: নতুন ১০টি পোস্ট পুরনো ৫টির সাথে যোগ হয়ে মোট ১৫টি পোস্ট হতে হবে!
        PostState(
          status: PostStatus.success,
          posts: [
            ...List.generate(5, (index) => PostEntity(id: 1, title: 'Test Title', body: 'Test Body', tags: [], likes: 0, dislikes: 0, views: 0, userId: 1)), // পুরনো ৫টি
            ...tPostsList, // নতুন ১০টি
          ],
          hasReachedMax: true,
          currentSkip: 15, // ৫ + ১০
        ),
      ],
    );

    // ৩. সার্ভার ফেইল করলে ফেইলুর স্টেট টেস্ট
    blocTest<PostBloc, PostState>(
      'should emit PostState with loading and then failure status when fetching data fails',
      build: () {
        when(() => mockGetPostsUseCase(any()))
            .thenAnswer((_) async => Left(ServerFailure('Server Down')));
        return postBloc;
      },
      act: (bloc) => bloc.add(FetchPostsEvent()),
      expect: () => [
        // প্রথম স্টেট: স্ট্যাটাস loading
        const PostState(status: PostStatus.loading),

        // দ্বিতীয় স্টেট: স্ট্যাটাস failure এবং এরর মেসেজ সেট হবে
        const PostState(
          status: PostStatus.failure,
          errorMessage: 'Server Down',
        ),
      ],
    );
    //টেস্ট কেস 4: ইন্টারনেট বা নেটওয়ার্ক এরর (নতুন যোগ করলে)
    blocTest<PostBloc, PostState>(
      'should emit failure with No Internet Connection message',
      build: () {
        when(() => mockGetPostsUseCase(any()))
            .thenAnswer((_) async => const Left(NetworkFailure('No Internet Connection')));
        return postBloc;
      },
      act: (bloc) => bloc.add(FetchPostsEvent()),
      expect: () => [
        const PostState(status: PostStatus.loading),
        const PostState(status: PostStatus.failure, errorMessage: 'No Internet Connection'),
      ],
    );
  });
}