import 'package:bloc/bloc.dart';
import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:equatable/equatable.dart';
import 'package:example/data/counter_repository.dart';
import 'package:example/domain/model/ote_home_ui_event_model.dart';

part 'ote_home_event.dart';
part 'ote_home_state.dart';

class OTEHomeBloc extends Bloc<OTEHomeEvent, OTEHomeState>
    with OneTimeEmitter<OTEHomeUiEventModel> {
  final CounterRepository _counterRepository;

  OTEHomeBloc({required CounterRepository counterRepository})
    : _counterRepository = counterRepository,
      super(const OTEHomeState.init()) {
    on<OTEHomeIncrementEvent>(_incrementEventHandler);
    on<OTEHomeResetEvent>((event, emit) {
      emit(state.copyWith(count: 0));
      oneTimeEmit(OTEHomeSnackBarModel(message: 'Count has been reset.'));
    });
  }

  // =========================================
  // MARK: IncrementEvent
  // =========================================
  Future<void> _incrementEventHandler(
    OTEHomeIncrementEvent event,
    Emitter<OTEHomeState> emit,
  ) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    final res = await _counterRepository.increment(state.count);
    emit(state.copyWith(isLoading: false, count: res));
    if (res % 10 == 0 && res != 0) {
      oneTimeEmit(
        OTEHomeDialogModel(
          value: res,
          content: 'Count is reached $res!\nReset?',
          okEvent: OTEHomeResetEvent(),
        ),
      );
    }
    oneTimeEmit(OTEHomeSnackBarModel(message: 'Count incremented to $res'));
  }
}
