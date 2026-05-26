import 'dart:async';
import 'package:flutter/material.dart';

/// A [Listenable] that notifies listeners when a [Stream] emits a value.
/// Used to refresh GoRouter state when auth stream emits.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
