import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:bloc_mixins/src/core/base.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocResetter<S> on BlocBase<S> implements ResetRegisterable<S> {
  /// The initial state of the Bloc.
  /// This is used to reset the Bloc's state when needed.
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
    // ignore: invalid_use_of_visible_for_testing_member
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
