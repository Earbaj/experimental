import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entity/location_entity.dart';
import '../../domain/repository/location_repository.dart';
import '../../domain/usecase/get_current_location_usecase.dart';
import '../../domain/usecase/start_tracking_usecase.dart';
import '../../domain/usecase/stop_tracking_usecase.dart';
import '../event/location_tracking_event.dart';
import '../state/location_tracking_state.dart';

class LocationTrackingBloc extends Bloc<LocationTrackingEvent, LocationTrackingState> {
  final StartTrackingUseCase startTrackingUseCase;
  final StopTrackingUseCase stopTrackingUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final LocationRepository locationRepository;

  StreamSubscription<LocationEntity>? _locationSubscription;

  LocationTrackingBloc({
    required this.startTrackingUseCase,
    required this.stopTrackingUseCase,
    required this.getCurrentLocationUseCase,
    required this.locationRepository,
  }) : super(TrackingInitial()) {
    on<StartTrackingEvent>(_onStartTracking);
    on<StopTrackingEvent>(_onStopTracking);
    on<LocationUpdatedEvent>(_onLocationUpdated);
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<SyncOfflineLocationsEvent>(_onSyncOfflineLocations);
    on<CheckPermissionEvent>(_onCheckPermission);
  }

  Future<void> _onStartTracking(
      StartTrackingEvent event,
      Emitter<LocationTrackingState> emit,
      ) async {
    emit(TrackingLoading());

    final result = await startTrackingUseCase();

    result.fold(
          (failure) {
        if (failure is PermissionFailure) {
          emit(PermissionDenied(failure.message));
        } else {
          emit(TrackingFailure(errorReason: failure.message));
        }
      },
          (success) async {
        if (success) {
          // Start listening to location stream
          _locationSubscription?.cancel();
          _locationSubscription = locationRepository.getLocationStream().listen(
                (location) {
              add(LocationUpdatedEvent(
                latitude: location.latitude,
                longitude: location.longitude,
                timestamp: location.timestamp,
              ));
            },
            onError: (error) {
              add(StopTrackingEvent());
            },
          );

          emit(TrackingActive());
        }
      },
    );
  }

  void _onLocationUpdated(
      LocationUpdatedEvent event,
      Emitter<LocationTrackingState> emit,
      ) {
    if (state is TrackingActive) {
      emit(TrackingActive(
        currentLatitude: event.latitude,
        currentLongitude: event.longitude,
        lastUpdate: event.timestamp,
      ));
    }
  }

  Future<void> _onStopTracking(
      StopTrackingEvent event,
      Emitter<LocationTrackingState> emit,
      ) async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;

    final result = await stopTrackingUseCase();

    result.fold(
          (failure) => emit(TrackingFailure(errorReason: failure.message)),
          (_) => emit(TrackingInactive()),
    );
  }

  Future<void> _onGetCurrentLocation(
      GetCurrentLocationEvent event,
      Emitter<LocationTrackingState> emit,
      ) async {
    emit(TrackingLoading());

    final result = await getCurrentLocationUseCase();

    result.fold(
          (failure) => emit(TrackingFailure(errorReason: failure.message)),
          (location) => emit(LocationLoaded(location)),
    );
  }

  Future<void> _onSyncOfflineLocations(
      SyncOfflineLocationsEvent event,
      Emitter<LocationTrackingState> emit,
      ) async {
    try {
      await locationRepository.syncOfflineLocations();
      final savedLocations = await locationRepository.getSavedLocations();
      emit(OfflineLocationsSynced(savedLocations.length));
    } catch (e) {
      emit(TrackingFailure(errorReason: e.toString()));
    }
  }

  Future<void> _onCheckPermission(
      CheckPermissionEvent event,
      Emitter<LocationTrackingState> emit,
      ) async {
    final hasPermission = await locationRepository.checkAndRequestPermission();
    if (!hasPermission) {
      emit(PermissionDenied('Location permission is required for tracking'));
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}