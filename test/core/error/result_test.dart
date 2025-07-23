import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/core/error/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('creates success result with data', () {
        const data = 'test data';
        const result = Result.success(data);

        expect(result, isA<Success<String>>());
        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.dataOrNull, equals(data));
        expect(result.exceptionOrNull, isNull);
      });

      test('works with different data types', () {
        const intResult = Result.success(42);
        const listResult = Result.success([1, 2, 3]);
        const mapResult = Result.success({'key': 'value'});

        expect(intResult.dataOrNull, equals(42));
        expect(listResult.dataOrNull, equals([1, 2, 3]));
        expect(mapResult.dataOrNull, equals({'key': 'value'}));
      });

      test('when method returns data for success', () {
        const result = Result.success('test');
        
        final output = result.when(
          success: (data) => 'Success: $data',
          failure: (exception) => 'Failure: ${exception.toString()}',
        );

        expect(output, equals('Success: test'));
      });
    });

    group('Failure', () {
      test('creates failure result with exception', () {
        const exception = AppException.network(message: 'Network error');
        const result = Result.failure(exception);

        expect(result, isA<Failure>());
        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
        expect(result.dataOrNull, isNull);
        expect(result.exceptionOrNull, equals(exception));
      });

      test('when method returns exception info for failure', () {
        const exception = AppException.validation(message: 'Validation error');
        const result = Result.failure(exception);
        
        final output = result.when(
          success: (data) => 'Success: $data',
          failure: (exception) => 'Failure: ${exception.message}',
        );

        expect(output, equals('Failure: Validation error'));
      });
    });

    group('convenience methods', () {
      test('dataOrNull returns data for success', () {
        const result = Result.success('data');
        expect(result.dataOrNull, equals('data'));
      });

      test('dataOrNull returns null for failure', () {
        const result = Result.failure(AppException.network(message: 'error'));
        expect(result.dataOrNull, isNull);
      });

      test('exceptionOrNull returns null for success', () {
        const result = Result.success('data');
        expect(result.exceptionOrNull, isNull);
      });

      test('exceptionOrNull returns exception for failure', () {
        const exception = AppException.cache(message: 'cache error');
        const result = Result.failure(exception);
        expect(result.exceptionOrNull, equals(exception));
      });
    });
  });

  group('AppException', () {
    group('NetworkException', () {
      test('creates network exception with required message', () {
        const exception = AppException.network(message: 'Network error');

        expect(exception, isA<NetworkException>());
        expect(exception.message, equals('Network error'));
        
        exception.when(
          network: (message, code, statusCode) {
            expect(code, isNull);
            expect(statusCode, equals(0));
          },
          cache: (_) => fail('Should be network exception'),
          validation: (_, __) => fail('Should be network exception'),
          unauthorized: (_) => fail('Should be network exception'),
          notFound: (_) => fail('Should be network exception'),
          serverError: (_, __) => fail('Should be network exception'),
          unknown: (_) => fail('Should be network exception'),
        );
      });

      test('creates network exception with all parameters', () {
        const exception = AppException.network(
          message: 'Server error',
          code: 'SERVER_ERROR',
          statusCode: 500,
        );

        expect(exception.message, equals('Server error'));
        
        exception.when(
          network: (message, code, statusCode) {
            expect(code, equals('SERVER_ERROR'));
            expect(statusCode, equals(500));
          },
          cache: (_) => fail('Should be network exception'),
          validation: (_, __) => fail('Should be network exception'),
          unauthorized: (_) => fail('Should be network exception'),
          notFound: (_) => fail('Should be network exception'),
          serverError: (_, __) => fail('Should be network exception'),
          unknown: (_) => fail('Should be network exception'),
        );
      });
    });

    group('CacheException', () {
      test('creates cache exception with message', () {
        const exception = AppException.cache(message: 'Cache error');

        expect(exception, isA<CacheException>());
        expect(exception.message, equals('Cache error'));
      });
    });

    group('ValidationException', () {
      test('creates validation exception with message only', () {
        const exception = AppException.validation(message: 'Validation failed');

        expect(exception, isA<ValidationException>());
        expect(exception.message, equals('Validation failed'));
        
        exception.when(
          network: (_, __, ___) => fail('Should be validation exception'),
          cache: (_) => fail('Should be validation exception'),
          validation: (message, errors) {
            expect(errors, isNull);
          },
          unauthorized: (_) => fail('Should be validation exception'),
          notFound: (_) => fail('Should be validation exception'),
          serverError: (_, __) => fail('Should be validation exception'),
          unknown: (_) => fail('Should be validation exception'),
        );
      });

      test('creates validation exception with errors map', () {
        const errors = {
          'email': 'Invalid email format',
          'password': 'Password too short',
        };
        const exception = AppException.validation(
          message: 'Validation failed',
          errors: errors,
        );

        expect(exception.message, equals('Validation failed'));
        
        exception.when(
          network: (_, __, ___) => fail('Should be validation exception'),
          cache: (_) => fail('Should be validation exception'),
          validation: (message, validationErrors) {
            expect(validationErrors, equals(errors));
          },
          unauthorized: (_) => fail('Should be validation exception'),
          notFound: (_) => fail('Should be validation exception'),
          serverError: (_, __) => fail('Should be validation exception'),
          unknown: (_) => fail('Should be validation exception'),
        );
      });
    });

    group('UnauthorizedException', () {
      test('creates unauthorized exception with default message', () {
        const exception = AppException.unauthorized();

        expect(exception, isA<UnauthorizedException>());
        expect(exception.message, equals('Unauthorized access'));
      });

      test('creates unauthorized exception with custom message', () {
        const exception = AppException.unauthorized(message: 'Token expired');

        expect(exception.message, equals('Token expired'));
      });
    });

    group('NotFoundException', () {
      test('creates not found exception with default message', () {
        const exception = AppException.notFound();

        expect(exception, isA<NotFoundException>());
        expect(exception.message, equals('Resource not found'));
      });

      test('creates not found exception with custom message', () {
        const exception = AppException.notFound(message: 'User not found');

        expect(exception.message, equals('User not found'));
      });
    });

    group('ServerException', () {
      test('creates server exception with default message', () {
        const exception = AppException.serverError();

        expect(exception, isA<ServerException>());
        expect(exception.message, equals('Internal server error'));
        
        exception.when(
          network: (_, __, ___) => fail('Should be server exception'),
          cache: (_) => fail('Should be server exception'),
          validation: (_, __) => fail('Should be server exception'),
          unauthorized: (_) => fail('Should be server exception'),
          notFound: (_) => fail('Should be server exception'),
          serverError: (message, code) {
            expect(code, isNull);
          },
          unknown: (_) => fail('Should be server exception'),
        );
      });

      test('creates server exception with custom message and code', () {
        const exception = AppException.serverError(
          message: 'Database connection failed',
          code: 'DB_ERROR',
        );

        expect(exception.message, equals('Database connection failed'));
        
        exception.when(
          network: (_, __, ___) => fail('Should be server exception'),
          cache: (_) => fail('Should be server exception'),
          validation: (_, __) => fail('Should be server exception'),
          unauthorized: (_) => fail('Should be server exception'),
          notFound: (_) => fail('Should be server exception'),
          serverError: (message, code) {
            expect(code, equals('DB_ERROR'));
          },
          unknown: (_) => fail('Should be server exception'),
        );
      });
    });

    group('UnknownException', () {
      test('creates unknown exception with default message', () {
        const exception = AppException.unknown();

        expect(exception, isA<UnknownException>());
        expect(exception.message, equals('An unknown error occurred'));
      });

      test('creates unknown exception with custom message', () {
        const exception = AppException.unknown(message: 'Unexpected error');

        expect(exception.message, equals('Unexpected error'));
      });
    });

    group('equality and toString', () {
      test('same exceptions are equal', () {
        const exception1 = AppException.network(message: 'Network error');
        const exception2 = AppException.network(message: 'Network error');

        expect(exception1, equals(exception2));
      });

      test('different exceptions are not equal', () {
        const exception1 = AppException.network(message: 'Network error');
        const exception2 = AppException.cache(message: 'Cache error');

        expect(exception1, isNot(equals(exception2)));
      });

      test('exceptions with different parameters are not equal', () {
        const exception1 = AppException.network(
          message: 'Network error',
          statusCode: 500,
        );
        const exception2 = AppException.network(
          message: 'Network error',
          statusCode: 404,
        );

        expect(exception1, isNot(equals(exception2)));
      });
    });
  });

  group('Result with different exception types', () {
    test('failure with network exception', () {
      const exception = AppException.network(message: 'Connection failed');
      const result = Result<String>.failure(exception);

      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull, isA<NetworkException>());
    });

    test('failure with validation exception', () {
      const exception = AppException.validation(
        message: 'Invalid input',
        errors: {'field': 'error'},
      );
      const result = Result<int>.failure(exception);

      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull, isA<ValidationException>());
    });

    test('failure with unauthorized exception', () {
      const exception = AppException.unauthorized();
      const result = Result<bool>.failure(exception);

      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull, isA<UnauthorizedException>());
    });
  });
}
