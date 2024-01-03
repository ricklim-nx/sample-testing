import 'package:flutter/foundation.dart';

class Either<L, R> {
  Either._(dynamic data) {
    if (data is L) {
      _left = data;
    } else {
      _right = data as R;
    }
  }

  factory Either.left(L data) => Either<L, R>._(data);

  factory Either.right(R data) => Either<L, R>._(data);

  @visibleForTesting
  L? get left => _left;
  L? _left;

  @visibleForTesting
  R? get right => _right;
  R? _right;

  bool get isLeft => _left != null;

  bool get isRight => _right != null;

  void data(void Function(L l) left, void Function(R r) right) {
    if (_left != null) {
      left(_left as L);
    } else {
      right(_right as R);
    }
  }
}
