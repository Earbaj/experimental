import 'package:equatable/equatable.dart';

import '../../domain/entity/location_entity.dart';
abstract class LocationTrackingState extends Equatable {
  const LocationTrackingState();

  @override
  List<Object?> get props => [];
}

class TrackingInitial extends LocationTrackingState {}

class TrackingLoading extends LocationTrackingState {}

class TrackingActive extends LocationTrackingState {
  final double? currentLatitude;
  final double? currentLongitude;
  final DateTime? lastUpdate;

  const TrackingActive({
    this.currentLatitude,
    this.currentLongitude,
    this.lastUpdate,
  });

  @override
  List<Object?> get props => [currentLatitude, currentLongitude, lastUpdate];
}

class TrackingInactive extends LocationTrackingState {}

class LocationLoaded extends LocationTrackingState {
  final LocationEntity location;

  const LocationLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

class TrackingFailure extends LocationTrackingState {
  final String errorReason;

  const TrackingFailure({required this.errorReason});

  @override
  List<Object?> get props => [errorReason];
}

class PermissionDenied extends LocationTrackingState {
  final String message;

  const PermissionDenied(this.message);

  @override
  List<Object?> get props => [message];
}

class OfflineLocationsSynced extends LocationTrackingState {
  final int syncedCount;

  const OfflineLocationsSynced(this.syncedCount);

  @override
  List<Object?> get props => [syncedCount];
}


class PermissionChecking extends LocationTrackingState {
  const PermissionChecking();
}

class PermissionGranted extends LocationTrackingState {
  const PermissionGranted();
}
