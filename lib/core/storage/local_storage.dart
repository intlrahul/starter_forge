import 'package:hive_flutter/hive_flutter.dart';
import 'package:starter_forge/core/logging/app_logger.dart';

/// Local storage service using Hive for app data
class LocalStorage {
  static const String _appBoxName = 'app_data';
  static const String _userBoxName = 'user_data';
  static const String _cacheBoxName = 'cache_data';

  static Box? _appBox;
  static Box? _userBox;
  static Box? _cacheBox;

  /// Initialize Hive and open boxes
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      
      _appBox = await Hive.openBox(_appBoxName);
      _userBox = await Hive.openBox(_userBoxName);
      _cacheBox = await Hive.openBox(_cacheBoxName);
      
      AppLogger.info('Local storage initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize local storage', e);
      rethrow;
    }
  }

  /// App-level storage (settings, preferences, etc.)
  static Box get appBox {
    if (_appBox == null || !_appBox!.isOpen) {
      throw Exception('App box not initialized. Call LocalStorage.init() first.');
    }
    return _appBox!;
  }

  /// User-specific storage
  static Box get userBox {
    if (_userBox == null || !_userBox!.isOpen) {
      throw Exception('User box not initialized. Call LocalStorage.init() first.');
    }
    return _userBox!;
  }

  /// Cache storage (temporary data)
  static Box get cacheBox {
    if (_cacheBox == null || !_cacheBox!.isOpen) {
      throw Exception('Cache box not initialized. Call LocalStorage.init() first.');
    }
    return _cacheBox!;
  }

  /// Store data in app box
  static Future<void> setAppData<T>(String key, T value) async {
    try {
      await appBox.put(key, value);
      AppLogger.debug('Stored app data: $key');
    } catch (e) {
      AppLogger.error('Failed to store app data: $key', e);
      rethrow;
    }
  }

  /// Get data from app box
  static T? getAppData<T>(String key, {T? defaultValue}) {
    try {
      return appBox.get(key, defaultValue: defaultValue) as T?;
    } catch (e) {
      AppLogger.error('Failed to get app data: $key', e);
      return defaultValue;
    }
  }

  /// Store data in user box
  static Future<void> setUserData<T>(String key, T value) async {
    try {
      await userBox.put(key, value);
      AppLogger.debug('Stored user data: $key');
    } catch (e) {
      AppLogger.error('Failed to store user data: $key', e);
      rethrow;
    }
  }

  /// Get data from user box
  static T? getUserData<T>(String key, {T? defaultValue}) {
    try {
      return userBox.get(key, defaultValue: defaultValue) as T?;
    } catch (e) {
      AppLogger.error('Failed to get user data: $key', e);
      return defaultValue;
    }
  }

  /// Store data in cache box
  static Future<void> setCacheData<T>(String key, T value) async {
    try {
      await cacheBox.put(key, value);
      AppLogger.debug('Stored cache data: $key');
    } catch (e) {
      AppLogger.error('Failed to store cache data: $key', e);
      rethrow;
    }
  }

  /// Get data from cache box
  static T? getCacheData<T>(String key, {T? defaultValue}) {
    try {
      return cacheBox.get(key, defaultValue: defaultValue) as T?;
    } catch (e) {
      AppLogger.error('Failed to get cache data: $key', e);
      return defaultValue;
    }
  }

  /// Delete data from app box
  static Future<void> deleteAppData(String key) async {
    try {
      await appBox.delete(key);
      AppLogger.debug('Deleted app data: $key');
    } catch (e) {
      AppLogger.error('Failed to delete app data: $key', e);
      rethrow;
    }
  }

  /// Delete data from user box
  static Future<void> deleteUserData(String key) async {
    try {
      await userBox.delete(key);
      AppLogger.debug('Deleted user data: $key');
    } catch (e) {
      AppLogger.error('Failed to delete user data: $key', e);
      rethrow;
    }
  }

  /// Clear all cache data
  static Future<void> clearCache() async {
    try {
      await cacheBox.clear();
      AppLogger.info('Cache cleared');
    } catch (e) {
      AppLogger.error('Failed to clear cache', e);
      rethrow;
    }
  }

  /// Clear all user data
  static Future<void> clearUserData() async {
    try {
      await userBox.clear();
      AppLogger.info('User data cleared');
    } catch (e) {
      AppLogger.error('Failed to clear user data', e);
      rethrow;
    }
  }

  /// Close all boxes (call on app termination)
  static Future<void> close() async {
    try {
      await _appBox?.close();
      await _userBox?.close();
      await _cacheBox?.close();
      AppLogger.info('Local storage closed');
    } catch (e) {
      AppLogger.error('Failed to close local storage', e);
    }
  }
}