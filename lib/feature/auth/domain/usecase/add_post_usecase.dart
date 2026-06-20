
import 'package:dartz/dartz.dart';
import 'package:untitled1/core/error/failure.dart';
import 'package:untitled1/feature/auth/domain/repository/post_repository.dart';

class AddPostUseCase{
  final PostRepository repository;

  const AddPostUseCase(this.repository);

  Future<Either<Failure, bool>> call(String title, int userId) async {
    return await repository.addPost(title: title, userId: userId);
  }
}