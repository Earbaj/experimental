import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entity/post_response_entity.dart';
import '../../domain/repository/post_repository.dart';
import '../datasource/post_remote_data_source.dart';
import '../mapper/post_mapper.dart';


class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  const PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PostResponseEntity>> getPosts({required int limit, required int skip}) async {
    try {
      final remoteData = await remoteDataSource.fetchPosts(limit: limit, skip: skip);
      final entity = PostMapper.toEntity(remoteData);
      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addPost({required String title, required int userId}) async {
    try {
      final remoteData = await remoteDataSource.addPost(title: title, userId: userId);
      return Right(remoteData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}