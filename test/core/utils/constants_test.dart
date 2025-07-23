import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/core/utils/constants.dart';

void main() {
  group('AppConstants', () {
    group('API endpoints', () {
      test('has correct API endpoint constants', () {
        expect(AppConstants.apiLogin, equals('/auth/login'));
        expect(AppConstants.apiRegister, equals('/auth/register'));
        expect(AppConstants.apiRefreshToken, equals('/auth/refresh'));
        expect(AppConstants.apiProfile, equals('/user/profile'));
        expect(AppConstants.apiLogout, equals('/auth/logout'));
      });
    });

    group('Storage keys', () {
      test('has correct storage key constants', () {
        expect(AppConstants.keyFirstLaunch, equals('first_launch'));
        expect(AppConstants.keyOnboardingComplete, equals('onboarding_complete'));
        expect(AppConstants.keyUserPreferences, equals('user_preferences'));
        expect(AppConstants.keyLanguage, equals('language'));
        expect(AppConstants.keyNotificationsEnabled, equals('notifications_enabled'));
      });
    });

    group('UI constants', () {
      test('has correct padding constants', () {
        expect(AppConstants.defaultPadding, equals(16.0));
        expect(AppConstants.smallPadding, equals(8.0));
        expect(AppConstants.largePadding, equals(24.0));
      });

      test('has correct border radius constants', () {
        expect(AppConstants.borderRadius, equals(12.0));
        expect(AppConstants.smallBorderRadius, equals(8.0));
        expect(AppConstants.largeBorderRadius, equals(16.0));
      });
    });

    group('Animation durations', () {
      test('has correct animation duration constants', () {
        expect(AppConstants.shortAnimationDuration, equals(const Duration(milliseconds: 200)));
        expect(AppConstants.mediumAnimationDuration, equals(const Duration(milliseconds: 300)));
        expect(AppConstants.longAnimationDuration, equals(const Duration(milliseconds: 500)));
      });
    });

    group('Network timeouts', () {
      test('has correct timeout constants', () {
        expect(AppConstants.networkTimeout, equals(const Duration(seconds: 30)));
        expect(AppConstants.shortTimeout, equals(const Duration(seconds: 10)));
        expect(AppConstants.longTimeout, equals(const Duration(seconds: 60)));
      });
    });

    group('File size limits', () {
      test('has correct file size constants', () {
        expect(AppConstants.maxImageSizeBytes, equals(5 * 1024 * 1024)); // 5MB
        expect(AppConstants.maxDocumentSizeBytes, equals(10 * 1024 * 1024)); // 10MB
      });
    });

    group('Validation constants', () {
      test('has correct validation constants', () {
        expect(AppConstants.minPasswordLength, equals(8));
        expect(AppConstants.maxPasswordLength, equals(128));
        expect(AppConstants.minNameLength, equals(2));
        expect(AppConstants.maxNameLength, equals(50));
        expect(AppConstants.maxBioLength, equals(500));
      });
    });

    group('Pagination constants', () {
      test('has correct pagination constants', () {
        expect(AppConstants.defaultPageSize, equals(20));
        expect(AppConstants.maxPageSize, equals(100));
      });
    });

    group('Date formats', () {
      test('has correct date format constants', () {
        expect(AppConstants.dateFormat, equals('yyyy-MM-dd'));
        expect(AppConstants.dateTimeFormat, equals('yyyy-MM-dd HH:mm:ss'));
        expect(AppConstants.displayDateFormat, equals('MMM dd, yyyy'));
        expect(AppConstants.displayDateTimeFormat, equals('MMM dd, yyyy HH:mm'));
      });
    });

    group('Regular expressions', () {
      test('has correct regex constants', () {
        expect(AppConstants.emailRegex, isA<String>());
        expect(AppConstants.phoneRegex, isA<String>());
        expect(AppConstants.urlRegex, isA<String>());
        
        // Test that regex patterns are valid
        expect(() => RegExp(AppConstants.emailRegex), returnsNormally);
        expect(() => RegExp(AppConstants.phoneRegex), returnsNormally);
        expect(() => RegExp(AppConstants.urlRegex), returnsNormally);
      });
    });

    group('Error messages', () {
      test('has correct error message constants', () {
        expect(AppConstants.genericErrorMessage, equals('Something went wrong. Please try again.'));
        expect(AppConstants.networkErrorMessage, equals('Network error. Please check your connection.'));
        expect(AppConstants.timeoutErrorMessage, equals('Request timed out. Please try again.'));
        expect(AppConstants.unauthorizedErrorMessage, equals('You are not authorized to perform this action.'));
      });
    });

    group('Success messages', () {
      test('has correct success message constants', () {
        expect(AppConstants.loginSuccessMessage, equals('Login successful!'));
        expect(AppConstants.registerSuccessMessage, equals('Registration successful!'));
        expect(AppConstants.profileUpdateSuccessMessage, equals('Profile updated successfully!'));
        expect(AppConstants.passwordChangeSuccessMessage, equals('Password changed successfully!'));
      });
    });

    group('Feature flags', () {
      test('has correct feature flag constants', () {
        expect(AppConstants.enableAnalytics, isA<bool>());
        expect(AppConstants.enableCrashlytics, isA<bool>());
        expect(AppConstants.enableBiometricAuth, isA<bool>());
        expect(AppConstants.enableNotifications, isA<bool>());
      });
    });

    group('Deep link schemes', () {
      test('has correct deep link constants', () {
        expect(AppConstants.deepLinkScheme, equals('starterforge'));
        expect(AppConstants.webScheme, equals('https'));
        expect(AppConstants.webHost, equals('starterforge.app'));
      });
    });

    group('Social login', () {
      test('has correct social login constants', () {
        expect(AppConstants.googleClientId, isA<String>());
        expect(AppConstants.facebookAppId, isA<String>());
        expect(AppConstants.appleServiceId, isA<String>());
      });
    });

    group('Asset paths', () {
      test('has correct asset path constants', () {
        expect(AppConstants.logoPath, equals('assets/images/logo.png'));
        expect(AppConstants.placeholderImagePath, equals('assets/images/placeholder.png'));
        expect(AppConstants.defaultAvatarPath, equals('assets/images/default_avatar.png'));
      });
    });

    group('Supported file types', () {
      test('has correct supported file type constants', () {
        expect(AppConstants.supportedImageTypes, equals(['jpg', 'jpeg', 'png', 'gif']));
        expect(AppConstants.supportedDocumentTypes, equals(['pdf', 'doc', 'docx', 'txt']));
      });
    });

    group('Cache keys', () {
      test('has correct cache key constants', () {
        expect(AppConstants.cacheKeyUserProfile, equals('user_profile'));
        expect(AppConstants.cacheKeyDashboardData, equals('dashboard_data'));
        expect(AppConstants.cacheKeySettings, equals('app_settings'));
      });
    });

    group('Privacy and terms URLs', () {
      test('has correct URL constants', () {
        expect(AppConstants.privacyPolicyUrl, equals('https://starterforge.app/privacy'));
        expect(AppConstants.termsOfServiceUrl, equals('https://starterforge.app/terms'));
        expect(AppConstants.supportUrl, equals('https://starterforge.app/support'));
      });
    });
  });
}
