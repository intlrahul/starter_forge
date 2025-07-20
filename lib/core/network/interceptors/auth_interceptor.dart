import 'package:dio/dio.dart';
import 'package:starter_forge/core/storage/secure_storage.dart';

/// Interceptor for adding authentication headers to requests
class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage = SecureStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get the access token from secure storage
    final accessToken = await _secureStorage.getAccessToken();
    
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle token refresh on 401 errors
    if (err.response?.statusCode == 401) {
      _handleUnauthorized(err, handler);
    } else {
      super.onError(err, handler);
    }
  }

  Future<void> _handleUnauthorized(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      // Try to refresh the token
      final refreshToken = await _secureStorage.getRefreshToken();
      
      if (refreshToken != null) {
        // Attempt token refresh (implement your refresh logic here)
        // final newToken = await _refreshToken(refreshToken);
        // await _secureStorage.setAccessToken(newToken);
        
        // Retry the original request with new token
        // For now, just continue with the error
      }
      
      // If refresh fails or no refresh token, continue with the error
      super.onError(err, handler);
    } catch (e) {
      // Token refresh failed, continue with original error
      super.onError(err, handler);
    }
  }
}