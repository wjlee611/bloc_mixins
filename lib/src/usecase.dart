import 'dart:async';

import 'package:bloc_mixins/src/core/base_streamable.dart';
import 'package:flutter/foundation.dart';

mixin class BlocMixinsUsecase<T> implements BaseStreamable<T> {
  final _streamController = StreamController<T>.broadcast();

  @override
  Stream<T> get stream => _streamController.stream;

  @override
  @mustCallSuper
  void dispose() {
    _streamController.close();
  }

  void yieldData(T value) {
    if (!_streamController.isClosed) {
      _streamController.add(value);
    }
  }
}
