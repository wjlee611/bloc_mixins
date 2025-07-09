import 'package:bloc_mixins/src/core/base.dart';
import 'package:bloc_mixins/src/core/exception.dart';

class BlocResetRegistry {
  static final List<ResetRegisterable> _singletonBlocs = [];

  static T get<T extends ResetRegisterable>() {
    for (var bloc in _singletonBlocs) {
      if (bloc is T) {
        return bloc;
      }
    }
    throw BlocResetRegistryGetNullException(T);
  }

  static List<ResetRegisterable> getAll() {
    return _singletonBlocs;
  }

  static int get registeredBlocCount => _singletonBlocs.length;

  static void addBloc(ResetRegisterable bloc) {
    removeBloc(bloc); // Ensure no duplicates
    _singletonBlocs.add(bloc);
  }

  static void removeBloc(ResetRegisterable bloc) {
    _singletonBlocs.remove(bloc);
  }

  static void resetBlocs({bool withCallback = true}) {
    for (var bloc in _singletonBlocs) {
      bloc.reset(withCallback: withCallback);
    }
  }
}
