import 'package:equatable/equatable.dart';
import 'package:example/presentation/one_time_emitter/bloc/ote_home_bloc.dart';

sealed class OTEHomeUiEventModel extends Equatable {}

class OTEHomeSnackBarModel extends OTEHomeUiEventModel {
  final String message;

  OTEHomeSnackBarModel({required this.message});

  @override
  List<Object> get props => [message];
}

class OTEHomeDialogModel extends OTEHomeUiEventModel {
  final int value;
  final String content;
  final OTEHomeEvent okEvent;

  OTEHomeDialogModel({
    required this.value,
    required this.content,
    required this.okEvent,
  });

  @override
  List<Object> get props => [value, content, okEvent];
}
