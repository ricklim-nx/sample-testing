import '../../core/core.dart';
import '../../data/data.dart';

class SettingsUseCase {
  const SettingsUseCase({
    AuthRepository? authRepository,
    SettingsRepository? settingsRepository,
  })  : _authRepository = authRepository ?? const AuthRepository(),
        _settingsRepository = settingsRepository ?? const SettingsRepository();

  final AuthRepository _authRepository;
  final SettingsRepository _settingsRepository;

  Future<Either<Failure, List<String>>> getSettings() async {
    final bool isAuthenticated = await _authRepository.isAuthenticated();

    if (!isAuthenticated) {
      return Either<Failure, List<String>>.left(const Failure('Not authenticated'));
    }

    return _settingsRepository.getSettings();
  }
}
