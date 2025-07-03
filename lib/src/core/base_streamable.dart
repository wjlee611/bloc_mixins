abstract class BaseStreamable<T extends Object?> {
  Stream<T> get stream;

  void dispose();
}
