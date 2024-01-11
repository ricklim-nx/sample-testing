import 'package:flutter_test/flutter_test.dart';
import 'package:sample/core/core.dart';

void main() {
  test('Initializing left should set left data only', () {
    final Either<int, String> either = Either<int, String>.left(100);

    expect(either.left, 100);
    expect(either.isLeft, true);
    expect(either.right, null);
    expect(either.isRight, false);

    either.data(
      (int l) => expect(l, 100),
      (String r) => expect(r, null),
    );
  });

  test('Initializing right should set right data only', () {
    final Either<int, String> either = Either<int, String>.right('100');

    expect(either.left, null);
    expect(either.isLeft, false);
    expect(either.right, '100');
    expect(either.isRight, true);

    either.data(
      (int l) => expect(l, null),
      (String r) => expect(r, '100'),
    );
  });
}
