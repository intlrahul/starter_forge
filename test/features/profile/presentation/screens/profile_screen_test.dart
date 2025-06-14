import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_bloc.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_event.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_state.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_state.dart';
import 'package:starter_forge/features/profile/presentation/screens/profile_screen.dart';

class MockProfileBloc extends Mock implements ProfileBloc {}
class MockThemeBloc extends Mock implements ThemeBloc {}

void main() {
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_test/flutter_test.dart';
  import 'package:mocktail/mocktail.dart';
  import 'package:starter_forge/core/theme/theme_bloc/theme_bloc.dart';
  import 'package:starter_forge/core/theme/theme_bloc/theme_event.dart';
  import 'package:starter_forge/core/theme/theme_bloc/theme_state.dart';
  import 'package:starter_forge/features/profile/presentation/bloc/profile_bloc.dart';
  import 'package:starter_forge/features/profile/presentation/bloc/profile_state.dart';
  import 'package:starter_forge/features/profile/presentation/screens/profile_screen.dart';

  class MockProfileBloc extends Mock implements ProfileBloc {}
  class MockThemeBloc extends Mock implements ThemeBloc {}

  void main() {
    late MockProfileBloc mockProfileBloc;
    late MockThemeBloc mockThemeBloc;

    setUp(() {
      mockProfileBloc = MockProfileBloc();
      mockThemeBloc = MockThemeBloc();

      // Set up the mock ThemeBloc state
      when(() => mockThemeBloc.state).thenReturn(
        const ThemeState(themeMode: ThemeMode.system, isDarkMode: false)
      );
      when(() => mockThemeBloc.stream).thenAnswer((_) => Stream.value(
        const ThemeState(themeMode: ThemeMode.system, isDarkMode: false)
      ));
      // Default ProfileBloc state
      when(() => mockProfileBloc.stream).thenAnswer((_) => const Stream.empty());
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
            BlocProvider<ThemeBloc>.value(value: mockThemeBloc),
          ],
          child: const ProfileScreen(),
        ),
      );
    }

    group('ProfileScreen', () {
      testWidgets('shows loading indicator when status is loading', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(status: ProfileStatus.loading),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // AppLoader is used instead of CircularProgressIndicator
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(AppLoader), findsOneWidget);
      });

      testWidgets('shows error snackbar when status is failure', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(
            status: ProfileStatus.failure,
            errorMessage: 'Error loading profile',
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        // Show snackbar after frame
        await tester.pump(); // pump once for the snackbar to show

        expect(find.text('Error loading profile'), findsOneWidget);
      });

      testWidgets('displays profile information correctly', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(
            status: ProfileStatus.success,
            name: 'John Doe',
            email: 'john@example.com',
            bio: 'Test bio',
            profileImageUrl: 'https://example.com/avatar.jpg',
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('john@example.com'), findsOneWidget);
        expect(find.text('Test bio'), findsOneWidget);
        expect(find.text('Personal Information'), findsOneWidget);
        expect(find.text('About Me'), findsOneWidget);
        expect(find.text('Appearance'), findsOneWidget);
      });

      testWidgets('shows default avatar when no profile image', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(
            status: ProfileStatus.success,
            name: 'John Doe',
            email: 'john@example.com',
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('theme toggle changes theme mode', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(status: ProfileStatus.success),
        );
        // Allow themeBloc to receive events
        when(() => mockThemeBloc.add(any())).thenReturn(null);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Dark'));
        await tester.pumpAndSettle();

        verify(() => mockThemeBloc.add(const UpdateTheme(ThemeMode.dark))).called(1);
      });

      testWidgets('shows "No bio available" when bio is empty', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(
            status: ProfileStatus.success,
            name: 'John Doe',
            email: 'john@example.com',
            bio: '',
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('No bio available.'), findsOneWidget);
      });

      testWidgets('info rows display correct data', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(
            status: ProfileStatus.success,
            name: 'John Doe',
            email: 'john@example.com',
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.person_outline), findsOneWidget);
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('app bar has correct title', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(status: ProfileStatus.success),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('My Profile'), findsOneWidget);
      });

      testWidgets('theme toggle card has correct styling', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(status: ProfileStatus.success),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final themeCard = tester.widget<Card>(find.ancestor(
          of: find.text('Theme'),
          matching: find.byType(Card),
        ));

        expect(themeCard.elevation, 0);
        expect(themeCard.shape, isA<RoundedRectangleBorder>());
      });

      testWidgets('profile header has correct layout', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(
            status: ProfileStatus.success,
            name: 'John Doe',
            email: 'john@example.com',
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        expect(avatar.radius, 60);
      });

      testWidgets('info card has correct styling', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(
            status: ProfileStatus.success,
            name: 'John Doe',
            email: 'john@example.com',
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final infoCard = tester.widget<Card>(find.ancestor(
          of: find.text('Name'),
          matching: find.byType(Card),
        ));

        expect(infoCard.elevation, 0);
      });

      testWidgets('theme toggle segments have correct options', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(status: ProfileStatus.success),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Light'), findsOneWidget);
        expect(find.text('System'), findsOneWidget);
        expect(find.text('Dark'), findsOneWidget);
        expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
        expect(find.byIcon(Icons.brightness_auto_outlined), findsOneWidget);
        expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
      });

      testWidgets('profile image loads from network URL', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(
            status: ProfileStatus.success,
            name: 'John Doe',
            email: 'john@example.com',
            profileImageUrl: 'https://example.com/avatar.jpg',
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        expect(avatar.backgroundImage, isA<NetworkImage>());
      });

      testWidgets('profile image loads from asset', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(
            status: ProfileStatus.success,
            name: 'John Doe',
            email: 'john@example.com',
            profileImageUrl: 'assets/images/avatar.png',
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        expect(avatar.backgroundImage, isA<AssetImage>());
      });

      // Additional tests

      testWidgets('shows N/A for empty name and email', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(
            status: ProfileStatus.success,
            name: '',
            email: '',
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Should show N/A for both name and email
        expect(find.text('N/A'), findsNWidgets(2));
      });

      testWidgets('shows initial loader when status is initial', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(status: ProfileStatus.initial),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(AppLoader), findsOneWidget);
      });

      testWidgets('theme toggle card border color changes with dark mode', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(status: ProfileStatus.success),
        );
        when(() => mockThemeBloc.state).thenReturn(
          const ThemeState(themeMode: ThemeMode.dark, isDarkMode: true),
        );
        when(() => mockThemeBloc.stream).thenAnswer((_) => Stream.value(
          const ThemeState(themeMode: ThemeMode.dark, isDarkMode: true),
        ));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final themeCard = tester.widget<Card>(find.ancestor(
          of: find.text('Theme'),
          matching: find.byType(Card),
        ));

        expect(themeCard.elevation, 0);
        expect(themeCard.shape, isA<RoundedRectangleBorder>());
      });

      testWidgets('does not show error snackbar if errorMessage is null', (WidgetTester tester) async {
        when(() => mockProfileBloc.state).thenReturn(
          const ProfileState(
            status: ProfileStatus.failure,
            errorMessage: null,
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Should not find any snackbar with null error message
        expect(find.byType(SnackBar), findsNothing);
      });
    });
  }
        child: const ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen', () {
    testWidgets('shows loading indicator when status is loading', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(status: ProfileStatus.loading),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error snackbar when status is failure', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(
          status: ProfileStatus.failure,
          errorMessage: 'Error loading profile',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Error loading profile'), findsOneWidget);
    });

    testWidgets('displays profile information correctly', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(
          status: ProfileStatus.success,
          name: 'John Doe',
          email: 'john@example.com',
          bio: 'Test bio',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('Test bio'), findsOneWidget);
      expect(find.text('Personal Information'), findsOneWidget);
      expect(find.text('About Me'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
    });

    testWidgets('shows default avatar when no profile image', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(
          status: ProfileStatus.success,
          name: 'John Doe',
          email: 'john@example.com',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('theme toggle changes theme mode', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(status: ProfileStatus.success),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      verify(() => mockThemeBloc.add(const UpdateTheme(ThemeMode.dark))).called(1);
    });

    testWidgets('shows "No bio available" when bio is empty', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(
          status: ProfileStatus.success,
          name: 'John Doe',
          email: 'john@example.com',
          bio: '',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No bio available.'), findsOneWidget);
    });

    testWidgets('info rows display correct data', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(
          status: ProfileStatus.success,
          name: 'John Doe',
          email: 'john@example.com',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('app bar has correct title', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(status: ProfileStatus.success),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('My Profile'), findsOneWidget);
    });

    testWidgets('theme toggle card has correct styling', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(status: ProfileStatus.success),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final themeCard = tester.widget<Card>(find.ancestor(
        of: find.text('Theme'),
        matching: find.byType(Card),
      ));

      expect(themeCard.elevation, 0);
      expect(themeCard.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('profile header has correct layout', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(
          status: ProfileStatus.success,
          name: 'John Doe',
          email: 'john@example.com',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.radius, 60);
    });

    testWidgets('info card has correct styling', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(
          status: ProfileStatus.success,
          name: 'John Doe',
          email: 'john@example.com',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final infoCard = tester.widget<Card>(find.ancestor(
        of: find.text('Name'),
        matching: find.byType(Card),
      ));

      expect(infoCard.elevation, 0);
    });

    testWidgets('theme toggle segments have correct options', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(status: ProfileStatus.success),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Light'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
      expect(find.byIcon(Icons.brightness_auto_outlined), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    });

    testWidgets('profile image loads from network URL', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(
          status: ProfileStatus.success,
          name: 'John Doe',
          email: 'john@example.com',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.backgroundImage, isA<NetworkImage>());
    });

    testWidgets('profile image loads from asset', (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileState(
          status: ProfileStatus.success,
          name: 'John Doe',
          email: 'john@example.com',
          profileImageUrl: 'assets/images/avatar.png',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.backgroundImage, isA<AssetImage>());
    });
  });
} 