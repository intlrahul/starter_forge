import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.name = '',
    this.email = '',
    this.bio = '',
    this.profileImageUrl = '', // Default empty or placeholder
    this.errorMessage,
  });

  final ProfileStatus status;
  final String name;
  final String email;
  final String bio;
  final String profileImageUrl; // URL or local asset path
  final String? errorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    String? name,
    String? email,
    String? bio,
    String? profileImageUrl,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    email,
    bio,
    profileImageUrl,
    errorMessage,
  ];
}
