import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_forge/features/dashboard/presentation/counter/counter_cubit.dart';
import 'package:starter_forge/features/dashboard/presentation/screens/home_screen.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_state.dart';

class MockCounterCubit extends Mock implements CounterCubit {
  @override
  Stream<int> get stream => Stream.value(state);

  @override
  bool get isClosed => false;
}

class MockProfileBloc extends Mock implements ProfileBloc {
  @override
  Stream<ProfileState> get stream => Stream.value(state);

  @override
  bool get isClosed => false;
}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockCounterCubit mockCounterCubit;
  late MockProfileBloc mockProfileBloc;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockCounterCubit = MockCounterCubit();
    mockProfileBloc = MockProfileBloc();
    mockGoRouter = MockGoRouter();

    when(() => mockCounterCubit.state).thenReturn(0);
    when(
      () => mockProfileBloc.state,
    ).thenReturn(const ProfileState(name: 'Test User'));
    when(() => mockCounterCubit.state).thenReturn(0);
    when(
      () => mockProfileBloc.state,
    ).thenReturn(const ProfileState(name: 'Test User'));
    when(
      () => mockGoRouter.goNamed(any(), extra: any(named: 'extra')),
    ).thenAnswer((_) {});
    when(() => mockGoRouter.goNamed(any())).thenAnswer((_) {});
    when(() => mockGoRouter.go(any())).thenAnswer((_) {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CounterCubit>.value(value: mockCounterCubit),
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: InheritedGoRouter(
          goRouter: mockGoRouter,
          child: const HomeScreen(),
        ),
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Hello, Test User!'), findsOneWidget);
      expect(find.text('Welcome back to your dashboard.'), findsOneWidget);
      expect(find.text('Counter Value'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Analytics Overview'), findsOneWidget);
    });

    testWidgets('increment button increases counter', (
      WidgetTester tester,
    ) async {
      when(() => mockCounterCubit.increment()).thenAnswer((_) async {});
      when(() => mockCounterCubit.state).thenReturn(1);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Increase'));
      await tester.pumpAndSettle();

      verify(() => mockCounterCubit.increment()).called(1);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('decrement button decreases counter', (
      WidgetTester tester,
    ) async {
      when(() => mockCounterCubit.decrement()).thenAnswer((_) async {});
      when(() => mockCounterCubit.state).thenReturn(-1);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Decrease'));
      await tester.pumpAndSettle();

      verify(() => mockCounterCubit.decrement()).called(1);
      expect(find.text('-1'), findsOneWidget);
    });

    testWidgets('profile button navigates to profile screen', (
      WidgetTester tester,
    ) async {
      when(() => mockGoRouter.goNamed('profile')).thenAnswer((_) {});
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      verify(() => mockGoRouter.goNamed('profile')).called(1);
    });

    testWidgets('action items are tappable', (WidgetTester tester) async {
      when(() => mockGoRouter.go('/details/123')).thenAnswer((_) {});
      when(() => mockGoRouter.go('/details/456')).thenAnswer((_) {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('View Report #123'));
      await tester.pumpAndSettle();
      verify(() => mockGoRouter.go('/details/123')).called(1);

      await tester.tap(find.text('Manage Document #456'));
      await tester.pumpAndSettle();
      verify(() => mockGoRouter.go('/details/456')).called(1);
    });
  });
}
