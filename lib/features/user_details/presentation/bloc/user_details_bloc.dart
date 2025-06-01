import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_event.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  UserDetailsBloc() : super(const UserDetailsState()) {
    on<LoadUserDetails>((event, emit) {
      emit(
        state.copyWith(
          userId: event.userId,
          isSuccess: false,
          clearErrorMessage: true,
        ),
      );
    });

    on<UserNameChanged>((event, emit) {
      emit(
        state.copyWith(
          name: event.name,
          isSuccess: false,
          clearErrorMessage: true,
        ),
      );
    });

    on<UserEmailChanged>((event, emit) {
      emit(
        state.copyWith(
          email: event.email,
          isSuccess: false,
          clearErrorMessage: true,
        ),
      );
    });

    on<UserDetailsSubmitted>((event, emit) async {
      emit(
        state.copyWith(
          isSubmitting: true,
          isSuccess: false,
          clearErrorMessage: true,
        ),
      );

      // Simulate network request or data saving
      await Future.delayed(const Duration(seconds: 1));

      // Basic validation (you'd have more robust validation)
      if (state.name.isEmpty || state.email.isEmpty) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: 'Name and Email cannot be empty.',
          ),
        );
        return;
      }
      if (!state.email.contains('@')) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: 'Invalid email format.',
          ),
        );
        return;
      }

      // Success
      print(
        'User Details Submitted: Name: ${state.name}, Email: ${state.email}, For ID: ${state.userId}',
      );
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    });
  }
}
