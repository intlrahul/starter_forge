import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_forge/app/service_locator.dart';
import 'package:starter_forge/features/dashboard/presentation/counter/counter_cubit.dart';
import 'package:starter_forge/features/dashboard/presentation/screens/home_screen.dart';
import 'package:starter_forge/features/profile/presentation/screens/profile_screen.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_bloc.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_event.dart';
import 'package:starter_forge/features/user_details/presentation/screens/user_details_screen.dart';

List<RouteBase> mainRoutes = [
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return BlocProvider(
        create: (context) => sl<CounterCubit>(),
        child: const HomeScreen(),
      );
    },
    routes: <RouteBase>[
      // This is how you define a sub-route
      GoRoute(
        name: 'userDetails', // Optional: give it a name for easier navigation
        path:
            'details/:detailsNumber', // The path for the sub-route. ':detailsNumber' is a path parameter.
        builder: (BuildContext context, GoRouterState state) {
          final String detailsNum =
              state.pathParameters['detailsNumber'] ?? '0';
          return BlocProvider(
            create: (context) =>
                sl<UserDetailsBloc>()..add(LoadUserDetails(detailsNum)),
            child: UserDetailsScreen(detailsNumber: detailsNum),
          );
        },
      ),
      GoRoute(
        // Add Profile Route
        path: '/profile',
        name: 'profile',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
      ),
    ],
  ),
];
