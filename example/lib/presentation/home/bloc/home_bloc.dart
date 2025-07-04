import 'package:bloc/bloc.dart';
import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:equatable/equatable.dart';
import 'package:example/domain/add_one_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> with OneTimeEmitter<String> {
  final AddOneUsecase _addOneUsecase;

  HomeBloc({required AddOneUsecase addOneUsecase})
    : _addOneUsecase = addOneUsecase,
      super(const HomeState.init()) {
    on<_HomeAddOneUsecaseListenEvent>(_addOneUsecaseListenEventHandler);
    on<HomeIncrementEvent>(_incrementEventHandler);

    add(_HomeAddOneUsecaseListenEvent());
  }

  // =========================================
  // MARK: _AddOneUsecaseListenEvent
  // =========================================
  void _addOneUsecaseListenEventHandler(
    _HomeAddOneUsecaseListenEvent event,
    Emitter<HomeState> emit,
  ) async {
    await emit.forEach(
      _addOneUsecase.stream,
      onData: (data) {
        oneTimeEmit('Updated count: $data');
        return state.copyWith(count: data);
      },
    );
  }

  // =========================================
  // MARK: IncrementEvent
  // =========================================
  Future<void> _incrementEventHandler(
    HomeIncrementEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    await _addOneUsecase.call(state.count, delay: 0);
    emit(state.copyWith(isLoading: false));
  }
}
