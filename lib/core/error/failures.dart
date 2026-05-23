// ডোমেইন লেয়ারের জন্য এরর ক্লাস
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class PermissionFailure extends Failure {
  PermissionFailure(String message) : super(message);
}

class LocationServiceFailure extends Failure {
  LocationServiceFailure(String message) : super(message);
}