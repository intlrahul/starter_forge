import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starter_forge/app/injection.dart';
import 'package:starter_forge/app/router/app_router.dart';
import 'package:starter_forge/core/analytics/analytics_service.dart';
import 'package:starter_forge/core/config/app_config.dart';
import 'package:starter_forge/core/network/connectivity_service.dart';
import 'package:starter_forge/core/storage/local_storage.dart';
import 'package:starter_forge/core/theme/app_theme.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_bloc.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_state.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Print app configuration
  AppConfig.printConfig();
  
  // Initialize storage
  await LocalStorage.init();
  
  // Configure dependency injection
  configureDependencies();
  
  // Initialize connectivity service
  await getIt<ConnectivityService>().initialize();
  
  // Track app launch
  getIt<AnalyticsManager>().trackAppLaunch();
  
  runApp(const StarterForgeApp());
}

class StarterForgeApp extends StatelessWidget {
  const StarterForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ThemeBloc>()),
        BlocProvider(
          create: (context) => getIt<ProfileBloc>()..add(LoadProfileData()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, theme) {
          return MaterialApp.router(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}