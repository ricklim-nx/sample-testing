import 'package:mocktail/mocktail.dart';
import 'package:sample/data/data.dart';
import 'package:sample/data/data_sources/local_data_source.dart';
import 'package:sample/data/data_sources/remote_data_source.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}
