import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String oneTimeEmitValue = 'oneTimeEmit by bloc';

class OTEBloc extends Bloc<OTEEvent, OTEState> with OneTimeEmitter<String> {
  OTEBloc() : super(OTEState()) {
    on<OTEOpenDialogEvent>((event, emit) {
      oneTimeEmit(oneTimeEmitValue);
    });
  }
}

abstract class OTEEvent {}

class OTEOpenDialogEvent extends OTEEvent {}

class OTEState {
  OTEState();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OTEState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
