import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure([this.error = 'Something went wrong.']);

  final String error;

  @override
  List<String> get props => <String>[
        error,
      ];
}
