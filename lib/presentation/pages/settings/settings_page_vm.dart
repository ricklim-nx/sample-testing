import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../core/core.dart';
import '../../../domain/domain.dart';

class SettingsPageVm with ChangeNotifier {
  SettingsPageVm({
    SettingsUseCase? useCase,
  }) : _useCase = useCase ?? const SettingsUseCase() {
    getSettings();
  }

  final SettingsUseCase _useCase;

  UnmodifiableListView<String>? get settings => _settings;
  UnmodifiableListView<String>? _settings;

  String? get error => _error;
  String? _error;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  Future<void> getSettings() async {
    _isLoading = true;
    notifyListeners();

    final Either<Failure, List<String>> settings = await _useCase.getSettings();

    settings.data(
      (Failure failure) => _error = failure.error,
      (List<String> r) {
        _settings = UnmodifiableListView<String>(r);
        _error = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
