import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin class BlocMixinsUsecase<T> implements Streamable<T>, Closable {
  final _streamController = StreamController<T>.broadcast();

  @override
  Stream<T> get stream => _streamController.stream;

  @override
  @mustCallSuper
  FutureOr<void> close() {
    _streamController.close();
  }

  @override
  bool get isClosed => _streamController.isClosed;

  void yieldData(T value) {
    if (!_streamController.isClosed) {
      _streamController.add(value);
    }
  }
}
