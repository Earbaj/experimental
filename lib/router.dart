import 'package:go_router/go_router.dart';

import 'feature/ageprediction/presentation/view/age_prediction_view.dart';

class RouteName{
  static const String home = 'home';
}

final GoRouter router = GoRouter(
    initialLocation: '/',
   routes: [
     GoRoute(
       name: RouteName.home,
       path: '/',
       builder: (context, state) => AgePredictionView()
     ),
   ]
);