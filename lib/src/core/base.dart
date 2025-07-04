import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UsecaseStreamable<Result> implements Streamable<Result> {
  Result? get result;
}

abstract class UsecaseStreamableSource<Result>
    implements UsecaseStreamable<Result>, Closable {}

abstract class OneTimeStreamable<T extends Object?> {
  Stream<T> get oneTimeStream;
}

abstract class OneTimeStreamableSource<T>
    implements OneTimeStreamable<T>, Closable {}
