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

  group('["getSettings" checks]', () {
    tearDown(() {
      verify(() => authRepository.isAuthenticated()).called(1);
      verifyNoMoreInteractions(authRepository);
    });

    test('Successful (authenticated)', () async {
      when(() => authRepository.isAuthenticated()).thenAnswer((_) async => true);
      when(() => settingsRepository.getPrivateSettings()).thenAnswer(
        (_) async => Either<Failure, List<String>>.right(<String>[]),
      );

      final Either<Failure, List<String>> res = await useCase.getSettings();

      verify(() => settingsRepository.getPrivateSettings()).called(1);
      verifyNoMoreInteractions(settingsRepository);

      expect(res.isRight, true);
    });

    test('Failure (authenticated)', () async {
      when(() => authRepository.isAuthenticated()).thenAnswer((_) async => true);
      when(() => settingsRepository.getPrivateSettings()).thenAnswer(
        (_) async => Either<Failure, List<String>>.left(const Failure()),
      );

      final Either<Failure, List<String>> res = await useCase.getSettings();

      verify(() => settingsRepository.getPrivateSettings()).called(1);
      verifyNoMoreInteractions(settingsRepository);

      expect(res.isLeft, true);
    });

    test('Successful (unauthenticated)', () async {
      when(() => authRepository.isAuthenticated()).thenAnswer((_) async => false);
      when(() => settingsRepository.getPublicSettings()).thenAnswer(
        (_) async => Either<Failure, List<String>>.right(<String>[]),
      );

      final Either<Failure, List<String>> res = await useCase.getSettings();

      verify(() => settingsRepository.getPublicSettings()).called(1);
      verifyNoMoreInteractions(settingsRepository);

      expect(res.isRight, true);
    });

    test('Failure (unauthenticated)', () async {
      when(() => authRepository.isAuthenticated()).thenAnswer((_) async => false);
      when(() => settingsRepository.getPublicSettings()).thenAnswer(
        (_) async => Either<Failure, List<String>>.left(const Failure()),
      );

      final Either<Failure, List<String>> res = await useCase.getSettings();

      verify(() => settingsRepository.getPublicSettings()).called(1);
      verifyNoMoreInteractions(settingsRepository);

      expect(res.isLeft, true);
    });
  });
}
