import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UsecaseStreamable<Result> implements Streamable<Result> {
  Result? get result;
}

abstract class UsecaseStreamableSource<Result>
    implements UsecaseStreamable<Result>, Closable {}
