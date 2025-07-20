import 'package:dio/dio.dart';
import 'package:starter_forge/core/logging/app_logger.dart';

/// Interceptor for logging HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.network(
      options.method,
      options.uri.toString(),
      headers: options.headers,
      data: options.data,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.network(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      statusCode: response.statusCode,
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'Network Error: ${err.requestOptions.method} ${err.requestOptions.uri}',
      err,
    );
    super.onError(err, handler);
  }
}