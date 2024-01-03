import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample/core/core.dart';
import 'package:sample/domain/domain.dart';

import '../../mocks/data_mocks.dart';

void main() {
  late SettingsUseCase useCase;
  late MockAuthRepository authRepository;
  late MockSettingsRepository settingsRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    settingsRepository = MockSettingsRepository();
    useCase = SettingsUseCase(
      authRepository: authRepository,
      settingsRepository: settingsRepository,
    );
  });

  group('[getSettings] checks', () {
    tearDown(() {
      verify(() => authRepository.isAuthenticated()).called(1);
      verifyNoMoreInteractions(authRepository);
    });

    test('Successful', () async {
      when(() => authRepository.isAuthenticated()).thenAnswer((_) async => true);
      when(() => settingsRepository.getSettings()).thenAnswer(
        (_) async => Either<Failure, List<String>>.right(<String>[]),
      );

      final Either<Failure, List<String>> res = await useCase.getSettings();

      expect(res.isRight, true);
    });

    test('Failure (not authenticated)', () async {
      when(() => authRepository.isAuthenticated()).thenAnswer((_) async => false);

      final Either<Failure, List<String>> res = await useCase.getSettings();

      verifyNoMoreInteractions(settingsRepository);

      expect(res.left, const Failure('Not authenticated'));
    });

    test('Failure (request)', () async {
      when(() => authRepository.isAuthenticated()).thenAnswer((_) async => true);
      when(() => settingsRepository.getSettings()).thenAnswer(
        (_) async => Either<Failure, List<String>>.left(const Failure()),
      );

      final Either<Failure, List<String>> res = await useCase.getSettings();

      verify(() => settingsRepository.getSettings()).called(1);
      verifyNoMoreInteractions(settingsRepository);

      expect(res.isLeft, true);
    });
  });
}
