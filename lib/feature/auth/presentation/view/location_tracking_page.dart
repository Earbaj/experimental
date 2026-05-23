import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../block/location_tracking_bloc.dart';
import '../event/location_tracking_event.dart';
import '../state/location_tracking_state.dart';
class LocationTrackingPage extends StatelessWidget {
  const LocationTrackingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<LocationTrackingBloc>().add(SyncOfflineLocationsEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<LocationTrackingBloc, LocationTrackingState>(
        listener: (context, state) {
          if (state is TrackingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorReason)),
            );
          } else if (state is PermissionDenied) {
            _showPermissionDialog(context);
          } else if (state is OfflineLocationsSynced) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${state.syncedCount} locations synced')),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusWidget(state),
                const SizedBox(height: 24),
                _buildActionButton(context, state),
                const SizedBox(height: 24),
                _buildLocationInfo(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusWidget(LocationTrackingState state) {
    if (state is TrackingLoading) {
      return const CircularProgressIndicator();
    } else if (state is TrackingActive) {
      return const Icon(Icons.gps_fixed, size: 48, color: Colors.green);
    } else if (state is TrackingInactive) {
      return const Icon(Icons.gps_off, size: 48, color: Colors.grey);
    } else if (state is PermissionDenied) {
      return const Icon(Icons.location_off, size: 48, color: Colors.red);
    }
    return const Icon(Icons.gps_not_fixed, size: 48, color: Colors.orange);
  }

  Widget _buildActionButton(BuildContext context, LocationTrackingState state) {
    if (state is TrackingActive) {
      return ElevatedButton.icon(
        onPressed: () {
          context.read<LocationTrackingBloc>().add(StopTrackingEvent());
        },
        icon: const Icon(Icons.stop),
        label: const Text('Stop Tracking'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      );
    } else if (state is TrackingInactive || state is TrackingInitial) {
      return ElevatedButton.icon(
        onPressed: () {
          context.read<LocationTrackingBloc>().add(StartTrackingEvent());
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Tracking'),
      );
    } else if (state is PermissionDenied) {
      return ElevatedButton.icon(
        onPressed: () {
          context.read<LocationTrackingBloc>().add(CheckPermissionEvent());
        },
        icon: const Icon(Icons.settings),
        label: const Text('Grant Permission'),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLocationInfo(LocationTrackingState state) {
    if (state is TrackingActive && state.currentLatitude != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'Current Location',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('Latitude: ${state.currentLatitude?.toStringAsFixed(6)}'),
            Text('Longitude: ${state.currentLongitude?.toStringAsFixed(6)}'),
            if (state.lastUpdate != null)
              Text('Last update: ${_formatTime(state.lastUpdate!)}'),
          ],
        ),
      );
    } else if (state is LocationLoaded) {
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text('Last Known Location'),
            Text('Lat: ${state.location.latitude.toStringAsFixed(6)}'),
            Text('Lng: ${state.location.longitude.toStringAsFixed(6)}'),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('Location permission is required for tracking. Please grant permission in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<LocationTrackingBloc>().add(CheckPermissionEvent());
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }
}