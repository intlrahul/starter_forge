import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_forge/core/config/app_config.dart';
import 'package:starter_forge/core/logging/app_logger.dart';
import 'package:starter_forge/core/network/interceptors/auth_interceptor.dart';
import 'package:starter_forge/core/network/interceptors/error_interceptor.dart';
import 'package:starter_forge/core/network/interceptors/logging_interceptor.dart';

/// HTTP client for the application
@lazySingleton
class DioClient {
  DioClient() {
    _dio = _createDio();
  }

  late final Dio _dio;

  /// Get the configured Dio instance
  Dio get dio => _dio;

  /// Create and configure the Dio instance
  Dio _createDio() {
    final dio = Dio();

    // Base configuration
    dio.options = BaseOptions(
      baseUrl: AppConfig.fullApiUrl,
      connectTimeout: Duration(seconds: AppConfig.apiTimeout),
      receiveTimeout: Duration(seconds: AppConfig.apiTimeout),
      sendTimeout: Duration(seconds: AppConfig.apiTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    dio.interceptors.addAll([
      if (AppConfig.enableLogging) LoggingInterceptor(),
      ErrorInterceptor(),
      AuthInterceptor(),
    ]);

    return dio;
  }

  /// Generic GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      AppLogger.error('GET request failed', e);
      rethrow;
    }
  }

  /// Generic POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      AppLogger.error('POST request failed', e);
      rethrow;
    }
  }

  /// Generic PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      AppLogger.error('PUT request failed', e);
      rethrow;
    }
  }

  /// Generic DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      AppLogger.error('DELETE request failed', e);
      rethrow;
    }
  }

  /// Upload file(s)
  Future<Response<T>> uploadFile<T>(
    String path,
    FormData formData, {
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      AppLogger.error('File upload failed', e);
      rethrow;
    }
  }
}