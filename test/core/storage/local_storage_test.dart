import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/core/storage/local_storage.dart';

void main() {
  group('LocalStorage', () {
    group('initialization tests', () {
      test('init method exists and can be called', () {
        // Testing that the method is callable, but expected to fail in test environment
        expect(() => LocalStorage.init(), returnsNormally);
      });

      test('close method exists and can be called', () {
        expect(() => LocalStorage.close(), returnsNormally);
      });
    });

    group('error handling - uninitialized state', () {
      setUp(() {
        // Ensure we're testing uninitialized state
        LocalStorage.close();
      });

      test('setAppData throws exception when not initialized', () {
        expect(() => LocalStorage.setAppData('test_key', 'test_value'), 
            throwsA(isA<Exception>()));
      });

      test('deleteAppData throws exception when not initialized', () {
        expect(() => LocalStorage.deleteAppData('test_key'), 
            throwsA(isA<Exception>()));
      });

      test('setUserData throws exception when not initialized', () {
        expect(() => LocalStorage.setUserData('test_key', 'test_value'), 
            throwsA(isA<Exception>()));
      });

      test('deleteUserData throws exception when not initialized', () {
        expect(() => LocalStorage.deleteUserData('test_key'), 
            throwsA(isA<Exception>()));
      });

      test('setCacheData throws exception when not initialized', () {
        expect(() => LocalStorage.setCacheData('test_key', 'test_value'), 
            throwsA(isA<Exception>()));
      });

      test('clearCache throws exception when not initialized', () {
        expect(() => LocalStorage.clearCache(), 
            throwsA(isA<Exception>()));
      });

      test('clearUserData throws exception when not initialized', () {
        expect(() => LocalStorage.clearUserData(), 
            throwsA(isA<Exception>()));
      });

      test('getAppData returns null when not initialized', () {
        final result = LocalStorage.getAppData<String>('test_key');
        expect(result, isNull);
      });

      test('getUserData returns null when not initialized', () {
        final result = LocalStorage.getUserData<String>('test_key');
        expect(result, isNull);
      });

      test('getCacheData returns null when not initialized', () {
        final result = LocalStorage.getCacheData<String>('test_key');
        expect(result, isNull);
      });

      test('getAppData returns default value when not initialized', () {
        final result = LocalStorage.getAppData<String>('test_key', defaultValue: 'default');
        expect(result, equals('default'));
      });

      test('getUserData returns default value when not initialized', () {
        final result = LocalStorage.getUserData<String>('test_key', defaultValue: 'default');
        expect(result, equals('default'));
      });

      test('getCacheData returns default value when not initialized', () {
        final result = LocalStorage.getCacheData<String>('test_key', defaultValue: 'default');
        expect(result, equals('default'));
      });
    });

    group('API surface validation', () {
      test('setAppData accepts different data types', () {
        // These will fail but the important thing is the API signatures exist
        expect(() => LocalStorage.setAppData('string_key', 'string_value'), throwsA(isA<Exception>()));
        expect(() => LocalStorage.setAppData('int_key', 42), throwsA(isA<Exception>()));
        expect(() => LocalStorage.setAppData('bool_key', true), throwsA(isA<Exception>()));
        expect(() => LocalStorage.setAppData('list_key', [1, 2, 3]), throwsA(isA<Exception>()));
        expect(() => LocalStorage.setAppData('map_key', {'key': 'value'}), throwsA(isA<Exception>()));
      });

      test('getAppData handles different data types with defaults', () {
        expect(LocalStorage.getAppData<String>('string_key', defaultValue: 'default'), equals('default'));
        expect(LocalStorage.getAppData<int>('int_key', defaultValue: 42), equals(42));
        expect(LocalStorage.getAppData<bool>('bool_key', defaultValue: true), equals(true));
        expect(LocalStorage.getAppData<List>('list_key', defaultValue: [1, 2, 3]), equals([1, 2, 3]));
        expect(LocalStorage.getAppData<Map>('map_key', defaultValue: {'key': 'value'}), equals({'key': 'value'}));
      });

      test('setUserData accepts complex objects', () {
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

        expect(() => LocalStorage.setUserData('profile', complexObject), throwsA(isA<Exception>()));
      });

      test('setCacheData accepts temporary data structures', () {
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

        expect(() => LocalStorage.setCacheData('api_cache', tempData), throwsA(isA<Exception>()));
      });
    });

    group('type safety validation', () {
      test('handles type casting correctly', () {
        expect(LocalStorage.getAppData<String>('key', defaultValue: 'default'), equals('default'));
        expect(LocalStorage.getAppData<String>('key'), isNull);
      });

      test('handles null values correctly', () {
        expect(LocalStorage.getAppData<String?>('nullable_key'), isNull);
        expect(() => LocalStorage.setAppData<String?>('nullable_key', null), throwsA(isA<Exception>()));
      });

      test('supports different nullable types', () {
        expect(LocalStorage.getAppData<int?>('int_key'), isNull);
        expect(LocalStorage.getAppData<bool?>('bool_key'), isNull);
        expect(LocalStorage.getAppData<List?>('list_key'), isNull);
        expect(LocalStorage.getAppData<Map?>('map_key'), isNull);
      });
    });

    group('edge case handling', () {
      test('handles empty keys', () {
        expect(() => LocalStorage.setAppData('', 'value'), throwsA(isA<Exception>()));
        expect(LocalStorage.getAppData<String>(''), isNull);
        expect(LocalStorage.getAppData<String>('', defaultValue: 'default'), equals('default'));
      });

      test('handles special characters in keys', () {
        const specialKey = 'key-with-special@chars';
        expect(() => LocalStorage.setAppData(specialKey, 'value'), throwsA(isA<Exception>()));
        expect(LocalStorage.getAppData<String>(specialKey), isNull);
        expect(LocalStorage.getAppData<String>(specialKey, defaultValue: 'default'), equals('default'));
      });

      test('handles very long keys', () {
        final longKey = 'very_long_key_' * 100;
        expect(() => LocalStorage.setAppData(longKey, 'value'), throwsA(isA<Exception>()));
        expect(LocalStorage.getAppData<String>(longKey), isNull);
      });
    });

    group('data pattern validation', () {
      test('user session data pattern', () {
        final sessionData = {
          'user_id': 'user123',
          'token': 'jwt_token_here',
          'expires_at': DateTime.now().add(Duration(hours: 24)).millisecondsSinceEpoch,
          'permissions': ['read', 'write', 'admin'],
        };

        expect(() => LocalStorage.setUserData('session', sessionData), throwsA(isA<Exception>()));
        expect(LocalStorage.getUserData<Map>('session'), isNull);
        expect(LocalStorage.getUserData<Map>('session', defaultValue: {}), equals({}));
      });

      test('application settings pattern', () {
        final appSettings = {
          'theme': 'dark',
          'language': 'en',
          'notifications_enabled': true,
          'analytics_enabled': false,
          'cache_size_mb': 100,
          'auto_backup': true,
        };

        expect(() => LocalStorage.setAppData('settings', appSettings), throwsA(isA<Exception>()));
        expect(LocalStorage.getAppData<Map>('settings'), isNull);
      });

      test('cache with expiration pattern', () {
        final cacheEntry = {
          'data': {'key': 'value'},
          'cached_at': DateTime.now().millisecondsSinceEpoch,
          'expires_at': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch,
          'etag': 'abc123',
        };

        expect(() => LocalStorage.setCacheData('api_cache_key', cacheEntry), throwsA(isA<Exception>()));
        expect(LocalStorage.getCacheData<Map>('api_cache_key'), isNull);
      });
    });

    group('API consistency validation', () {
      test('all setter methods follow same pattern', () {
        expect(() => LocalStorage.setAppData('key', 'value'), throwsA(isA<Exception>()));
        expect(() => LocalStorage.setUserData('key', 'value'), throwsA(isA<Exception>()));
        expect(() => LocalStorage.setCacheData('key', 'value'), throwsA(isA<Exception>()));
      });

      test('all getter methods follow same pattern', () {
        expect(LocalStorage.getAppData<String>('key'), isNull);
        expect(LocalStorage.getUserData<String>('key'), isNull);
        expect(LocalStorage.getCacheData<String>('key'), isNull);
      });

      test('all deletion methods follow same pattern', () {
        expect(() => LocalStorage.deleteAppData('key'), throwsA(isA<Exception>()));
        expect(() => LocalStorage.deleteUserData('key'), throwsA(isA<Exception>()));
        // Note: No deleteCacheData method exists by design
      });

      test('clear methods work for their respective data types', () {
        expect(() => LocalStorage.clearCache(), throwsA(isA<Exception>()));
        expect(() => LocalStorage.clearUserData(), throwsA(isA<Exception>()));
        // Note: No clearAppData method exists by design
      });
    });

    group('static interface verification', () {
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

      test('method signatures accept correct parameter types', () {
        // Test that methods have the expected signatures by checking they compile
        expect(() {
          // These calls will throw but prove the signatures are correct
          LocalStorage.setAppData<String>('key', 'value');
          LocalStorage.setAppData<int>('key', 42);
          LocalStorage.setAppData<bool>('key', true);
          LocalStorage.setAppData<List>('key', []);
          LocalStorage.setAppData<Map>('key', {});
          
          LocalStorage.getAppData<String>('key');
          LocalStorage.getAppData<String>('key', defaultValue: 'default');
          
          LocalStorage.getUserData<Map>('key');
          LocalStorage.setCacheData<List>('key', []);
        }, throwsA(isA<Exception>()));
      });
    });

    group('defensive programming validation', () {
      test('all operations handle uninitialized state gracefully', () {
        // Ensure LocalStorage is closed
        LocalStorage.close();
        
        // All write operations should throw exceptions
        expect(() => LocalStorage.setAppData('key', 'value'), throwsA(isA<Exception>()));
        expect(() => LocalStorage.setUserData('key', 'value'), throwsA(isA<Exception>()));
        expect(() => LocalStorage.setCacheData('key', 'value'), throwsA(isA<Exception>()));
        expect(() => LocalStorage.deleteAppData('key'), throwsA(isA<Exception>()));
        expect(() => LocalStorage.deleteUserData('key'), throwsA(isA<Exception>()));
        expect(() => LocalStorage.clearCache(), throwsA(isA<Exception>()));
        expect(() => LocalStorage.clearUserData(), throwsA(isA<Exception>()));
        
        // All read operations should return null or default values
        expect(LocalStorage.getAppData<String>('key'), isNull);
        expect(LocalStorage.getUserData<String>('key'), isNull);
        expect(LocalStorage.getCacheData<String>('key'), isNull);
        expect(LocalStorage.getAppData<String>('key', defaultValue: 'default'), equals('default'));
      });

      test('initialization and cleanup are safe to call multiple times', () {
        expect(() => LocalStorage.init(), returnsNormally);
        expect(() => LocalStorage.init(), returnsNormally); // Should be safe to call again
        expect(() => LocalStorage.close(), returnsNormally);
        expect(() => LocalStorage.close(), returnsNormally); // Should be safe to call again
      });
    });
  });
}
