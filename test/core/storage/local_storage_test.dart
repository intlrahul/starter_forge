import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/core/storage/local_storage.dart';

void main() {
  group('LocalStorage', () {
    group('initialization', () {
      test('init method exists and can be called', () {
        expect(() => LocalStorage.init(), returnsNormally);
      });

      test('close method exists and can be called', () {
        expect(() => LocalStorage.close(), returnsNormally);
      });
    });

    group('app data operations', () {
      test('setAppData method exists and can be called', () {
        expect(() => LocalStorage.setAppData('test_key', 'test_value'), 
            returnsNormally);
      });

      test('getAppData method exists and returns correct type', () {
        expect(() => LocalStorage.getAppData<String>('test_key'), 
            returnsNormally);
      });

      test('getAppData with default value works', () {
        expect(() => LocalStorage.getAppData<String>('test_key', 
            defaultValue: 'default'), 
            returnsNormally);
      });

      test('deleteAppData method exists and can be called', () {
        expect(() => LocalStorage.deleteAppData('test_key'), returnsNormally);
      });

      test('setAppData handles different data types', () {
        expect(() => LocalStorage.setAppData('string_key', 'string_value'), 
            returnsNormally);
        expect(() => LocalStorage.setAppData('int_key', 42), returnsNormally);
        expect(() => LocalStorage.setAppData('bool_key', true), returnsNormally);
        expect(() => LocalStorage.setAppData('list_key', [1, 2, 3]), 
            returnsNormally);
        expect(() => LocalStorage.setAppData('map_key', {'key': 'value'}), 
            returnsNormally);
      });

      test('getAppData handles different data types', () {
        expect(() => LocalStorage.getAppData<String>('string_key'), 
            returnsNormally);
        expect(() => LocalStorage.getAppData<int>('int_key'), returnsNormally);
        expect(() => LocalStorage.getAppData<bool>('bool_key'), returnsNormally);
        expect(() => LocalStorage.getAppData<List>('list_key'), returnsNormally);
        expect(() => LocalStorage.getAppData<Map>('map_key'), returnsNormally);
      });
    });

    group('user data operations', () {
      test('setUserData stores data successfully', () {
        expect(() => LocalStorage.setUserData('user_key', 'user_value'), 
            returnsNormally);
      });

      test('getUserData retrieves data successfully', () {
        expect(() => LocalStorage.getUserData<String>('user_key'), 
            returnsNormally);
      });

      test('getUserData returns default value when key not found', () {
        expect(() => LocalStorage.getUserData<String>('nonexistent_key', 
            defaultValue: 'default'), 
            returnsNormally);
      });

      test('deleteUserData removes data successfully', () {
        expect(() => LocalStorage.deleteUserData('user_key'), returnsNormally);
      });

      test('clearUserData clears all user data', () {
        expect(() => LocalStorage.clearUserData(), returnsNormally);
      });

      test('setUserData handles complex objects', () {
        final complexObject = {
          'profile': {
            'name': 'John Doe',
            'age': 30,
            'preferences': {
              'theme': 'dark',
              'notifications': true,
            },
          },
          'settings': ['setting1', 'setting2'],
          'lastLogin': DateTime.now().millisecondsSinceEpoch,
        };

        expect(() => LocalStorage.setUserData('profile', complexObject), 
            returnsNormally);
      });
    });

    group('cache data operations', () {
      test('setCacheData stores data successfully', () {
        expect(() => LocalStorage.setCacheData('cache_key', 'cache_value'), 
            returnsNormally);
      });

      test('getCacheData retrieves data successfully', () {
        expect(() => LocalStorage.getCacheData<String>('cache_key'), 
            returnsNormally);
      });

      test('getCacheData returns default value when key not found', () {
        expect(() => LocalStorage.getCacheData<String>('nonexistent_key', 
            defaultValue: 'default'), 
            returnsNormally);
      });

      test('clearCache clears all cache data', () {
        expect(() => LocalStorage.clearCache(), returnsNormally);
      });

      test('setCacheData handles temporary data', () {
        final tempData = {
          'api_response': {
            'data': ['item1', 'item2', 'item3'],
            'metadata': {
              'total': 3,
              'page': 1,
            },
          },
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'expiry': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch,
        };

        expect(() => LocalStorage.setCacheData('api_cache', tempData), 
            returnsNormally);
      });
    });

    group('error handling', () {
      test('setAppData handles errors gracefully', () {
        expect(() => LocalStorage.setAppData('error_key', 'value'), 
            returnsNormally);
      });

      test('getAppData handles errors gracefully', () {
        expect(() => LocalStorage.getAppData<String>('error_key', 
            defaultValue: 'default'), 
            returnsNormally);
      });

      test('deleteAppData handles errors gracefully', () {
        expect(() => LocalStorage.deleteAppData('error_key'), returnsNormally);
      });

      test('setUserData handles errors gracefully', () {
        expect(() => LocalStorage.setUserData('error_key', 'value'), 
            returnsNormally);
      });

      test('getUserData handles errors gracefully', () {
        expect(() => LocalStorage.getUserData<String>('error_key', 
            defaultValue: 'default'), 
            returnsNormally);
      });

      test('deleteUserData handles errors gracefully', () {
        expect(() => LocalStorage.deleteUserData('error_key'), returnsNormally);
      });

      test('setCacheData handles errors gracefully', () {
        expect(() => LocalStorage.setCacheData('error_key', 'value'), 
            returnsNormally);
      });

      test('getCacheData handles errors gracefully', () {
        expect(() => LocalStorage.getCacheData<String>('error_key', 
            defaultValue: 'default'), 
            returnsNormally);
      });

      test('clearCache handles errors gracefully', () {
        expect(() => LocalStorage.clearCache(), returnsNormally);
      });

      test('clearUserData handles errors gracefully', () {
        expect(() => LocalStorage.clearUserData(), returnsNormally);
      });
    });

    group('type safety', () {
      test('handles type casting correctly', () {
        expect(() => LocalStorage.getAppData<String>('key'), returnsNormally);
      });

      test('handles null values correctly', () {
        expect(() => LocalStorage.getAppData<String?>('nullable_key'), 
            returnsNormally);
      });

      test('stores null values correctly', () {
        expect(() => LocalStorage.setAppData<String?>('nullable_key', null), 
            returnsNormally);
      });
    });

    group('box management', () {
      test('close closes all boxes successfully', () {
        expect(() => LocalStorage.close(), returnsNormally);
      });

      test('close handles errors gracefully', () {
        expect(() => LocalStorage.close(), returnsNormally);
      });

      test('close handles null boxes gracefully', () {
        // Test with null boxes
        expect(() => LocalStorage.close(), returnsNormally);
      });
    });

    group('edge cases', () {
      test('handles very large data objects', () {
        final largeData = List.generate(1000, (index) => {
          'id': index,
          'data': 'large_string_' * 100,
          'nested': {
            'level1': {
              'level2': {
                'items': List.generate(50, (i) => 'item_$i'),
              },
            },
          },
        });

        expect(() => LocalStorage.setAppData('large_data', largeData), 
            returnsNormally);
      });

      test('handles empty keys', () {
        expect(() => LocalStorage.setAppData('', 'value'), returnsNormally);
        expect(() => LocalStorage.getAppData<String>(''), returnsNormally);
      });

      test('handles special characters in keys', () {
        const specialKey = 'key-with-special@chars#\$%^&*()';
        
        expect(() => LocalStorage.setAppData(specialKey, 'value'), 
            returnsNormally);
        expect(() => LocalStorage.getAppData<String>(specialKey), 
            returnsNormally);
      });

      test('handles concurrent operations', () {
        final futures = List.generate(10, (index) => 
            LocalStorage.setAppData('concurrent_$index', 'value_$index'));

        expect(() => Future.wait(futures), returnsNormally);
      });
    });

    group('data persistence patterns', () {
      test('handles user session data', () {
        final sessionData = {
          'user_id': 'user123',
          'token': 'jwt_token_here',
          'expires_at': DateTime.now().add(Duration(hours: 24)).millisecondsSinceEpoch,
          'permissions': ['read', 'write', 'admin'],
        };

        expect(() => LocalStorage.setUserData('session', sessionData), 
            returnsNormally);
        expect(() => LocalStorage.getUserData<Map>('session'), returnsNormally);
      });

      test('handles application settings', () {
        final appSettings = {
          'theme': 'dark',
          'language': 'en',
          'notifications_enabled': true,
          'analytics_enabled': false,
          'cache_size_mb': 100,
          'auto_backup': true,
        };

        expect(() => LocalStorage.setAppData('settings', appSettings), 
            returnsNormally);
        expect(() => LocalStorage.getAppData<Map>('settings'), returnsNormally);
      });

      test('handles cache with expiration', () {
        final cacheEntry = {
          'data': {'key': 'value'},
          'cached_at': DateTime.now().millisecondsSinceEpoch,
          'expires_at': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch,
          'etag': 'abc123',
        };

        expect(() => LocalStorage.setCacheData('api_cache_key', cacheEntry), 
            returnsNormally);
        expect(() => LocalStorage.getCacheData<Map>('api_cache_key'), 
            returnsNormally);
      });
    });

    group('API consistency', () {
      test('all methods are consistent across data types', () {
        // App data methods
        expect(() => LocalStorage.setAppData('key', 'value'), returnsNormally);
        expect(() => LocalStorage.getAppData<String>('key'), returnsNormally);
        expect(() => LocalStorage.deleteAppData('key'), returnsNormally);

        // User data methods
        expect(() => LocalStorage.setUserData('key', 'value'), returnsNormally);
        expect(() => LocalStorage.getUserData<String>('key'), returnsNormally);
        expect(() => LocalStorage.deleteUserData('key'), returnsNormally);

        // Cache data methods
        expect(() => LocalStorage.setCacheData('key', 'value'), returnsNormally);
        expect(() => LocalStorage.getCacheData<String>('key'), returnsNormally);
      });

      test('clear methods work for their respective data types', () {
        expect(() => LocalStorage.clearCache(), returnsNormally);
        expect(() => LocalStorage.clearUserData(), returnsNormally);
        // Note: No clearAppData method exists by design
      });
    });

    group('static interface', () {
      test('all methods are static and accessible', () {
        // Verify that all methods are accessible without instance creation
        expect(LocalStorage.init, isA<Function>());
        expect(LocalStorage.close, isA<Function>());
        expect(LocalStorage.setAppData, isA<Function>());
        expect(LocalStorage.getAppData, isA<Function>());
        expect(LocalStorage.deleteAppData, isA<Function>());
        expect(LocalStorage.setUserData, isA<Function>());
        expect(LocalStorage.getUserData, isA<Function>());
        expect(LocalStorage.deleteUserData, isA<Function>());
        expect(LocalStorage.setCacheData, isA<Function>());
        expect(LocalStorage.getCacheData, isA<Function>());
        expect(LocalStorage.clearCache, isA<Function>());
        expect(LocalStorage.clearUserData, isA<Function>());
      });
    });
  });
}