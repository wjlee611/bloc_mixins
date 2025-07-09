class BlocResetRegistryGetNullException implements Exception {
  /// Create a BlocResetRegistryGetNullException error with the type represented as a String.
  BlocResetRegistryGetNullException(this.valueType);

  /// The type of the value being retrieved
  final Type valueType;

  @override
  String toString() {
    return "Cannot find Bloc <$valueType> from the registry.";
  }
}
