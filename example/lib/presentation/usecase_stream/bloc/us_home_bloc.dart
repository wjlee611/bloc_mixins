import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:example/domain/usecase/add_one_usecase.dart';

part 'us_home_event.dart';
part 'us_home_state.dart';

class USHomeBloc extends Bloc<USHomeEvent, USHomeState> {
  final AddOneUsecase _addOneUsecase;

  USHomeBloc({required AddOneUsecase addOneUsecase})
    : _addOneUsecase = addOneUsecase,
      super(const USHomeState.init()) {
    on<_USHomeAddOneUsecaseListenEvent>(_addOneUsecaseListenEventHandler);
    on<USHomeIncrementEvent>(_incrementEventHandler);

    add(_USHomeAddOneUsecaseListenEvent());
  }

  // =========================================
  // MARK: _AddOneUsecaseListenEvent
  // =========================================
  void _addOneUsecaseListenEventHandler(
    _USHomeAddOneUsecaseListenEvent event,
    Emitter<USHomeState> emit,
  ) async {
    await emit.forEach(
      _addOneUsecase.stream,
      onData: (data) {
        return state.copyWith(count: data);
      },
    );
  }

  // =========================================
  // MARK: IncrementEvent
  // =========================================
  Future<void> _incrementEventHandler(
    USHomeIncrementEvent event,
    Emitter<USHomeState> emit,
  ) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    await _addOneUsecase.call(state.count);
    emit(state.copyWith(isLoading: false));
  }
}
