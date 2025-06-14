import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_bloc.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_event.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_state.dart';
import 'package:starter_forge/features/user_details/presentation/screens/user_details_screen.dart';

class MockUserDetailsBloc extends Mock implements UserDetailsBloc {}
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockUserDetailsBloc mockUserDetailsBloc;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockUserDetailsBloc = MockUserDetailsBloc();
    mockGoRouter = MockGoRouter();

    when(() => mockUserDetailsBloc.state).thenReturn(
      const UserDetailsState(),
    );

    // Mocking the stream to provide an empty stream or a stream with the initial state
    when(() => mockUserDetailsBloc.stream).thenAnswer((_) => Stream.value(const UserDetailsState()));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<UserDetailsBloc>.value(value: mockUserDetailsBloc),
        ],
        child: const UserDetailsScreen(detailsNumber: '123'), // Use the actual screen directly
      ),
    );
  }

  group('UserDetailsScreen', () {
    testWidgets('renders correctly with details number', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Details for #123'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Submit Details'), findsOneWidget);
    });

    testWidgets('shows loading indicator when submitting', (WidgetTester tester) async {
      when(() => mockUserDetailsBloc.state).thenReturn(
        const UserDetailsState(isSubmitting: true),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error snackbar when submission fails', (WidgetTester tester) async {
      when(() => mockUserDetailsBloc.state).thenReturn(
        const UserDetailsState(
          errorMessage: 'Name and Email cannot be empty.',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Name and Email cannot be empty.'), findsOneWidget);
    });

    testWidgets('shows success snackbar and pops when submission succeeds', (WidgetTester tester) async {
      when(() => mockUserDetailsBloc.state).thenReturn(
        const UserDetailsState(isSuccess: true),
      );
      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('User details saved successfully!'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1200));
      verify(() => mockGoRouter.pop()).called(1);
    });

    testWidgets('updates name when text field changes', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'John Doe');
      await tester.pump();

      verify(() => mockUserDetailsBloc.add(const UserNameChanged('John Doe'))).called(1);
    });

    testWidgets('updates email when text field changes', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'john@example.com');
      await tester.pump();

      verify(() => mockUserDetailsBloc.add(const UserEmailChanged('john@example.com'))).called(1);
    });

    testWidgets('submits form when submit button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Submit Details'));
      await tester.pump();

      verify(() => mockUserDetailsBloc.add(const UserDetailsSubmitted())).called(1);
    });

    testWidgets('text fields are disabled during submission', (WidgetTester tester) async {
      when(() => mockUserDetailsBloc.state).thenReturn(
        const UserDetailsState(isSubmitting: true),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final nameField = tester.widget<TextField>(find.widgetWithText(TextField, 'Name'));
      final emailField = tester.widget<TextField>(find.widgetWithText(TextField, 'Email'));

      expect(nameField.enabled, isFalse);
      expect(emailField.enabled, isFalse);
    });

    testWidgets('initializes text fields with bloc state values', (WidgetTester tester) async {
      when(() => mockUserDetailsBloc.state).thenReturn(
        const UserDetailsState(
          name: 'John Doe',
          email: 'john@example.com',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Name'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    });

    testWidgets('app bar has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Details for #123'), findsOneWidget);
    });

    testWidgets('text fields have correct keyboard types', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final nameField = tester.widget<TextField>(find.widgetWithText(TextField, 'Name'));
      final emailField = tester.widget<TextField>(find.widgetWithText(TextField, 'Email'));

      expect(nameField.keyboardType, TextInputType.name);
      expect(emailField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('text fields have correct decoration', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final nameField = tester.widget<TextField>(find.widgetWithText(TextField, 'Name'));
      final emailField = tester.widget<TextField>(find.widgetWithText(TextField, 'Email'));

      expect(nameField.decoration?.labelText, 'Name');
      expect(nameField.decoration?.hintText, 'Enter your name');
      expect(emailField.decoration?.labelText, 'Email');
      expect(emailField.decoration?.hintText, 'Enter your email');
    });

    testWidgets('submit button is enabled when not submitting', (WidgetTester tester) async {
      when(() => mockUserDetailsBloc.state).thenReturn(
        const UserDetailsState(isSubmitting: false),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final submitButton = tester.widget<ElevatedButton>(find.text('Submit Details'));
      expect(submitButton.onPressed, isNotNull);
    });

    testWidgets('submit button is disabled during submission', (WidgetTester tester) async {
      when(() => mockUserDetailsBloc.state).thenReturn(
        const UserDetailsState(isSubmitting: true),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('error snackbar is shown only when not submitting', (WidgetTester tester) async {
      when(() => mockUserDetailsBloc.state).thenReturn(
        const UserDetailsState(
          isSubmitting: true,
          errorMessage: 'Error message',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Error message'), findsNothing);

      when(() => mockUserDetailsBloc.state).thenReturn(
        const UserDetailsState(
          isSubmitting: false,
          errorMessage: 'Error message',
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('success snackbar has correct duration', (WidgetTester tester) async {
      when(() => mockUserDetailsBloc.state).thenReturn(
        const UserDetailsState(isSuccess: true),
      );
      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.duration, const Duration(seconds: 1));
    });

    testWidgets('does not pop when cannot pop', (WidgetTester tester) async {
      when(() => mockUserDetailsBloc.state).thenReturn(
        const UserDetailsState(isSuccess: true),
      );
      when(() => mockGoRouter.canPop()).thenReturn(false);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1200));

      verifyNever(() => mockGoRouter.pop());
    });
  });
} 