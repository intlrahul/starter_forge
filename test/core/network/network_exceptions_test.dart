import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/core/error/result.dart';
import 'package:starter_forge/core/network/network_exceptions.dart';

void main() {
  group('NetworkExceptionMapper', () {
    group('toAppException', () {
      group('timeout exceptions', () {
        test('maps connection timeout to network exception', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionTimeout,
          );

          final result = dioException.toAppException();

          expect(result, isA<NetworkException>());
          final networkException = result as NetworkException;
          expect(networkException.message, contains('Connection timeout'));
          expect(networkException.code, equals('TIMEOUT'));
        });

        test('maps send timeout to network exception', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.sendTimeout,
          );

          final result = dioException.toAppException();

          expect(result, isA<NetworkException>());
          final networkException = result as NetworkException;
          expect(networkException.message, contains('Connection timeout'));
          expect(networkException.code, equals('TIMEOUT'));
        });

        test('maps receive timeout to network exception', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.receiveTimeout,
          );

          final result = dioException.toAppException();

          expect(result, isA<NetworkException>());
          final networkException = result as NetworkException;
          expect(networkException.message, contains('Connection timeout'));
          expect(networkException.code, equals('TIMEOUT'));
        });
      });

      group('bad response exceptions', () {
        test('maps 401 status to unauthorized exception', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 401,
            ),
          );

          final result = dioException.toAppException();

          expect(result, isA<UnauthorizedException>());
          final unauthorized = result as UnauthorizedException;
          expect(unauthorized.message, equals('Unauthorized access'));
        });

        test('maps 404 status to not found exception', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 404,
            ),
          );

          final result = dioException.toAppException();

          expect(result, isA<NotFoundException>());
          final notFound = result as NotFoundException;
          expect(notFound.message, equals('Resource not found'));
        });

        test('maps 500 status to server error exception', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 500,
            ),
          );

          final result = dioException.toAppException();

          expect(result, isA<ServerException>());
          final serverError = result as ServerException;
          expect(serverError.message, contains('Server error occurred'));
        });

        test('maps 502 status to server error exception', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 502,
            ),
          );

          final result = dioException.toAppException();

          expect(result, isA<ServerException>());
        });

        test('maps 503 status to server error exception', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 503,
            ),
          );

          final result = dioException.toAppException();

          expect(result, isA<ServerException>());
        });

        test('maps other status codes to network exception with status code', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 422,
              statusMessage: 'Unprocessable Entity',
            ),
          );

          final result = dioException.toAppException();

          expect(result, isA<NetworkException>());
          final networkException = result as NetworkException;
          expect(networkException.message, equals('Unprocessable Entity'));
          expect(networkException.statusCode, equals(422));
        });

        test('handles null response status message', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 400,
              statusMessage: null,
            ),
          );

          final result = dioException.toAppException();

          expect(result, isA<NetworkException>());
          final networkException = result as NetworkException;
          expect(networkException.message, equals('Network error occurred'));
          expect(networkException.statusCode, equals(400));
        });

        test('handles null response', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: null,
          );

          final result = dioException.toAppException();

          expect(result, isA<NetworkException>());
          final networkException = result as NetworkException;
          expect(networkException.statusCode, equals(0));
        });
      });

      group('other dio exception types', () {
        test('maps cancel exception to network exception', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.cancel,
          );

          final result = dioException.toAppException();

          expect(result, isA<NetworkException>());
          final networkException = result as NetworkException;
          expect(networkException.message, equals('Request was cancelled'));
          expect(networkException.code, equals('CANCELLED'));
        });

        test('maps connection error to network exception', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionError,
          );

          final result = dioException.toAppException();

          expect(result, isA<NetworkException>());
          final networkException = result as NetworkException;
          expect(networkException.message, contains('Connection error'));
          expect(networkException.code, equals('CONNECTION_ERROR'));
        });

        test('maps bad certificate to network exception', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badCertificate,
          );

          final result = dioException.toAppException();

          expect(result, isA<NetworkException>());
          final networkException = result as NetworkException;
          expect(networkException.message, equals('Invalid certificate'));
          expect(networkException.code, equals('BAD_CERTIFICATE'));
        });

        test('maps unknown exception with message', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.unknown,
            message: 'Custom error message',
          );

          final result = dioException.toAppException();

          expect(result, isA<UnknownException>());
          final unknownException = result as UnknownException;
          expect(unknownException.message, equals('Custom error message'));
        });

        test('maps unknown exception without message', () {
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.unknown,
          );

          final result = dioException.toAppException();

          expect(result, isA<UnknownException>());
          final unknownException = result as UnknownException;
          expect(unknownException.message, equals('An unexpected error occurred'));
        });
      });
    });
  });
}