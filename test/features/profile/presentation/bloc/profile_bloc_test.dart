import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_event.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_state.dart';

void main() {
  group('ProfileBloc', () {
    late ProfileBloc profileBloc;

    setUp(() {
      profileBloc = ProfileBloc();
    });

    tearDown(() {
      profileBloc.close();
    });

    test('initial state is correct', () {
      expect(
        profileBloc.state,
        const ProfileState(
          status: ProfileStatus.initial,
          name: '',
          email: '',
          bio: '',
          profileImageUrl: '',
        ),
      );
    });

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, success] when LoadProfileData is added',
      build: () => profileBloc,
      act: (bloc) => bloc.add(LoadProfileData()),
      expect: () => [
        const ProfileState(
          status: ProfileStatus.loading,
          name: '',
          email: '',
          bio: '',
          profileImageUrl: '',
        ),
        ProfileState(
          status: ProfileStatus.success,
          name: 'Rahul Singh',
          email: 'singhrahul.cs@gmail.com',
          bio: 'Flutter enthusiast & coffee lover. Building amazing apps one widget at a time. Passionate about clean code and great user experiences.',
          profileImageUrl: 'https://media.licdn.com/dms/image/v2/D5603AQEt0ybToZGGuw/profile-displayphoto-shrink_400_400/B56Zbt8qBkG4Ak-/0/1747748823820?e=1754524800&v=beta&t=nXoQedxVXJF8mmYpcfumSS0fV95_3JetvFYdt2R2KEc',
        ),
      ],
      wait: const Duration(milliseconds: 800), // Wait for the simulated delay
    );

    test('state copyWith works correctly', () {
      const initialState = ProfileState();
      
      final newState = initialState.copyWith(
        status: ProfileStatus.success,
        name: 'Test User',
        email: 'test@example.com',
        bio: 'Test bio',
        profileImageUrl: 'test_url',
      );

      expect(newState.status, equals(ProfileStatus.success));
      expect(newState.name, equals('Test User'));
      expect(newState.email, equals('test@example.com'));
      expect(newState.bio, equals('Test bio'));
      expect(newState.profileImageUrl, equals('test_url'));
      expect(newState.errorMessage, isNull);
    });

    test('state copyWith clears error message when clearErrorMessage is true', () {
      const initialState = ProfileState(errorMessage: 'Error');
      
      final newState = initialState.copyWith(
        clearErrorMessage: true,
      );

      expect(newState.errorMessage, isNull);
    });

    test('state props contains all fields', () {
      const state = ProfileState(
        status: ProfileStatus.success,
        name: 'Test User',
        email: 'test@example.com',
        bio: 'Test bio',
        profileImageUrl: 'test_url',
        errorMessage: 'Error',
      );

      expect(
        state.props,
        equals([
          ProfileStatus.success,
          'Test User',
          'test@example.com',
          'Test bio',
          'test_url',
          'Error',
        ]),
      );
    });
  });
} 