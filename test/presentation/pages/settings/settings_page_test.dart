import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:sample/core/core.dart';
import 'package:sample/presentation/pages/settings/settings_page.dart';

import '../../../build_widget.dart';
import '../../../mocks/domain_mocks.dart';

void main() {
  final List<String> settings = List<String>.generate(5, (int i) => 'Setting $i');

  late MockSettingsUseCase useCase;

  setUp(() {
    useCase = MockSettingsUseCase();

    when(() => useCase.getSettings()).thenAnswer(
      (_) async => Either<Failure, List<String>>.right(settings),
    );
  });

  Future<void> build(WidgetTester tester) => buildWidget(
        tester,
        (_) => ChangeNotifierProvider<SettingsPageVm>(
          create: (_) => SettingsPageVm(
            useCase: useCase,
          ),
          child: const SettingsPage(),
        ),
        isPushPage: true,
      );

  group('[UI checks]', () {
    tearDown(() {
      verify(() => useCase.getSettings()).called(1);
      verifyNoMoreInteractions(useCase);
    });

    testWidgets(
      'While fetching settings, display loading widget',
      (WidgetTester tester) => tester.runAsync(() async {
        when(() => useCase.getSettings()).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(seconds: 1));
          return Either<Failure, List<String>>.right(settings);
        });

        await build(tester);

        expect(find.widgetWithIcon(IconButton, Icons.chevron_left_rounded), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byKey(const ValueKey<String>('SettingsPage_error')), findsNothing);
        expect(find.byType(ListView), findsNothing);
      }),
    );

    testWidgets('Successful fetch of settings will display list', (WidgetTester tester) async {
      await build(tester);

      expect(find.widgetWithIcon(IconButton, Icons.chevron_left_rounded), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byKey(const ValueKey<String>('SettingsPage_error')), findsNothing);
      expect(find.byType(ListView), findsOneWidget);

      for (final String setting in settings) {
        expect(find.widgetWithText(ListTile, setting), findsOneWidget);
      }
    });

    testWidgets('Failure fetch will display error', (WidgetTester tester) async {
      const Failure error = Failure();

      when(() => useCase.getSettings()).thenAnswer(
        (_) async => Either<Failure, List<String>>.left(error),
      );

      await build(tester);

      expect(find.widgetWithIcon(IconButton, Icons.chevron_left_rounded), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(error.error), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });
  });

  group('[Event checks]', () {
    testWidgets(
      'Tapping back icon button in app bar will close this page',
      (WidgetTester tester) async {
        await build(tester);

        await tester.tap(find.widgetWithIcon(IconButton, Icons.chevron_left_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(SettingsPage), findsNothing);
      },
    );

    testWidgets('Tapping "Retry" will refetch settings', (WidgetTester tester) async {
      when(() => useCase.getSettings()).thenAnswer(
        (_) async => Either<Failure, List<String>>.left(const Failure()),
      );

      await build(tester);

      expect(find.byType(ListView), findsNothing);

      when(() => useCase.getSettings()).thenAnswer(
        (_) async => Either<Failure, List<String>>.right(settings),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Retry'));
      await tester.pumpAndSettle();

      verify(() => useCase.getSettings()).called(2);
      verifyNoMoreInteractions(useCase);

      expect(find.byType(ListView), findsOneWidget);

      for (final String setting in settings) {
        expect(find.widgetWithText(ListTile, setting), findsOneWidget);
      }
    });
  });
}
