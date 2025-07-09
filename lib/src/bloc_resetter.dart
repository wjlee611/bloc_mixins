import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:bloc_mixins/src/core/base.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef BlocResetterOnReset<B> = void Function(B bloc);

mixin BlocResetter<E, S> on Bloc<E, S> implements InitialStateStoreable<S> {
  /// The initial state of the Bloc.
  /// This is used to reset the Bloc's state when needed.
  S? _initialState;

  BlocResetterOnReset<Bloc<E, S>>? _onReset;

  @override
  S get initialState => _initialState ?? super.state;

  @override
  get state {
    _initialState ??= super.state;
    return super.state;
  }

  @override
  Future<void> close() {
    removeResetRegistry();
    return super.close();
  }

  void reset({bool withCallback = true}) {
    // ignore: invalid_use_of_visible_for_testing_member
    super.emit(initialState);
    if (withCallback) {
      _onReset?.call(this);
    }
  }

  void addResetRegistry({BlocResetterOnReset<Bloc<E, S>>? onReset}) {
    _initialState = super.state;
    _onReset = onReset;
    BlocResetRegistry.addBloc(this);
  }

  void removeResetRegistry() {
    _onReset = null;
    BlocResetRegistry.removeBloc(this);
  }
}
