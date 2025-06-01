import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileData extends ProfileEvent {}

// Add more events if you plan to edit data:
// class UpdateProfileName extends ProfileEvent {
//   final String name;
//   const UpdateProfileName(this.name);
//   @override List<Object> get props => [name];
// }
