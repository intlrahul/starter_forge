import 'package:equatable/equatable.dart';

abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();

  @override
  List<Object> get props => [];
}

class UserNameChanged extends UserDetailsEvent {
  const UserNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class UserEmailChanged extends UserDetailsEvent {
  const UserEmailChanged(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}

class UserDetailsSubmitted extends UserDetailsEvent {
  const UserDetailsSubmitted();
}

class LoadUserDetails extends UserDetailsEvent {
  // Or some identifier for the details number
  const LoadUserDetails(this.userId);
  final String userId;

  @override
  List<Object> get props => [userId];
}
