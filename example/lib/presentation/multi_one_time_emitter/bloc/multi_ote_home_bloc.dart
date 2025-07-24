import 'package:bloc/bloc.dart';
import 'package:bloc_mixins/bloc_mixins.dart';

part 'multi_ote_home_event.dart';

class MultiOTEHomeBloc extends Bloc<MultiOTEHomeEvent, void>
    with OneTimeEmitter<int> {
  int _count = 0;

  MultiOTEHomeBloc() : super(null) {
    on<MultiOTEHomeIncrementEvent>((event, emit) {
      _count++;
      oneTimeEmit(_count);
    });
  }
}
