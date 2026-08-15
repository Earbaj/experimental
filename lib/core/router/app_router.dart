// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/auth/presentation/providers/auth_providers.dart';
import '../../feature/auth/presentation/view/login_view.dart';
import '../../feature/dashboard/presentation/view/dashboard_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Listen to the stream of authentication state changes
  final authStateAsync = ref.watch(authStateStreamProvider);

  return GoRouter(
    initialLocation: '/login',
    // Re-evaluate routes when auth state changes
    refreshListenable: ValueNotifier(authStateAsync),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authStateStreamProvider);
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      // If user is not logged in and not on login screen -> Redirect to /login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // If user is logged in and trying to access /login -> Redirect to /dashboard
      if (isLoggedIn && isLoggingIn) {
        return '/dashboard';
      }

      return null; // No redirection needed
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardView(),
      ),
    ],
  );
});