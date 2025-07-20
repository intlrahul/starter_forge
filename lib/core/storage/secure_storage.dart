import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:starter_forge/core/logging/app_logger.dart';

/// Secure storage service for sensitive data like tokens
class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _biometricEnabledKey = 'biometric_enabled';

  /// Store access token
  Future<void> setAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
      AppLogger.debug('Access token stored securely');
    } catch (e) {
      AppLogger.error('Failed to store access token', e);
      rethrow;
    }
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      AppLogger.error('Failed to read access token', e);
      return null;
    }
  }

  /// Store refresh token
  Future<void> setRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
      AppLogger.debug('Refresh token stored securely');
    } catch (e) {
      AppLogger.error('Failed to store refresh token', e);
      rethrow;
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      AppLogger.error('Failed to read refresh token', e);
      return null;
    }
  }

  /// Store user ID
  Future<void> setUserId(String userId) async {
    try {
      await _storage.write(key: _userIdKey, value: userId);
      AppLogger.debug('User ID stored securely');
    } catch (e) {
      AppLogger.error('Failed to store user ID', e);
      rethrow;
    }
  }

  /// Get user ID
  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _userIdKey);
    } catch (e) {
      AppLogger.error('Failed to read user ID', e);
      return null;
    }
  }

  /// Store biometric setting
  Future<void> setBiometricEnabled({required bool enabled}) async {
    try {
      await _storage.write(
        key: _biometricEnabledKey,
        value: enabled.toString(),
      );
      AppLogger.debug('Biometric setting stored: $enabled');
    } catch (e) {
      AppLogger.error('Failed to store biometric setting', e);
      rethrow;
    }
  }

  /// Get biometric setting
  Future<bool> getBiometricEnabled() async {
    try {
      final value = await _storage.read(key: _biometricEnabledKey);
      return value?.toLowerCase() == 'true';
    } catch (e) {
      AppLogger.error('Failed to read biometric setting', e);
      return false;
    }
  }

  /// Clear all stored data (useful for logout)
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      AppLogger.debug('All secure storage cleared');
    } catch (e) {
      AppLogger.error('Failed to clear secure storage', e);
      rethrow;
    }
  }

  /// Store custom key-value pair
  Future<void> store(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      AppLogger.debug('Stored secure data for key: $key');
    } catch (e) {
      AppLogger.error('Failed to store secure data for key: $key', e);
      rethrow;
    }
  }

  /// Get value by key
  Future<String?> retrieve(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      AppLogger.error('Failed to retrieve secure data for key: $key', e);
      return null;
    }
  }

  /// Delete value by key
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
      AppLogger.debug('Deleted secure data for key: $key');
    } catch (e) {
      AppLogger.error('Failed to delete secure data for key: $key', e);
      rethrow;
    }
  }
}
