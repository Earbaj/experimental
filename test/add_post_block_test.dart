import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// import your class and others depencdancy
import 'package:untitled1/core/error/failure.dart'; // path for failure class
import 'package:untitled1/feature/auth/domain/usecase/add_post_usecase.dart';
import 'package:untitled1/feature/auth/presentation/block/add_post_block.dart';
import 'package:untitled1/feature/auth/presentation/event/add_post_event.dart';
import 'package:untitled1/feature/auth/presentation/state/add_post_state.dart';


/*Multi-Class Approach (isA<PostSuccess>()):
যখন ফ্লো-টা একদম সরল এবং একমুখী। যেমন: বাটন চাপলাম ➡️ লোডিং হলো ➡️ হয় সাকসেস (True/False) হলো,
না হয় ফেইল হলো। এখানে আগের কোনো ডাটা স্ক্রিনে ধরে রাখার চিন্তা নেই।
(উদাহরণ: Login, Sign Up, Add Post, Delete Item, Password Reset)।
*/

// 🎯 UseCase কে মক (Mock) করার জন্য Mock class তৈরি
class MockAddPostUseCase extends Mock implements AddPostUseCase {}

void main() {
  late AddPostBloc addPostBloc;
  late MockAddPostUseCase mockAddPostUseCase;

  // টেস্টের জন্য ডামি ডাটা
  const tTitle = 'I am in love with someone.';
  const tUserId = 5;

  // প্রতিটা টেস্ট রান হওয়ার আগে এই ব্লকটি এক্সিকিউট হবে
  setUp(() {
    mockAddPostUseCase = MockAddPostUseCase();
    addPostBloc = AddPostBloc(addPostUseCase: mockAddPostUseCase);
  });

  // টেস্ট শেষ হওয়ার পর ব্লক ক্লোজ করার জন্য
  tearDown(() {
    addPostBloc.close();
  });

  // ১. ইনিশিয়াল স্টেট টেস্ট
  test('initial state should be PostInitial', () {
    expect(addPostBloc.state, isA<PostInitial>());
  });

  group('SubmitPostEvent Tests', () {
    // 🟢 ২. সাকসেস সিনারিও টেস্ট (Success Scenario)
    blocTest<AddPostBloc, AddPostState>(
      'should emit [PostLoading, PostSuccess] when AddPostUseCase returns Right(true)',
      build: () {
        // UseCase কল হলে যেন Right(true) রিটার্ন করে তা মক করা হলো
        when(() => mockAddPostUseCase.call(any(), any()))
            .thenAnswer((_) async => const Right(true));
        return addPostBloc;
      },
      act: (bloc) => bloc.add(SubmitPostEvent(title: tTitle, userId: tUserId)),
      expect: () => [
        isA<PostLoading>(),
        isA<PostSuccess>(),
      ],
      verify: (_) {
        // নিশ্চিত করা যে ইউজকেসটি সঠিক প্যারামিটার দিয়ে কল হয়েছে কিনা
        verify(() => mockAddPostUseCase.call(tTitle, tUserId)).called(1);
      },
    );

    // 🔴 ৩. ফেইলর সিনারিও টেস্ট (Failure From Server/Network)
    blocTest<AddPostBloc, AddPostState>(
      'should emit [PostLoading, PostFailure] when AddPostUseCase returns Left(ServerFailure)',
      build: () {
        // UseCase কল হলে যেন Left(Failure) রিটার্ন করে তা মক করা হলো
        when(() => mockAddPostUseCase.call(any(), any())).thenAnswer(
              (_) async => const Left(ServerFailure('Server Error occurred!')),
        );
        return addPostBloc;
      },
      act: (bloc) => bloc.add(SubmitPostEvent(title: tTitle, userId: tUserId)),
      expect: () => [
        isA<PostLoading>(),
        isA<PostFailure>(), // আপনার স্টেট অনুযায়ী এটি মেসেজ চেক করবে
      ],
    );

    // 🟡 ৪. ইউজকেস ট্রু কিন্তু রেসপন্স ফলস সিনারিও টেস্ট (Right(false))
    blocTest<AddPostBloc, AddPostState>(
      'should emit [PostLoading, PostFailure] with static message when UseCase returns Right(false)',
      build: () {
        when(() => mockAddPostUseCase.call(any(), any()))
            .thenAnswer((_) async => const Right(false));
        return addPostBloc;
      },
      act: (bloc) => bloc.add(SubmitPostEvent(title: tTitle, userId: tUserId)),
      expect: () => [
        isA<PostLoading>(),
        isA<PostFailure>(),
      ],
    );
  });
}