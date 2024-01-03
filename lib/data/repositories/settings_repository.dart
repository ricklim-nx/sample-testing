import '../../core/core.dart';
import '../data_sources/remote_data_source.dart';

class SettingsRepository {
  const SettingsRepository({
    RemoteDataSource? dataSource,
  }) : _dataSource = dataSource ?? const RemoteDataSource();

  final RemoteDataSource _dataSource;

  Future<Either<Failure, List<String>>> getSettings() =>
      _dataSource.httpGet<List<String>>('settings');
}
