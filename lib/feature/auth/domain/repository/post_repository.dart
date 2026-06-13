import 'package:dartz/dartz.dart';
import 'package:untitled1/feature/auth/domain/entity/post_response_entity.dart';

import '../../../../core/error/failure.dart';

abstract class PostRepository {
  Future<Either<Failure, PostResponseEntity>> getPosts({required int limit, required int skip});
}