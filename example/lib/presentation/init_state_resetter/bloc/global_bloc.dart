import 'package:bloc/bloc.dart';
import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:equatable/equatable.dart';

part 'global_event.dart';
part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState>
    with BlocResetter<GlobalState> {
  GlobalBloc() : super(GlobalInitialState()) {
    addResetRegistry(
      onReset: () {
        add(GlobalLoadEvent());
      },
    );

    on<GlobalLoadEvent>(_loadEventHandler);

    add(GlobalLoadEvent());
  }

  // =========================================
  // MARK: LoadEvent
  // =========================================
  Future<void> _loadEventHandler(
    GlobalLoadEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(GlobalLoadingState());
    await Future.delayed(Duration(seconds: 2));
    emit(GlobalLoadedState());
  }
}
