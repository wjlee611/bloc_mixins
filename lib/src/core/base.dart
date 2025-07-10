import 'package:bloc_mixins/src/util/bloc_reset_registry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// To prevent inheritance in Bloc, we extended Bloc's [Streamable].
/// (Prevents inheritance with generics other than BlocState.)
///
/// For the convenience of synchronization with Bloc that is initialized late,
/// a generic type [result] has been added. [result] stores the last value of
/// the data generated from [Streamable]'s [stream].
abstract class UsecaseStreamable<Result> implements Streamable<Result> {
  /// the last value of [stream].
  Result? get result;
}

/// When implementing this interface, you can provide [stream] according to
/// the widget life cycle.
/// However, you must use [close] appropriately.
abstract class UsecaseStreamableSource<Result>
    implements UsecaseStreamable<Result>, Closable {}

/// Do not extend [Streamable] to provide a stream for one-time UI events
/// separate from Bloc's stream.
///
/// Instead, provide a stream that handles a one-time UI event via
/// [oneTimeStream].
abstract class OneTimeStreamable<T extends Object?> {
  /// A stream that handles only one-time UI event.
  Stream<T> get oneTimeStream;
}

/// When implementing this interface, you can provide [oneTimeStream] according
/// to the widget life cycle.
/// However, you must use [close] appropriately.
abstract class OneTimeStreamableSource<T>
    implements OneTimeStreamable<T>, Closable {}

/// When implementing this interface, you can store the initial state and
/// reset it to the initial state.
abstract class Resettable<S> {
  /// This property represents the state to which the entity will be reset.
  S get initialState;

  /// Resets the entity to its initial state.
  ///
  /// - [withCallback]: If true, invokes any registered reset callbacks.
  void reset({bool withCallback = true});
}

/// When implementing this interface, you can manage the initialization of that
/// object with [BlocResetRegistry] using the [register] and [unregister] methods.
abstract class ResetRegisterable<S> implements Resettable<S> {
  /// You can register the object in [BlocResetRegistry].
  ///
  /// If you specify an `onReset` handler, the registered handler will be called
  /// if `withCallback` is true when [reset] is called.
  ///
  /// Example:
  /// ```dart
  /// GlobalBloc() : super(GlobalInitialState()) {
  ///   register(onReset: () => add(GlobalLoadEvent()));
  ///   on<GlobalLoadEvent>(_loadEventHandler);
  ///   add(GlobalLoadEvent());
  /// }
  /// ```
  void register({Function()? onReset});

  /// You can unregister the object from [BlocResetRegistry].
  ///
  /// However, you must call this method when this object is disposed.
  void unregister();
}
