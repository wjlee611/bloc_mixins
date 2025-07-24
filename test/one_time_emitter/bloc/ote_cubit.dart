import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String oneTimeEmitValue = 'oneTimeEmit by cubit';

class OTECubit extends Cubit<OTEState> with OneTimeEmitter<String> {
  OTECubit() : super(OTEState());

  void openDialog() {
    oneTimeEmit(oneTimeEmitValue);
  }
}

class OTEState {
  OTEState();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OTEState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
