import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final String id;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? accuracy;
  final double? speed;
  final String? userId;
  final bool isSynced;

  const LocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
    this.speed,
    this.userId,
    this.isSynced = false,
  });

  // JSON থেকে তৈরি
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      accuracy: json['accuracy'] != null ? (json['accuracy'] as num).toDouble() : null,
      speed: json['speed'] != null ? (json['speed'] as num).toDouble() : null,
      userId: json['userId'],
      isSynced: json['isSynced'] ?? false,
    );
  }

  // JSON এ রূপান্তর
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'accuracy': accuracy,
      'speed': speed,
      'userId': userId,
      'isSynced': isSynced,
    };
  }

  // SQLite এর জন্য
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'accuracy': accuracy,
      'speed': speed,
      'userId': userId,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  // SQLite থেকে তৈরি
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      accuracy: map['accuracy'],
      speed: map['speed'],
      userId: map['userId'],
      isSynced: map['isSynced'] == 1,
    );
  }

  @override
  List<Object?> get props => [id, latitude, longitude, timestamp];
}