import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfileData>(_onLoadProfileData);
  }

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      // Simulate fetching data
      await Future.delayed(const Duration(milliseconds: 700));

      // Replace with actual data fetching (e.g., from a repository)
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          name: 'Rahul Singh',
          email: 'singhrahul.cs@gmail.com',
          bio:
              'Flutter enthusiast & coffee lover. Building amazing apps one widget at a time. Passionate about clean code and great user experiences.',
          // Use a placeholder image URL or local asset
          profileImageUrl:
              'https://media.licdn.com/dms/image/v2/D5603AQEt0ybToZGGuw/profile-displayphoto-shrink_400_400/B56Zbt8qBkG4Ak-/0/1747748823820?e=1754524800&v=beta&t=nXoQedxVXJF8mmYpcfumSS0fV95_3JetvFYdt2R2KEc',
          // Example for local asset:
          // profileImageUrl: 'assets/images/default_profile.png', // Make sure to add to pubspec.yaml and create asset
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'Failed to load profile.',
        ),
      );
    }
  }
}
