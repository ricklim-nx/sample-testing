class LocalDataSource {
  const LocalDataSource();

  Future<T?> dbGet<T>(String key) async {
    return true as T;
    // return null as T;
  }
}
