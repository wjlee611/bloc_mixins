import 'package:flutter_bloc/flutter_bloc.dart';

import '../usecase/sync_usecase.dart';

class USBloc extends Bloc<USEvent, USState> {
  final SyncUsecase _syncUsecase;

  USBloc(this._syncUsecase) : super(USState(_syncUsecase.result ?? 0)) {
    on<_USSyncUsecaseListenEvent>((event, emit) async {
      await emit.forEach(
        _syncUsecase.stream,
        onData: (syncValue) {
          return USState(syncValue);
        },
      );
    });

    on<USSyncEvent>((event, emit) {
      final res = _syncUsecase(event.syncValue);
      emit(USState(res));
    });

    add(_USSyncUsecaseListenEvent());
  }
}

abstract class USEvent {}

class _USSyncUsecaseListenEvent extends USEvent {}

class USSyncEvent extends USEvent {
  final int syncValue;
  USSyncEvent(this.syncValue);
}

class USState {
  final int value;
  USState([this.value = 0]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is USState &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => 0;
}
