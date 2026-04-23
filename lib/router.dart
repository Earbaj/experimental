


import 'package:go_router/go_router.dart';
import 'package:untitled1/feature/auth/presentation/view/login_page.dart';

import 'main.dart';

class RouteName{
  static const String home = 'home';
}

final GoRouter router = GoRouter(
    initialLocation: '/',
   routes: [
     GoRoute(
       name: RouteName.home,
       path: '/',
       builder: (context, state) => const LoginScreen()
     ),
     GoRoute(
         path: '/profile/:id',
         builder: (context, state) {
           final id = state.pathParameters['id'];
           return ProfilePage(productId: id!);
         }
     ),
   ]
);