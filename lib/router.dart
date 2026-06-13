import 'package:go_router/go_router.dart';

import 'feature/auth/presentation/view/post_screen.dart';
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
       builder: (context, state) => PostScreen()
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