import 'package:go_router/go_router.dart';

import 'feature/auth/presentation/view/post_screen.dart';

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
   ]
);