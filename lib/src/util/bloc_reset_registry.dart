import 'package:bloc_mixins/src/core/base.dart';
import 'package:bloc_mixins/src/core/exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A registry static utility class optimized for system-wide
/// Bloc initialization.
class BlocResetRegistry {
  static final List<ResetRegisterable> _singletonBlocs = [];

  /// Retrieves a registered Bloc of type [T].
  ///
  /// Throws [BlocResetRegistryGetNullException] if the requested Bloc is not found.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final bloc = BlocResetRegistry.get<BlocWithBlocResettable>();
  /// } on BlocResetRegistryGetNullException catch (e) {
  ///   ...
  /// }
  /// ```
  static T get<T extends ResetRegisterable>() {
    for (var bloc in _singletonBlocs) {
      if (bloc is T) {
        return bloc;
      }
    }
    throw BlocResetRegistryGetNullException(T);
  }

  /// Retrieves all registered Blocs.
  ///
  /// Returns a list of [ResetRegisterable] Blocs currently in the registry.
  static List<ResetRegisterable> getAll() {
    return _singletonBlocs;
  }

  /// Returns the count of registered Blocs.
  static int get registeredBlocCount => _singletonBlocs.length;

  /// Adds a Bloc to the registry. \
  /// Ensures no duplicate Blocs are added by removing existing instances first.
  ///
  /// You will rarely need to call this method manually, as it is
  /// automatically registered the moment Bloc's constructor is called.
  ///
  /// Example:
  /// ```dart
  /// final myBloc = MyBloc(); // Automatically registered
  /// // BlocResetRegistry.addBloc(myBloc);
  /// ```
  static void addBloc(ResetRegisterable bloc) {
    removeBloc(bloc); // Ensure no duplicates
    _singletonBlocs.add(bloc);
  }

  /// Removes a Bloc from the registry.
  ///
  /// Even if you remove it from the registry, the bloc will not be closed.
  /// You have to call [Bloc.close] manually.
  ///
  /// Example:
  /// ```dart
  /// BlocResetRegistry.removeBloc(myBloc);
  /// myBloc.close(); // Close the Bloc if needed
  /// ```
  ///
  /// However, the method is automatically called the moment [Bloc.close]
  /// is called (e.g. when the Bloc provided by [BlocProvider] is removed
  /// from the widget tree).
  static void removeBloc(ResetRegisterable bloc) {
    _singletonBlocs.remove(bloc);
  }

  /// Resets all registered Blocs to their initial state.
  ///
  /// If `withCallback` is true, invokes the `onReset` callback for each Bloc.
  ///
  /// Example:
  /// ```dart
  /// BlocResetRegistry.resetBlocs(withCallback: true); // default is true
  /// ```
  static void resetBlocs({bool withCallback = true}) {
    for (var bloc in _singletonBlocs) {
      bloc.reset(withCallback: withCallback);
    }
  }
}
