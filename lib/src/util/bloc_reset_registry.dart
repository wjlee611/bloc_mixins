import 'package:bloc_mixins/src/bloc_resetter.dart';
import 'package:bloc_mixins/src/core/exception.dart';

class BlocResetRegistry {
  static final List<BlocResetter> _singletonBlocs = [];

  static T get<T extends BlocResetter>() {
    for (var bloc in _singletonBlocs) {
      if (bloc is T) {
        return bloc;
      }
    }
    throw BlocResetRegistryGetNullException(T);
  }

  static int get registeredBlocCount => _singletonBlocs.length;

  static void addBloc(BlocResetter bloc) {
    removeBloc(bloc); // Ensure no duplicates
    _singletonBlocs.add(bloc);
  }

  static BlocResetter removeBloc(BlocResetter bloc) {
    _singletonBlocs.remove(bloc);
    return bloc;
  }

  static void resetBlocs({bool withCallback = true}) {
    for (var bloc in _singletonBlocs) {
      bloc.reset(withCallback: withCallback);
    }
  }
}
