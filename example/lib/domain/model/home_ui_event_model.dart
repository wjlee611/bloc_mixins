import 'package:equatable/equatable.dart';
import 'package:example/presentation/home/bloc/home_bloc.dart';

sealed class HomeUiEventModel extends Equatable {}

class HomeSnackBarModel extends HomeUiEventModel {
  final String message;

  HomeSnackBarModel({required this.message});

  @override
  List<Object> get props => [message];
}

class HomeDialogModel extends HomeUiEventModel {
  final int value;
  final String content;
  final HomeEvent okEvent;

  HomeDialogModel({
    required this.value,
    required this.content,
    required this.okEvent,
  });

  @override
  List<Object> get props => [value, content, okEvent];
}
