import 'package:injectable/injectable.dart';
import 'package:starter_forge/core/config/app_config.dart';
import 'package:starter_forge/core/logging/app_logger.dart';

/// Abstract analytics service interface
abstract class AnalyticsService {
  /// Track an event with parameters
  void trackEvent(String eventName, {Map<String, dynamic>? parameters});

  /// Set user properties
  void setUserProperties(Map<String, dynamic> properties);

  /// Set user ID
  void setUserId(String userId);

  /// Clear user data
  void clearUser();

  /// Track screen view
  void trackScreenView(String screenName, {Map<String, dynamic>? parameters});

  /// Track user action
  void trackUserAction(String action, {Map<String, dynamic>? parameters});

  /// Track error
  void trackError(String error, {Map<String, dynamic>? parameters});
}

/// Default analytics implementation (logs to console/file)
@Injectable(as: AnalyticsService)
class DefaultAnalyticsService implements AnalyticsService {
  String? _userId;
  final Map<String, dynamic> _userProperties = {};

  @override
  void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (!AppConfig.enableAnalytics) return;

    final eventData = {
      'event': eventName,
      'timestamp': DateTime.now().toIso8601String(),
      'userId': _userId,
      'userProperties': _userProperties,
      'parameters': parameters ?? {},
    };

    AppLogger.info('📊 Analytics Event: $eventName', eventData);
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    if (!AppConfig.enableAnalytics) return;

    _userProperties.addAll(properties);
    AppLogger.info('👤 User Properties Updated', properties);
  }

  @override
  void setUserId(String userId) {
    if (!AppConfig.enableAnalytics) return;

    _userId = userId;
    AppLogger.info('🆔 User ID Set: $userId');
  }

  @override
  void clearUser() {
    if (!AppConfig.enableAnalytics) return;

    _userId = null;
    _userProperties.clear();
    AppLogger.info('🧹 User Data Cleared');
  }

  @override
  void trackScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    trackEvent(
      'screen_view',
      parameters: {'screen_name': screenName, ...?parameters},
    );
  }

  @override
  void trackUserAction(String action, {Map<String, dynamic>? parameters}) {
    trackEvent('user_action', parameters: {'action': action, ...?parameters});
  }

  @override
  void trackError(String error, {Map<String, dynamic>? parameters}) {
    trackEvent(
      'error_occurred',
      parameters: {'error_message': error, ...?parameters},
    );
  }
}

/// Analytics manager that can switch between different implementations
@lazySingleton
class AnalyticsManager {
  AnalyticsManager(this._service);

  final AnalyticsService _service;

  /// Track an event
  void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    try {
      _service.trackEvent(eventName, parameters: parameters);
    } catch (e) {
      AppLogger.error('Failed to track event: $eventName', e);
    }
  }

  /// Set user properties
  void setUserProperties(Map<String, dynamic> properties) {
    try {
      _service.setUserProperties(properties);
    } catch (e) {
      AppLogger.error('Failed to set user properties', e);
    }
  }

  /// Set user ID
  void setUserId(String userId) {
    try {
      _service.setUserId(userId);
    } catch (e) {
      AppLogger.error('Failed to set user ID', e);
    }
  }

  /// Clear user data
  void clearUser() {
    try {
      _service.clearUser();
    } catch (e) {
      AppLogger.error('Failed to clear user data', e);
    }
  }

  /// Track screen view
  void trackScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    try {
      _service.trackScreenView(screenName, parameters: parameters);
    } catch (e) {
      AppLogger.error('Failed to track screen view: $screenName', e);
    }
  }

  /// Track user action
  void trackUserAction(String action, {Map<String, dynamic>? parameters}) {
    try {
      _service.trackUserAction(action, parameters: parameters);
    } catch (e) {
      AppLogger.error('Failed to track user action: $action', e);
    }
  }

  /// Track error
  void trackError(String error, {Map<String, dynamic>? parameters}) {
    try {
      _service.trackError(error, parameters: parameters);
    } catch (e) {
      AppLogger.error('Failed to track error', e);
    }
  }

  // Convenience methods for common events

  /// Track app launch
  void trackAppLaunch() {
    trackEvent(
      'app_launch',
      parameters: {
        'app_version': AppConfig.appVersion,
        'environment': AppConfig.environment,
      },
    );
  }

  /// Track login
  void trackLogin(String method) {
    trackEvent('login', parameters: {'login_method': method});
  }

  /// Track logout
  void trackLogout() {
    trackEvent('logout');
  }

  /// Track signup
  void trackSignup(String method) {
    trackEvent('signup', parameters: {'signup_method': method});
  }

  /// Track button tap
  void trackButtonTap(String buttonName, {String? screen}) {
    trackUserAction(
      'button_tap',
      parameters: {
        'button_name': buttonName,
        if (screen != null) 'screen': screen,
      },
    );
  }

  /// Track feature usage
  void trackFeatureUsage(
    String feature, {
    Map<String, dynamic>? additionalData,
  }) {
    trackEvent(
      'feature_used',
      parameters: {'feature_name': feature, ...?additionalData},
    );
  }

  /// Track performance metrics
  void trackPerformance(
    String metric,
    Duration duration, {
    Map<String, dynamic>? additionalData,
  }) {
    trackEvent(
      'performance_metric',
      parameters: {
        'metric_name': metric,
        'duration_ms': duration.inMilliseconds,
        ...?additionalData,
      },
    );
  }
}
