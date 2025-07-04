import 'dart:async';

import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:bloc_mixins/src/core/base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A mixin for triggering one-time UI events in Bloc.
///
/// ### How to use
///
/// ---
///
/// **Step 1:**
///
/// Inherit [OneTimeEmitter] mixin in your Bloc.
/// Specify the data type to be passed to the UI as a generic type.
///
/// _Example_
/// ```dart
/// class ExampleBloc extends Bloc<ExampleEvent, ExampleState>
///     with OneTimeEmitter<ExampleUiEventModel> {
/// }
/// ```
///
/// ---
///
/// **Step 2:**
///
/// Call the [oneTimeEmit] method where you need to trigger a one-time UI event
/// in the Bloc.
///
/// {@template one_time_emit_usage}
/// _Example_
/// ```dart
/// on<ExampleResetEvent>((event, emit) {
///   emit(state.copyWith(count: 0));
///   oneTimeEmit(ExampleSnackBarModel(message: 'Count has been reset.'));
/// });
/// ```
/// {@endtemplate}
///
/// ---
///
/// **Step 3:**
///
/// Use the [BlocOneTimeListener] widget in your UI to listen for one-time UI
/// events from a Bloc.
///
/// _Example_
/// ```dart
/// BlocOneTimeListener<HomeBloc, HomeUiEventModel>(
///   listener: (context, value) {
///     switch (value) {
///       case HomeSnackBarModel():
///         ScaffoldMessenger.of(
///           context,
///         ).showSnackBar(SnackBar(content: Text(value.message)));
///         break;
///       ...
///     }
///   },
///   child: ...
/// )
/// ```
mixin OneTimeEmitter<T> on Closable implements OneTimeStreamableSource<T> {
  final _streamController = StreamController<T>.broadcast();

  /// A stream for managing Bloc's one-time UI events.
  ///
  /// Calling [oneTimeEmit] on a Bloc will add data to [oneTimeStream],
  /// and using the [BlocOneTimeListener] widget in the UI, you can listen for
  /// one-time UI events from the Bloc.
  @override
  Stream<T> get oneTimeStream => _streamController.stream;

  /// This method is part of the [Closable] interface and is called when
  /// the Bloc is closed.
  ///
  /// Closes the stream controller for [oneTimeStream] to release resources.
  @override
  @mustCallSuper
  @protected
  Future<void> close() async {
    _streamController.close();
    return super.close();
  }

  /// Add data to [oneTimeStream] for managing Bloc's one-time UI events.
  ///
  /// {@macro one_time_emit_usage}
  void oneTimeEmit(T value) {
    if (!_streamController.isClosed) {
      _streamController.add(value);
    }
  }
}
