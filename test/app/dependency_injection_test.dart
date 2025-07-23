import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/app/injection.dart';
import 'package:starter_forge/core/analytics/analytics_service.dart';
import 'package:starter_forge/core/network/connectivity_service.dart';
import 'package:starter_forge/core/network/dio_client.dart';
import 'package:starter_forge/core/storage/secure_storage.dart';
import 'package:starter_forge/features/dashboard/presentation/counter/counter_cubit.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_bloc.dart';

void main() {
  group('Dependency Injection Tests', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      configureDependencies();
    });

    tearDownAll(() {
      getIt.reset();
    });

    test('should inject all core services', () {
      // Test core services injection
      expect(getIt<DioClient>(), isA<DioClient>());
      expect(getIt<ConnectivityService>(), isA<ConnectivityService>());
      expect(getIt<AnalyticsManager>(), isA<AnalyticsManager>());
      expect(getIt<SecureStorage>(), isA<SecureStorage>());
    });

    test('should inject BLoCs and Cubits (excluding ThemeBloc for test simplicity)', () {
      // Test BLoCs and Cubits injection (excluding ThemeBloc which needs SharedPreferences)
      expect(getIt<CounterCubit>(), isA<CounterCubit>());
      expect(getIt<UserDetailsBloc>(), isA<UserDetailsBloc>());
      expect(getIt<ProfileBloc>(), isA<ProfileBloc>());
    });

    test('should return same instance for singletons', () {
      // Test singleton behavior
      final dioClient1 = getIt<DioClient>();
      final dioClient2 = getIt<DioClient>();
      expect(identical(dioClient1, dioClient2), isTrue);

      final connectivity1 = getIt<ConnectivityService>();
      final connectivity2 = getIt<ConnectivityService>();
      expect(identical(connectivity1, connectivity2), isTrue);
    });

    test('should return different instances for factories', () {
      // Test factory behavior
      final cubit1 = getIt<CounterCubit>();
      final cubit2 = getIt<CounterCubit>();
      expect(identical(cubit1, cubit2), isFalse);

      final bloc1 = getIt<UserDetailsBloc>();
      final bloc2 = getIt<UserDetailsBloc>();
      expect(identical(bloc1, bloc2), isFalse);
    });

    test('should inject dependencies into AnalyticsManager', () {
      // Test that AnalyticsManager receives its dependency
      final analyticsManager = getIt<AnalyticsManager>();
      expect(analyticsManager, isA<AnalyticsManager>());
      
      // Verify it can perform operations (implying service was injected)
      expect(() => analyticsManager.trackEvent('test_event'), returnsNormally);
    });

    test('should provide different types of analytics service', () {
      // Test the analytics service interface
      final analyticsService = getIt<AnalyticsService>();
      expect(analyticsService, isA<DefaultAnalyticsService>());
    });
  });
}
