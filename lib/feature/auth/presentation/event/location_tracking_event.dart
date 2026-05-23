import 'package:equatable/equatable.dart';

abstract class LocationTrackingEvent extends Equatable {
  const LocationTrackingEvent();

  @override
  List<Object?> get props => [];
}

class StartTrackingEvent extends LocationTrackingEvent {
  final String? userId;

  const StartTrackingEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}

class StopTrackingEvent extends LocationTrackingEvent {}

class LocationUpdatedEvent extends LocationTrackingEvent {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const LocationUpdatedEvent({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [latitude, longitude, timestamp];
}

class GetCurrentLocationEvent extends LocationTrackingEvent {}

class SyncOfflineLocationsEvent extends LocationTrackingEvent {}

class CheckPermissionEvent extends LocationTrackingEvent {}