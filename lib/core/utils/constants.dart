/// Application constants
class AppConstants {
  // API endpoints
  static const String apiLogin = '/auth/login';
  static const String apiRegister = '/auth/register';
  static const String apiRefreshToken = '/auth/refresh';
  static const String apiProfile = '/user/profile';
  static const String apiLogout = '/auth/logout';

  // Storage keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyUserPreferences = 'user_preferences';
  static const String keyLanguage = 'language';
  static const String keyNotificationsEnabled = 'notifications_enabled';

  // UI constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Network timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  static const Duration longTimeout = Duration(seconds: 60);

  // File size limits
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const int maxDocumentSizeBytes = 10 * 1024 * 1024; // 10MB

  // Validation constants
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';

  // Regular expressions
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[\d\s\-\(\)]{10,}$';
  static const String urlRegex = r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';

  // Error messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String timeoutErrorMessage = 'Request timed out. Please try again.';
  static const String unauthorizedErrorMessage = 'You are not authorized to perform this action.';

  // Success messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String registerSuccessMessage = 'Registration successful!';
  static const String profileUpdateSuccessMessage = 'Profile updated successfully!';
  static const String passwordChangeSuccessMessage = 'Password changed successfully!';

  // Feature flags (can be overridden by remote config)
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  static const bool enableBiometricAuth = true;
  static const bool enableNotifications = true;

  // Deep link schemes
  static const String deepLinkScheme = 'starterforge';
  static const String webScheme = 'https';
  static const String webHost = 'starterforge.app';

  // Social login
  static const String googleClientId = 'your-google-client-id';
  static const String facebookAppId = 'your-facebook-app-id';
  static const String appleServiceId = 'your-apple-service-id';

  // Asset paths
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImagePath = 'assets/images/placeholder.png';
  static const String defaultAvatarPath = 'assets/images/default_avatar.png';

  // Supported file types
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> supportedDocumentTypes = ['pdf', 'doc', 'docx', 'txt'];

  // Cache keys
  static const String cacheKeyUserProfile = 'user_profile';
  static const String cacheKeyDashboardData = 'dashboard_data';
  static const String cacheKeySettings = 'app_settings';

  // Privacy and terms URLs
  static const String privacyPolicyUrl = 'https://starterforge.app/privacy';
  static const String termsOfServiceUrl = 'https://starterforge.app/terms';
  static const String supportUrl = 'https://starterforge.app/support';
}