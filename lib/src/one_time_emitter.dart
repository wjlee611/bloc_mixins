import 'dart:async';

import 'package:bloc_mixins/src/core/base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin OneTimeEmitter<T> on Closable implements OneTimeStreamableSource<T> {
  final _streamController = StreamController<T>.broadcast();

  @override
  Stream<T> get oneTimeStream => _streamController.stream;

  @override
  @mustCallSuper
  Future<void> close() async {
    _streamController.close();
    return super.close();
  }

  void oneTimeEmit(T value) {
    if (!_streamController.isClosed) {
      _streamController.add(value);
    }
  }
}
