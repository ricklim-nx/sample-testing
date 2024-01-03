import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample/presentation/pages/home/home_page.dart';
import 'package:sample/presentation/pages/router.dart';

import '../../../build_widget.dart';

void main() {
  Future<void> build(
    WidgetTester tester, {
    String? title,
    ValueChanged<String>? onNavigate,
  }) =>
      // tester.pumpWidget(
      //   MaterialApp(
      //     home: HomePage(
      //       title: title,
      //     ),
      //   ),
      // );
      buildWidget(
        tester,
        (_) => HomePage(
          title: title,
        ),
        onNavigate: onNavigate,
      );

  group('[UI checks]', () {
    testWidgets('All components are displayed', (WidgetTester tester) async {
      await build(tester);

      expect(find.widgetWithText(AppBar, 'Flutter Demo Home Page'), findsOneWidget);

      expect(find.text('You have pushed the button this many times:'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Open settings'), findsOneWidget);

      expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
    });

    testWidgets('Can change app bar "title"', (WidgetTester tester) async {
      await build(
        tester,
        title: 'New title',
      );

      expect(find.widgetWithText(AppBar, 'Flutter Demo Home Page'), findsNothing);
      expect(find.widgetWithText(AppBar, 'New title'), findsOneWidget);
    });
  });

  group('[Event checks]', () {
    testWidgets('Tapping "+" icon button will increment counter', (WidgetTester tester) async {
      await build(tester);

      await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.add));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets(
      'Tapping "Open settings" will navigate to settings page',
      (WidgetTester tester) async {
        String? newPath;

        await build(
          tester,
          onNavigate: (String path) => newPath = path,
        );

        await tester.tap(find.widgetWithText(ElevatedButton, 'Open settings'));
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsNothing);
        expect(newPath, AppRoutes.settings);
      },
    );
  });
}
