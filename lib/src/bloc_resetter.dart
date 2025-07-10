import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:bloc_mixins/src/core/base.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A mixin that provides reset functionality for Blocs.
///
/// ### How to use
///
/// ---
///
/// **Step 1:**
///
/// Inherit [BlocResetter] mixin in your Bloc.
///
/// _Example_
/// ```dart
/// class GlobalBloc extends Bloc<GlobalEvent, GlobalState> with BlocResetter {
/// }
/// ```
///
/// ---
///
/// **Step 2:**
///
/// Call the [register] method in the bloc's constructor. \
/// Optionally, you can also specify the onReset parameter.
///
/// _Example_
/// ```dart
/// GlobalBloc() : super(GlobalInitialState()) {
///   register(onReset: () => add(GlobalLoadEvent()));
///   on<GlobalLoadEvent>(_loadEventHandler);
///   add(GlobalLoadEvent());
/// }
/// ```
///
/// ---
///
/// **Step 3:**
///
/// You can reset a bloc to its initial state by calling the [reset] method.
///
/// ---
///
/// ### Advanced usage
///
/// A bloc that inherits [BlocResetter] can be used as a singleton object
/// via [BlocResetRegistry] when declared outside of [BlocProvider].
///
/// _Example_
/// ```dart
/// void main() {
///   ConfigBloc();
///   runApp(const MyApp());
/// }
/// ...
/// final configBloc = BlocResetRegistry.get<ConfigBloc>();
/// ```
///
/// It can be used in the same way if it is provided via [BlocProvider]. \
/// However, if it is called after it has been removed from the widget tree,
/// [BlocResetRegistryGetNullException] is thrown. \
/// Therefore, in blocs that are tied to the widget lifecycle,
/// use [UsecaseStream] instead.
mixin BlocResetter<S> on BlocBase<S> implements ResetRegisterable<S> {
  S? _initialState;

  Function()? _onReset;

  @override
  get state {
    _initialState ??= super.state;
    return super.state;
  }

  @override
  Future<void> close() {
    unregister();
    return super.close();
  }

  @override
  S get initialState => _initialState ?? super.state;

  @override
  void reset({bool withCallback = true}) {
    super.emit(initialState);
    if (withCallback) {
      _onReset?.call();
    }
  }

  @override
  void register({Function()? onReset}) {
    _initialState = super.state;
    _onReset = onReset;
    BlocResetRegistry.addBloc(this);
  }

  @override
  void unregister() {
    _onReset = null;
    BlocResetRegistry.removeBloc(this);
  }
}
