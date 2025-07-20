import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// A generic Result type for handling success and failure states
@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(AppException exception) = Failure<T>;

  // Private constructor required by freezed for getters
  const Result._();

  /// Convenience method to check if the result is successful
  bool get isSuccess => this is Success<T>;

  /// Convenience method to check if the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Get the data if successful, otherwise return null
  T? get dataOrNull => when(
        success: (data) => data,
        failure: (_) => null,
      );

  /// Get the exception if failure, otherwise return null
  AppException? get exceptionOrNull => when(
        success: (_) => null,
        failure: (exception) => exception,
      );
}

/// Base exception class for the application
@freezed
class AppException with _$AppException implements Exception {
  const factory AppException.network({
    required String message,
    String? code,
    @Default(0) int statusCode,
  }) = NetworkException;

  const factory AppException.cache({
    required String message,
  }) = CacheException;

  const factory AppException.validation({
    required String message,
    Map<String, String>? errors,
  }) = ValidationException;

  const factory AppException.unauthorized({
    @Default('Unauthorized access') String message,
  }) = UnauthorizedException;

  const factory AppException.notFound({
    @Default('Resource not found') String message,
  }) = NotFoundException;

  const factory AppException.serverError({
    @Default('Internal server error') String message,
    String? code,
  }) = ServerException;

  const factory AppException.unknown({
    @Default('An unknown error occurred') String message,
  }) = UnknownException;
}