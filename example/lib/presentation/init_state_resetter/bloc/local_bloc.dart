import 'package:bloc/bloc.dart';
import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:equatable/equatable.dart';

part 'local_event.dart';
part 'local_state.dart';

class LocalBloc extends Bloc<LocalEvent, LocalState>
    with BlocResetter<LocalEvent, LocalState> {
  LocalBloc() : super(LocalInitialState()) {
    addResetRegistry(onReset: (bloc) => bloc.add(LocalLoadEvent()));

    on<LocalLoadEvent>(_loadEventHandler);

    add(LocalLoadEvent());
  }

  // =========================================
  // MARK: LoadEvent
  // =========================================
  Future<void> _loadEventHandler(
    LocalLoadEvent event,
    Emitter<LocalState> emit,
  ) async {
    emit(LocalLoadingState());
    await Future.delayed(Duration(seconds: 2));
    emit(LocalLoadedState());
  }
}
