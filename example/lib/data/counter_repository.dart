class CounterRepository {
  Future<int> increment(int value, {int delay = 200}) async {
    await Future.delayed(Duration(milliseconds: delay));
    return value + 1;
  }
}
