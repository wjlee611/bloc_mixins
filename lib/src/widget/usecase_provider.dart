import 'package:bloc_mixins/src/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocMixinsUsecaseProvider<T extends BlocMixinsUsecase>
    extends RepositoryProvider<T> {
  BlocMixinsUsecaseProvider({
    required super.create,
    void Function(T value)? dispose,
    super.key,
    super.child,
    super.lazy,
  }) : super(
         dispose: dispose != null
             ? (value) => dispose(value)
             : (value) => value.close(),
       );

  BlocMixinsUsecaseProvider.value({
    required super.value,
    super.key,
    super.child,
  }) : super.value();
}
