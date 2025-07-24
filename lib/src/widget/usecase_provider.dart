import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/material.dart';
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
    required T Function(BuildContext context) create,
    void Function(T value)? dispose,
    Key? key,
    Widget? child,
    bool? lazy,
  }) : super(
          create: create,
          dispose: dispose ?? (value) => value.close(),
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
}
