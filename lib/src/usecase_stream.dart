import 'dart:async';

import 'package:bloc_mixins/src/core/base.dart';
import 'package:flutter/foundation.dart';

mixin class UsecaseStream<R> implements UsecaseStreamableSource<R> {
  final _streamController = StreamController<R>.broadcast();

  @override
  Stream<R> get stream => _streamController.stream;

  @override
  bool get isClosed => _streamController.isClosed;

  @override
  R? get result => _lastResult;

  @override
  @mustCallSuper
  FutureOr<void> close() {
    _streamController.close();
  }

  R? _lastResult;

  void yieldData(R value) {
    if (!_streamController.isClosed) {
      _streamController.add(value);
      _lastResult = value;
    }
  }
}
