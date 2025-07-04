import 'package:bloc/bloc.dart';
import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:equatable/equatable.dart';
import 'package:example/domain/model/home_ui_event_model.dart';
import 'package:example/domain/usecase/add_one_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>
    with OneTimeEmitter<HomeUiEventModel> {
  final AddOneUsecase _addOneUsecase;

  HomeBloc({required AddOneUsecase addOneUsecase})
    : _addOneUsecase = addOneUsecase,
      super(const HomeState.init()) {
    on<_HomeAddOneUsecaseListenEvent>(_addOneUsecaseListenEventHandler);
    on<HomeIncrementEvent>(_incrementEventHandler);
    on<HomeResetEvent>((event, emit) {
      emit(state.copyWith(count: 0));
      _addOneUsecase.result = 0;
      oneTimeEmit(HomeSnackBarModel(message: 'Count has been reset.'));
    });

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
        oneTimeEmit(HomeSnackBarModel(message: 'Updated count: $data'));
        if (data % 10 == 0) {
          oneTimeEmit(
            HomeDialogModel(
              value: data,
              content:
                  'You have pushed the button this many times: $data\nReset?',
              okEvent: HomeResetEvent(),
            ),
          );
        }
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
    await _addOneUsecase.call(state.count, delay: 1);
    emit(state.copyWith(isLoading: false));
  }
}
