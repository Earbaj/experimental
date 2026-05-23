import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entity/location_entity.dart';
import '../../domain/repository/location_repository.dart';
import '../../domain/usecase/check_location_permission_usecase.dart';
import '../../domain/usecase/get_current_location_usecase.dart';
import '../../domain/usecase/get_location_stream_usecase.dart';
import '../../domain/usecase/get_saved_locations_usecase.dart';
import '../../domain/usecase/start_tracking_usecase.dart';
import '../../domain/usecase/stop_tracking_usecase.dart';
import '../../domain/usecase/sync_offline_locations_usecase.dart';
import '../event/location_tracking_event.dart';
import '../state/location_tracking_state.dart';

class LocationTrackingBloc extends Bloc<LocationTrackingEvent, LocationTrackingState> {
  final StartTrackingUseCase startTrackingUseCase;
  final StopTrackingUseCase stopTrackingUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetLocationStreamUseCase getLocationStreamUseCase;
  final SyncOfflineLocationsUseCase syncOfflineLocationsUseCase;
  final GetSavedLocationsUseCase getSavedLocationsUseCase;
  final CheckLocationPermissionUseCase checkPermissionUseCase;

  StreamSubscription<LocationEntity>? _locationSubscription;

  LocationTrackingBloc({
    required this.startTrackingUseCase,
    required this.stopTrackingUseCase,
    required this.getCurrentLocationUseCase,
    required this.getLocationStreamUseCase,
    required this.syncOfflineLocationsUseCase,
    required this.getSavedLocationsUseCase,
    required this.checkPermissionUseCase,
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
          _locationSubscription = getLocationStreamUseCase().listen(
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
    // লোডিং ইন্ডিকেটর দেখান (চাইলে)
    emit(TrackingLoading());

    // UseCase call করুন
    final syncResult = await syncOfflineLocationsUseCase();

    await syncResult.fold(
          (failure) async {
        // Failure হলে error state
        emit(TrackingFailure(errorReason: failure.message));
      },
          (syncedCount) async {
        // Success হলে saved locations count দেখান
        emit(OfflineLocationsSynced(syncedCount));

        // অথবা চাইলে পুরো লোকেশন লিস্ট দেখাতে পারেন
        final locationsResult = await getSavedLocationsUseCase();

        locationsResult.fold(
              (failure) {
            // লোকেশন পেতে ব্যর্থ হলে শুধু count দেখান
            print('Failed to get locations: ${failure.message}');
          },
              (locations) {
            // পুরো লোকেশন লিস্ট পেলে সেটাও emit করতে পারেন
            print('Total saved locations: ${locations.length}');
          },
        );
      },
    );
  }

  Future<void> _onCheckPermission(
      CheckPermissionEvent event,
      Emitter<LocationTrackingState> emit,
      ) async {
    // লোডিং স্টেট (চাইলে)
    emit(PermissionChecking());

    // UseCase call
    final result = await checkPermissionUseCase();

    result.fold(
          (failure) {
        // এরর হলে
        emit(PermissionDenied(failure.message));
      },
          (hasPermission) {
        if (!hasPermission) {
          emit(PermissionDenied('Location permission is required for tracking'));
        } else {
          // permission থাকলে সাকসেস স্টেট
          emit(PermissionGranted());
        }
      },
    );
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}