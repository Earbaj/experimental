// সার্ভার বা লোকাল ডাটাবেজ সম্পর্কিত এরর
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);
}