import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dashboard_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // Your initial route
    routes: <RouteBase>[...mainRoutes],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
