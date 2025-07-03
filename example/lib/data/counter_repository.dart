class CounterRepository {
  Future<int> increment(int value, int delay) async {
    await Future.delayed(Duration(seconds: delay));
    return value + 1;
  }
}
