import '../data_sources/local_data_source.dart';

class AuthRepository {
  const AuthRepository({
    LocalDataSource? dataSource,
  }) : _dataSource = dataSource ?? const LocalDataSource();

  final LocalDataSource _dataSource;

  Future<bool> isAuthenticated() async => await _dataSource.dbGet<bool?>('jwt') ?? false;
}
