/// Application configuration based on environment
class AppConfig {
  /// Base URL for API calls
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  /// API version
  static const String apiVersion = String.fromEnvironment(
    'API_VERSION',
    defaultValue: 'v1',
  );

  /// Whether this is a production build
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  /// Whether this is a debug build
  static const bool isDebug = !isProduction;

  /// Application environment (dev, staging, prod)
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  /// Enable logging
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  /// Enable analytics
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  /// API timeout in seconds
  static const int apiTimeout = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30,
  );

  /// Full API base URL
  static String get fullApiUrl => '$baseUrl/$apiVersion';

  /// Whether we're in development environment
  static bool get isDevelopment => environment == 'dev';

  /// Whether we're in staging environment
  static bool get isStaging => environment == 'staging';

  /// Whether we're in production environment
  static bool get isProductionEnv => environment == 'prod';

  /// App name
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Starter Forge',
  );

  /// App version
  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );

  /// Print configuration for debugging
  static void printConfig() {
    if (isDebug) {
      // ignore: avoid_print
      print('🔧 App Configuration:');
      // ignore: avoid_print
      print('   Environment: $environment');
      // ignore: avoid_print
      print('   Base URL: $baseUrl');
      // ignore: avoid_print
      print('   Full API URL: $fullApiUrl');
      // ignore: avoid_print
      print('   Is Production: $isProduction');
      // ignore: avoid_print
      print('   Enable Logging: $enableLogging');
      // ignore: avoid_print
      print('   Enable Analytics: $enableAnalytics');
      // ignore: avoid_print
      print('   API Timeout: ${apiTimeout}s');
      // ignore: avoid_print
      print('   App Name: $appName');
      // ignore: avoid_print
      print('   App Version: $appVersion');
    }
  }
}