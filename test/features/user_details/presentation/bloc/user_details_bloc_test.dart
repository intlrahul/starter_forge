import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_bloc.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_event.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_state.dart';

void main() {
  group('UserDetailsBloc', () {
    late UserDetailsBloc userDetailsBloc;

    setUp(() {
      userDetailsBloc = UserDetailsBloc();
    });

    tearDown(() {
      userDetailsBloc.close();
    });

    test('initial state is correct', () {
      expect(
        userDetailsBloc.state,
        const UserDetailsState(
          userId: '',
          name: '',
          email: '',
          isSubmitting: false,
          isSuccess: false,
        ),
      );
    });

    blocTest<UserDetailsBloc, UserDetailsState>(
      'emits state with updated userId when LoadUserDetails is added',
      build: () => userDetailsBloc,
      act: (bloc) => bloc.add(const LoadUserDetails('123')),
      expect: () => [
        const UserDetailsState(
          userId: '123',
          name: '',
          email: '',
          isSubmitting: false,
          isSuccess: false,
        ),
      ],
    );

    blocTest<UserDetailsBloc, UserDetailsState>(
      'emits state with updated name when UserNameChanged is added',
      build: () => userDetailsBloc,
      act: (bloc) => bloc.add(const UserNameChanged('John Doe')),
      expect: () => [
        const UserDetailsState(
          userId: '',
          name: 'John Doe',
          email: '',
          isSubmitting: false,
          isSuccess: false,
        ),
      ],
    );

    blocTest<UserDetailsBloc, UserDetailsState>(
      'emits state with updated email when UserEmailChanged is added',
      build: () => userDetailsBloc,
      act: (bloc) => bloc.add(const UserEmailChanged('john@example.com')),
      expect: () => [
        const UserDetailsState(
          userId: '',
          name: '',
          email: 'john@example.com',
          isSubmitting: false,
          isSuccess: false,
        ),
      ],
    );

    blocTest<UserDetailsBloc, UserDetailsState>(
      'emits error state when submitting with empty fields',
      build: () => userDetailsBloc,
      act: (bloc) => bloc.add(const UserDetailsSubmitted()),
      expect: () => [
        const UserDetailsState(
          userId: '',
          name: '',
          email: '',
          isSubmitting: true,
          isSuccess: false,
        ),
        const UserDetailsState(
          userId: '',
          name: '',
          email: '',
          isSubmitting: false,
          isSuccess: false,
          errorMessage: 'Name and Email cannot be empty.',
        ),
      ],
      wait: const Duration(seconds: 1),
    );

    blocTest<UserDetailsBloc, UserDetailsState>(
      'emits error state when submitting with invalid email',
      build: () => userDetailsBloc,
      act: (bloc) {
        bloc.add(const UserNameChanged('John Doe'));
        bloc.add(const UserEmailChanged('invalid-email'));
        bloc.add(const UserDetailsSubmitted());
      },
      expect: () => [
        const UserDetailsState(
          userId: '',
          name: 'John Doe',
          email: '',
          isSubmitting: false,
          isSuccess: false,
        ),
        const UserDetailsState(
          userId: '',
          name: 'John Doe',
          email: 'invalid-email',
          isSubmitting: false,
          isSuccess: false,
        ),
        const UserDetailsState(
          userId: '',
          name: 'John Doe',
          email: 'invalid-email',
          isSubmitting: true,
          isSuccess: false,
        ),
        const UserDetailsState(
          userId: '',
          name: 'John Doe',
          email: 'invalid-email',
          isSubmitting: false,
          isSuccess: false,
          errorMessage: 'Invalid email format.',
        ),
      ],
      wait: const Duration(seconds: 1),
    );

    blocTest<UserDetailsBloc, UserDetailsState>(
      'emits success state when submitting valid data',
      build: () => userDetailsBloc,
      act: (bloc) {
        bloc.add(const UserNameChanged('John Doe'));
        bloc.add(const UserEmailChanged('john@example.com'));
        bloc.add(const UserDetailsSubmitted());
      },
      expect: () => [
        const UserDetailsState(
          userId: '',
          name: 'John Doe',
          email: '',
          isSubmitting: false,
          isSuccess: false,
        ),
        const UserDetailsState(
          userId: '',
          name: 'John Doe',
          email: 'john@example.com',
          isSubmitting: false,
          isSuccess: false,
        ),
        const UserDetailsState(
          userId: '',
          name: 'John Doe',
          email: 'john@example.com',
          isSubmitting: true,
          isSuccess: false,
        ),
        const UserDetailsState(
          userId: '',
          name: 'John Doe',
          email: 'john@example.com',
          isSubmitting: false,
          isSuccess: true,
        ),
      ],
      wait: const Duration(seconds: 1),
    );

    test('state copyWith works correctly', () {
      const initialState = UserDetailsState();
      
      final newState = initialState.copyWith(
        userId: '123',
        name: 'John Doe',
        email: 'john@example.com',
        isSubmitting: true,
        isSuccess: true,
      );

      expect(newState.userId, equals('123'));
      expect(newState.name, equals('John Doe'));
      expect(newState.email, equals('john@example.com'));
      expect(newState.isSubmitting, isTrue);
      expect(newState.isSuccess, isTrue);
      expect(newState.errorMessage, isNull);
    });

    test('state copyWith clears error message when clearErrorMessage is true', () {
      const initialState = UserDetailsState(errorMessage: 'Error');
      
      final newState = initialState.copyWith(
        clearErrorMessage: true,
      );

      expect(newState.errorMessage, isNull);
    });

    test('state props contains all fields', () {
      const state = UserDetailsState(
        userId: '123',
        name: 'John Doe',
        email: 'john@example.com',
        isSubmitting: true,
        isSuccess: true,
        errorMessage: 'Error',
      );

      expect(
        state.props,
        equals([
          '123',
          'John Doe',
          'john@example.com',
          true,
          true,
          'Error',
        ]),
      );
    });
  });
} 