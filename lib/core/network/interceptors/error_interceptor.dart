import 'package:dio/dio.dart';
import 'package:starter_forge/core/logging/app_logger.dart';
import 'package:starter_forge/core/network/network_exceptions.dart';

/// Interceptor for standardizing error handling across the app
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert DioException to AppException
    final appException = err.toAppException();
    
    // Log the error
    AppLogger.error(
      'Network error intercepted: ${appException.toString()}',
      err,
    );

    // Continue with the DioException (it will be caught and converted
    // in the repository layer)
    super.onError(err, handler);
  }
}