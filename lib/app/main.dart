import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starter_forge/app/router/app_router.dart';
import 'package:starter_forge/app/service_locator.dart';
import 'package:starter_forge/core/theme/app_theme.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_bloc.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_state.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Important if using SharedPreferences before runApp
  setupServiceLocator();
  runApp(const StarterForgeApp());
}

class StarterForgeApp extends StatelessWidget {
  const StarterForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider
      providers: [
        BlocProvider(create: (context) => sl<ThemeBloc>()),
        BlocProvider(
          create: (context) => sl<ProfileBloc>()..add(LoadProfileData()),
        ), // Provide ThemeCubit
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        // Listen to ThemeCubit
        builder: (context, theme) {
          return MaterialApp.router(
            title: 'Professional App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.themeMode, // Use themeMode from ThemeCubit
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
