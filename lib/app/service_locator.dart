import 'package:get_it/get_it.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_bloc.dart';
import 'package:starter_forge/features/dashboard/presentation/counter/counter_cubit.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_bloc.dart';

final GetIt sl = GetIt.instance; // sl as in Service Locator

void setupServiceLocator() {
  sl.registerFactory<CounterCubit>(CounterCubit.new);
  sl.registerFactory<UserDetailsBloc>(UserDetailsBloc.new);
  sl.registerSingleton<ProfileBloc>(ProfileBloc());
  sl.registerLazySingleton<ThemeBloc>(ThemeBloc.new);
}
