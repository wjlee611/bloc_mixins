import 'package:bloc_mixins/src/usecase_stream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsecaseProvider<T extends UsecaseStream> extends RepositoryProvider<T> {
  UsecaseProvider({
    required super.create,
    void Function(T value)? dispose,
    super.key,
    super.child,
    super.lazy,
  }) : super(dispose: dispose ?? (value) => value.close());

  UsecaseProvider.value({required super.value, super.key, super.child})
    : super.value();
}
