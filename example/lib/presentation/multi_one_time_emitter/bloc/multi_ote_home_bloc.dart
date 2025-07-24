import 'package:bloc/bloc.dart';
import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:equatable/equatable.dart';

part 'multi_ote_home_event.dart';
part 'multi_ote_home_state.dart';

class MultiOTEHomeBloc extends Bloc<MultiOTEHomeEvent, void>
    with OneTimeEmitter<int> {
  int _count = 0;

  MultiOTEHomeBloc() : super(const MultiOTEHomeState.init()) {
    on<MultiOTEHomeIncrementEvent>((event, emit) {
      _count++;
      oneTimeEmit(_count);
    });
  }
}
