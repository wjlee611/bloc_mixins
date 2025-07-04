import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template usecase_provider}
/// [UsecaseProvider], which has the same usage as [RepositoryProvider].
///
/// However, it is important to call [UsecaseStream.close] when it is removed
/// from the widget tree.
/// {@endtemplate}
class UsecaseProvider<T extends UsecaseStream> extends RepositoryProvider<T> {
  /// {@macro usecase_provider}
  UsecaseProvider({
    required super.create,
    void Function(T value)? dispose,
    super.key,
    super.child,
    super.lazy,
  }) : super(dispose: dispose ?? (value) => value.close());

  /// [UsecaseProvider.value], which has the same usage as
  /// [RepositoryProvider.value].
  UsecaseProvider.value({required super.value, super.key, super.child})
    : super.value();
}
