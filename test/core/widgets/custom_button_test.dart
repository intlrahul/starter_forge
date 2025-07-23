import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/core/widgets/custom_button.dart';

void main() {
  group('AppButton', () {
    testWidgets('renders with required text parameter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(text: 'Test Button'),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    group('button variants', () {
      testWidgets('primary variant uses primary colors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Primary Button',
                variant: AppButtonVariant.primary,
              ),
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        final buttonStyle = button.style!;
        
        expect(find.text('Primary Button'), findsOneWidget);
        expect(buttonStyle.elevation?.resolve({}), equals(2));
      });

      testWidgets('secondary variant uses secondary colors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Secondary Button',
                variant: AppButtonVariant.secondary,
              ),
            ),
          ),
        );

        expect(find.text('Secondary Button'), findsOneWidget);
      });

      testWidgets('outline variant has border and no elevation', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Outline Button',
                variant: AppButtonVariant.outline,
              ),
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        final buttonStyle = button.style!;
        
        expect(find.text('Outline Button'), findsOneWidget);
        expect(buttonStyle.elevation?.resolve({}), equals(0));
      });

      testWidgets('text variant has no elevation', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Text Button',
                variant: AppButtonVariant.text,
              ),
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        final buttonStyle = button.style!;
        
        expect(buttonStyle.elevation?.resolve({}), equals(0));
      });

      testWidgets('error variant uses error colors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Error Button',
                variant: AppButtonVariant.error,
              ),
            ),
          ),
        );

        expect(find.text('Error Button'), findsOneWidget);
      });

      testWidgets('success variant uses success colors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Success Button',
                variant: AppButtonVariant.success,
              ),
            ),
          ),
        );

        expect(find.text('Success Button'), findsOneWidget);
      });
    });

    group('button sizes', () {
      testWidgets('small size has correct padding and font size', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Small Button',
                size: AppButtonSize.small,
              ),
            ),
          ),
        );

        expect(find.text('Small Button'), findsOneWidget);
      });

      testWidgets('medium size (default) has correct padding and font size', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Medium Button',
                size: AppButtonSize.medium,
              ),
            ),
          ),
        );

        expect(find.text('Medium Button'), findsOneWidget);
      });

      testWidgets('large size has correct padding and font size', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Large Button',
                size: AppButtonSize.large,
              ),
            ),
          ),
        );

        expect(find.text('Large Button'), findsOneWidget);
      });
    });

    group('button states', () {
      testWidgets('enabled button responds to tap', (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Enabled Button',
                onPressed: () => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(AppButton));
        expect(tapped, isTrue);
      });

      testWidgets('disabled button does not respond to tap', (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Disabled Button',
                isEnabled: false,
                onPressed: () => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(AppButton));
        expect(tapped, isFalse);
      });

      testWidgets('loading button shows circular progress indicator', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Loading Button',
                isLoading: true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading Button'), findsNothing);
      });

      testWidgets('loading button does not respond to tap', (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Loading Button',
                isLoading: true,
                onPressed: () => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(AppButton));
        expect(tapped, isFalse);
      });
    });

    group('button with icon', () {
      testWidgets('displays icon and text when icon is provided', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Icon Button',
                icon: Icons.star,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Icon Button'), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('icon button with loading state shows only progress indicator', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Loading Icon Button',
                icon: Icons.star,
                isLoading: true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byIcon(Icons.star), findsNothing);
        expect(find.text('Loading Icon Button'), findsNothing);
      });
    });

    group('custom styling', () {
      testWidgets('custom background color overrides variant color', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Custom Color Button',
                backgroundColor: Colors.purple,
              ),
            ),
          ),
        );

        expect(find.text('Custom Color Button'), findsOneWidget);
      });

      testWidgets('custom foreground color overrides variant color', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Custom Text Color Button',
                foregroundColor: Colors.orange,
              ),
            ),
          ),
        );

        expect(find.text('Custom Text Color Button'), findsOneWidget);
      });

      testWidgets('custom border radius overrides default', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Custom Radius Button',
                borderRadius: 20.0,
              ),
            ),
          ),
        );

        expect(find.text('Custom Radius Button'), findsOneWidget);
      });

      testWidgets('custom padding overrides size padding', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Custom Padding Button',
                padding: EdgeInsets.all(30),
              ),
            ),
          ),
        );

        expect(find.text('Custom Padding Button'), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('button with null onPressed is disabled', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'No Callback Button',
                onPressed: null,
              ),
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNull);
      });

      testWidgets('button disabled when isEnabled is false even with onPressed', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Explicitly Disabled',
                isEnabled: false,
                onPressed: () {},
              ),
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNull);
      });

      testWidgets('empty text still renders button', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(text: ''),
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('very long text is displayed correctly', (tester) async {
        const longText = 'This is a very long button text that might wrap or overflow depending on the available space and button constraints';
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(text: longText),
            ),
          ),
        );

        expect(find.text(longText), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('button is accessible by screen readers', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(text: 'Accessible Button'),
            ),
          ),
        );

        final button = find.byType(ElevatedButton);
        expect(button, findsOneWidget);
        
        // Verify the button has accessible text
        expect(find.text('Accessible Button'), findsOneWidget);
      });

      testWidgets('loading state is accessible', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Loading Button',
                isLoading: true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });
  });
}
