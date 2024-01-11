import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample/core/core.dart';
import 'package:sample/data/data.dart';

import '../../mocks/data_mocks.dart';

void main() {
  late SettingsRepository repository;
  late MockRemoteDataSource remoteDataSource;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    repository = SettingsRepository(
      dataSource: remoteDataSource,
    );
  });

  group('["getPublicSettings" checks]', () {
    tearDown(() {
      verify(() => remoteDataSource.httpGet<List<String>>('public/settings')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('Successful', () async {
      when(() => remoteDataSource.httpGet<List<String>>(any())).thenAnswer(
        (_) async => Either<Failure, List<String>>.right(<String>[]),
      );
      final Either<Failure, List<String>> res = await repository.getPublicSettings();
      expect(res.isRight, true);
    });

    test('Failure', () async {
      when(() => remoteDataSource.httpGet<List<String>>(any())).thenAnswer(
        (_) async => Either<Failure, List<String>>.left(const Failure()),
      );
      final Either<Failure, List<String>> res = await repository.getPublicSettings();
      expect(res.isLeft, true);
    });
  });

  group('["getPrivateSettings" checks]', () {
    tearDown(() {
      verify(() => remoteDataSource.httpGet<List<String>>('settings')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('Successful', () async {
      when(() => remoteDataSource.httpGet<List<String>>(any())).thenAnswer(
        (_) async => Either<Failure, List<String>>.right(<String>[]),
      );
      final Either<Failure, List<String>> res = await repository.getPrivateSettings();
      expect(res.isRight, true);
    });

    test('Failure', () async {
      when(() => remoteDataSource.httpGet<List<String>>(any())).thenAnswer(
        (_) async => Either<Failure, List<String>>.left(const Failure()),
      );
      final Either<Failure, List<String>> res = await repository.getPrivateSettings();
      expect(res.isLeft, true);
    });
  });
}
