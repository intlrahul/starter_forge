import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/core/widgets/loading_indicator.dart';

void main() {
  testWidgets('AppLoader renders CircularProgressIndicator', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppLoader(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('AppLoader is centered in Scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppLoader(),
          ),
        ),
      ),
    );

    final centerFinder = find.byType(Center);
    final loaderFinder = find.byType(AppLoader);
    
    expect(centerFinder, findsOneWidget);
    expect(loaderFinder, findsOneWidget);
    
    final centerWidget = tester.widget<Center>(centerFinder);
    final loaderWidget = tester.widget<AppLoader>(loaderFinder);
    
    expect(centerWidget.child, equals(loaderWidget));
  });
} 