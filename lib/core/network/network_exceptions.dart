import 'package:dio/dio.dart';
import 'package:starter_forge/core/error/result.dart';

/// Network exceptions specific to Dio
extension NetworkExceptionMapper on DioException {
  AppException toAppException() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException.network(
          message: 'Connection timeout. Please check your internet connection.',
          code: 'TIMEOUT',
        );

      case DioExceptionType.badResponse:
        final statusCode = response?.statusCode ?? 0;
        switch (statusCode) {
          case 401:
            return const AppException.unauthorized();
          case 404:
            return const AppException.notFound();
          case 500:
          case 502:
          case 503:
            return const AppException.serverError(
              message: 'Server error occurred. Please try again later.',
            );
          default:
            return AppException.network(
              message: response?.statusMessage ?? 'Network error occurred',
              statusCode: statusCode,
            );
        }

      case DioExceptionType.cancel:
        return const AppException.network(
          message: 'Request was cancelled',
          code: 'CANCELLED',
        );

      case DioExceptionType.connectionError:
        return const AppException.network(
          message: 'Connection error. Please check your internet connection.',
          code: 'CONNECTION_ERROR',
        );

      case DioExceptionType.badCertificate:
        return const AppException.network(
          message: 'Invalid certificate',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
        return AppException.unknown(
          message: message ?? 'An unexpected error occurred',
        );
    }
  }
}