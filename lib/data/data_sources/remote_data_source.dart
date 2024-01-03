import '../../core/core.dart';

class RemoteDataSource {
  const RemoteDataSource();

  Future<Either<Failure, T>> httpGet<T>(String path) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return Either<Failure, List<String>>.right(List<String>.generate(5, (int i) => 'Setting $i'))
        as Either<Failure, T>;
    // return Either<Failure, T>.left(const Failure());
  }
}
