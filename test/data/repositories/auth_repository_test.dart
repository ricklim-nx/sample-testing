import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample/data/data.dart';

import '../../mocks/data_mocks.dart';

void main() {
  late AuthRepository repository;
  late MockLocalDataSource localDataSource;

  setUp(() {
    localDataSource = MockLocalDataSource();
    repository = AuthRepository(
      dataSource: localDataSource,
    );
  });

  group('["isAuthenticated" checks]', () {
    tearDown(() {
      verify(() => localDataSource.dbGet<bool?>('jwt')).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test('Successful', () async {
      when(() => localDataSource.dbGet<bool?>(any())).thenAnswer((_) async => true);
      final bool res = await repository.isAuthenticated();
      expect(res, true);
    });

    test('Failure', () async {
      when(() => localDataSource.dbGet<bool?>(any())).thenAnswer((_) async => null);
      final bool res = await repository.isAuthenticated();
      expect(res, false);
    });
  });
}
