import 'dart:async';

import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:bloc_mixins/src/core/base.dart';
import 'package:flutter/foundation.dart';

/// A mixin for handling Bloc-to-Bloc communication in the Domain Layer.
///
/// It is not necessary to inherit from all UseCases, but it is used by
/// inheriting from UseCase that will be used in Blocs that need to share state.
///
/// ### How to use
///
/// ---
///
/// **Step 1:**
///
/// In the inherited UseCase, call the [yieldData] method.
///
/// {@template yield_data_usage}
/// _Example_
/// ```dart
/// class ExUseCase with BaseStreamUsecase<int> {
///   final ExRepository _exRepository;
///
///   void call(int num) async {
///     final res = await _exRepository.intAdder(num);
///     yieldData(res); // Call yieldData
///   }
/// }
/// ```
/// {@endtemplate}
///
/// You may return a return value if necessary.
///
/// ---
///
/// **Step 2:**
///
/// Data passed to [yieldData] can be received from Bloc via [stream].
///
/// {@template stream_usage}
/// _Example_
/// ```dart
/// on<InitStreamEvent>((event, emit)) async {
///   await emit.forEach(
///     _exUseCase.stream, // Usecase의 stream
///     onData: (data) => BlocState(data: data),
///   );
/// }
/// ```
///
/// When you call `_exUseCase.call()` in a Bloc, you can receive data through
/// the `_exUseCase.stream` connected via InitStreamEvent.
///
/// You can also use the same method to synchronize data via [stream] in other
/// Blocs that require state synchronization.
/// {@endtemplate}
///
/// ---
///
/// **Step 3:**
///
/// A Usecase that inherits [UsecaseStream] must be provided via
/// [UsecaseProvider] at the top of the widget tree of the Bloc that uses it.
/// This is to control [stream] according to the Flutter lifecycle.
///
/// {@template close_usage}
/// [close] is called inside [UsecaseProvider]. Therefore, if it is provided
/// through [UsecaseProvider], do not call close separately.
/// {@endtemplate}
///
/// For more information, see [UsecaseProvider].
mixin UsecaseStream<R> implements UsecaseStreamableSource<R> {
  final _streamController = StreamController<R>.broadcast();

  /// A [stream] for synchronizing state between Blocs.
  ///
  /// Calling [yieldData] in a Usecase will add data to this [stream], and
  /// you can subscribe to this [stream] in your Bloc to synchronize its state,
  /// as in the example below.
  ///
  /// {@macro stream_usage}
  @override
  Stream<R> get stream => _streamController.stream;

  /// Whether [stream] is closed.
  @override
  bool get isClosed => _streamController.isClosed;

  /// {@template result_usage}
  /// The last result data from the [stream].
  ///
  /// This can be used for convenience in synchronizing with late-initialized
  /// Blocs.
  /// {@endtemplate}
  @override
  R? get result => _lastResult;

  /// {@macro result_usage}
  set result(R? value) {
    _lastResult = value;
  }

  /// {@macro close_usage}
  @override
  @mustCallSuper
  FutureOr<void> close() {
    _streamController.close();
  }

  /// {@macro result_usage}
  R? _lastResult;

  /// Add data to [stream] for state synchronization between Blocs.
  ///
  /// {@macro yield_data_usage}
  void yieldData(R value) {
    if (!_streamController.isClosed) {
      _streamController.add(value);
      _lastResult = value;
    }
  }
}
