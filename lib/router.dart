import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/utils/go_router_refresh_stream.dart';
import 'feature/auth/presentation/view/login_screen.dart';
import 'feature/auth/presentation/view/register_screen.dart';
import 'feature/auth/presentation/view/splash_screen.dart';
import 'feature/auth/presentation/viewmodel/auth_providers.dart';
import 'feature/dashboard/presentation/view/dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(getAuthStateStreamUseCaseProvider)(),
    ),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final isLoggedIn = authState.value != null;
      final matchedPath = state.matchedLocation;

      final isGoingToSplash = matchedPath == '/splash';
      final isGoingToLogin = matchedPath == '/login';
      final isGoingToRegister = matchedPath == '/register';

      if (isGoingToSplash) {
        return isLoggedIn ? '/dashboard' : '/login';
      }

      if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
        return '/login';
      }

      if (isLoggedIn && (isGoingToLogin || isGoingToRegister)) {
        return '/dashboard';
      }

      return null;
    },
  );
});