import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/post_response_entity.dart';
import '../repository/post_repository.dart';


class GetPostsParams {
  final int limit;
  final int skip;
  const GetPostsParams({required this.limit, required this.skip});
}

class GetPostsUseCase {
  final PostRepository repository;

  const GetPostsUseCase(this.repository);

  Future<Either<Failure, PostResponseEntity>> call(GetPostsParams params) async {
    return await repository.getPosts(limit: params.limit, skip: params.skip);
  }
}