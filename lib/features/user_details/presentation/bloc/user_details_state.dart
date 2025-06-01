import 'package:equatable/equatable.dart';

class UserDetailsState extends Equatable {
  // To show any submission errors

  const UserDetailsState({
    this.userId = '',
    this.name = '',
    this.email = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final String userId; // To store the details number/ID
  final String name;
  final String email;
  final bool isSubmitting;
  final bool isSuccess; // To indicate successful submission
  final String? errorMessage;

  UserDetailsState copyWith({
    String? userId,
    String? name,
    String? email,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool clearErrorMessage = false, // Helper to explicitly clear error
  }) {
    return UserDetailsState(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    name,
    email,
    isSubmitting,
    isSuccess,
    errorMessage,
  ];
}
