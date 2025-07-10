import 'package:bloc_mixins/src/util/bloc_reset_registry.dart';

/// {@template bloc_reset_registry_get_null_exception}
/// Exception thrown when a requested Bloc is not found in the registry.
///
/// This exception is typically raised by [BlocResetRegistry.get] when the
/// requested Bloc type is not registered.
///
/// Example:
/// ```dart
/// try {
///   final bloc = BlocResetRegistry.get<BlocWithBlocResettable>();
/// } on BlocResetRegistryGetNullException catch (e) {
///   ...
/// }
/// ```
/// {@endtemplate}
class BlocResetRegistryGetNullException implements Exception {
  /// {@macro bloc_reset_registry_get_null_exception}
  BlocResetRegistryGetNullException(this.valueType);

  /// The type of the value being retrieved
  final Type valueType;

  @override
  String toString() {
    return "Cannot find Bloc <$valueType> from the registry.";
  }
}
