import 'package:bloc/bloc.dart';
import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:equatable/equatable.dart';

part 'local_event.dart';
part 'local_state.dart';

class LocalCubit extends Cubit<LocalState> with BlocResetter<LocalState> {
  LocalCubit() : super(LocalInitialState()) {
    addResetRegistry(
      onReset: () {
        loadEvent();
      },
    );

    loadEvent();
  }

  void loadEvent() async {
    emit(LocalLoadingState());
    await Future.delayed(Duration(seconds: 2));
    emit(LocalLoadedState());
  }
}
