import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/core/network/dio_client.dart';

void main() {
  group('DioClient', () {
    late DioClient dioClient;

    setUp(() {
      dioClient = DioClient();
    });

    group('initialization', () {
      test('creates DioClient instance', () {
        expect(dioClient, isNotNull);
        expect(dioClient, isA<DioClient>());
      });

      test('dio property is accessible', () {
        expect(dioClient.dio, isNotNull);
        expect(dioClient.dio, isA<Dio>());
      });

      test('dio has correct base configuration', () {
        final dio = dioClient.dio;
        expect(dio.options.headers['Content-Type'], equals('application/json'));
        expect(dio.options.headers['Accept'], equals('application/json'));
        expect(dio.options.connectTimeout, isA<Duration>());
        expect(dio.options.receiveTimeout, isA<Duration>());
        expect(dio.options.sendTimeout, isA<Duration>());
      });
    });

    group('HTTP methods', () {
      test('get method exists and can be called', () {
        expect(() => dioClient.get('/test'), returnsNormally);
      });

      test('post method exists and can be called', () {
        expect(() => dioClient.post('/test'), returnsNormally);
      });

      test('put method exists and can be called', () {
        expect(() => dioClient.put('/test'), returnsNormally);
      });

      test('delete method exists and can be called', () {
        expect(() => dioClient.delete('/test'), returnsNormally);
      });

      test('uploadFile method exists and can be called', () {
        final formData = FormData();
        expect(() => dioClient.uploadFile('/upload', formData), returnsNormally);
      });
    });

    group('method parameters', () {
      test('get accepts query parameters', () {
        final queryParams = {'key': 'value'};
        expect(() => dioClient.get('/test', queryParameters: queryParams), 
            returnsNormally);
      });

      test('post accepts data and query parameters', () {
        final data = {'field': 'value'};
        final queryParams = {'key': 'value'};
        expect(() => dioClient.post('/test', 
            data: data, queryParameters: queryParams), 
            returnsNormally);
      });

      test('put accepts data and query parameters', () {
        final data = {'field': 'value'};
        final queryParams = {'key': 'value'};
        expect(() => dioClient.put('/test', 
            data: data, queryParameters: queryParams), 
            returnsNormally);
      });

      test('delete accepts data and query parameters', () {
        final data = {'field': 'value'};
        final queryParams = {'key': 'value'};
        expect(() => dioClient.delete('/test', 
            data: data, queryParameters: queryParams), 
            returnsNormally);
      });
    });

    group('options and cancellation', () {
      test('methods accept Options parameter', () {
        final options = Options(headers: {'Custom-Header': 'value'});
        
        expect(() => dioClient.get('/test', options: options), returnsNormally);
        expect(() => dioClient.post('/test', options: options), returnsNormally);
        expect(() => dioClient.put('/test', options: options), returnsNormally);
        expect(() => dioClient.delete('/test', options: options), returnsNormally);
      });

      test('methods accept CancelToken parameter', () {
        final cancelToken = CancelToken();
        
        expect(() => dioClient.get('/test', cancelToken: cancelToken), 
            returnsNormally);
        expect(() => dioClient.post('/test', cancelToken: cancelToken), 
            returnsNormally);
        expect(() => dioClient.put('/test', cancelToken: cancelToken), 
            returnsNormally);
        expect(() => dioClient.delete('/test', cancelToken: cancelToken), 
            returnsNormally);
      });
    });

    group('file upload', () {
      test('uploadFile accepts FormData', () {
        final formData = FormData.fromMap({
          'file': MultipartFile.fromString('test content', filename: 'test.txt'),
        });
        
        expect(() => dioClient.uploadFile('/upload', formData), returnsNormally);
      });

      test('uploadFile accepts progress callback', () {
        final formData = FormData.fromMap({
          'file': MultipartFile.fromString('test content', filename: 'test.txt'),
        });
        
        void progressCallback(int sent, int total) {
          // Progress callback implementation
        }
        
        expect(() => dioClient.uploadFile('/upload', formData, 
            onSendProgress: progressCallback), 
            returnsNormally);
      });
    });

    group('return types', () {
      test('methods return Future<Response<T>>', () {
        expect(dioClient.get('/test'), isA<Future<Response>>());
        expect(dioClient.post('/test'), isA<Future<Response>>());
        expect(dioClient.put('/test'), isA<Future<Response>>());
        expect(dioClient.delete('/test'), isA<Future<Response>>());
        expect(dioClient.uploadFile('/upload', FormData()), 
            isA<Future<Response>>());
      });
    });

    group('multiple instances', () {
      test('can create multiple DioClient instances', () {
        final client1 = DioClient();
        final client2 = DioClient();
        
        expect(client1, isNotNull);
        expect(client2, isNotNull);
        expect(client1, isNot(same(client2)));
        expect(client1.dio, isNot(same(client2.dio)));
      });
    });

    group('configuration', () {
      test('dio instance has interceptors', () {
        final dio = dioClient.dio;
        expect(dio.interceptors, isNotEmpty);
      });

      test('dio instance has proper timeout configuration', () {
        final dio = dioClient.dio;
        expect(dio.options.connectTimeout, isNotNull);
        expect(dio.options.receiveTimeout, isNotNull);
        expect(dio.options.sendTimeout, isNotNull);
      });

      test('dio instance has base URL configured', () {
        final dio = dioClient.dio;
        expect(dio.options.baseUrl, isNotNull);
        expect(dio.options.baseUrl, isNotEmpty);
      });
    });

    group('error handling', () {
      test('methods handle exceptions gracefully', () {
        // These should not throw immediately - only when executed
        expect(() => dioClient.get(''), returnsNormally);
        expect(() => dioClient.post(''), returnsNormally);
        expect(() => dioClient.put(''), returnsNormally);
        expect(() => dioClient.delete(''), returnsNormally);
      });
    });

    group('FormData usage', () {
      test('can create empty FormData', () {
        final formData = FormData();
        expect(formData, isNotNull);
        expect(formData, isA<FormData>());
      });

      test('can create FormData from map', () {
        final formData = FormData.fromMap({
          'key1': 'value1',
          'key2': 'value2',
        });
        
        expect(formData, isNotNull);
        expect(formData, isA<FormData>());
      });

      test('can create FormData with files', () {
        final formData = FormData.fromMap({
          'text_field': 'text_value',
          'file_field': MultipartFile.fromString(
            'file content',
            filename: 'test.txt',
          ),
        });
        
        expect(formData, isNotNull);
        expect(formData, isA<FormData>());
      });
    });

    group('edge cases', () {
      test('handles null data gracefully', () {
        expect(() => dioClient.post('/test', data: null), returnsNormally);
        expect(() => dioClient.put('/test', data: null), returnsNormally);
        expect(() => dioClient.delete('/test', data: null), returnsNormally);
      });

      test('handles empty paths', () {
        expect(() => dioClient.get(''), returnsNormally);
        expect(() => dioClient.post(''), returnsNormally);
        expect(() => dioClient.put(''), returnsNormally);
        expect(() => dioClient.delete(''), returnsNormally);
      });

      test('handles complex data structures', () {
        final complexData = {
          'nested': {
            'list': [1, 2, 3],
            'map': {'key': 'value'},
          },
          'array': ['item1', 'item2'],
        };
        
        expect(() => dioClient.post('/test', data: complexData), returnsNormally);
      });
    });
  });
}