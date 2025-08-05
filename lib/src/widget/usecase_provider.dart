import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// {@template usecase_provider}
/// [UsecaseProvider], which has the same usage as [RepositoryProvider].
///
/// However, it is important to call [UsecaseStream.close] when it is removed
/// from the widget tree.
/// {@endtemplate}
class UsecaseProvider<T extends UsecaseStream> extends Provider<T> {
  /// {@macro usecase_provider}
  UsecaseProvider({
    required T Function(BuildContext context) create,
    void Function(T value)? dispose,
    Key? key,
    Widget? child,
    bool? lazy,
  }) : super(
          create: create,
          dispose: (context, value) {
            try {
              dispose?.call(value);
            } finally {
              value.close();
            }
          },
          key: key,
          child: child,
          lazy: lazy,
        );

  /// [UsecaseProvider.value], which has the same usage as
  /// [RepositoryProvider.value].
  UsecaseProvider.value({
    required T value,
    Key? key,
    Widget? child,
  }) : super.value(
          key: key,
          value: value,
          child: child,
        );

  /// Method that allows widgets to access a usecase instance as long as
  /// their `BuildContext` contains a [UsecaseProvider] instance.
  static T of<T extends UsecaseStream>(BuildContext context,
      {bool listen = false}) {
    try {
      return Provider.of<T>(context, listen: listen);
    } on ProviderNotFoundException catch (e) {
      if (e.valueType != T) rethrow;
      throw FlutterError(
        '''
        UsecaseProvider.of() called with a context that does not contain a usecase of type $T.
        No ancestor could be found starting from the context that was passed to UsecaseProvider.of<$T>().

        This can happen if the context you used comes from a widget above the UsecaseProvider.

        The context used was: $context
        ''',
      );
    }
  }
}
