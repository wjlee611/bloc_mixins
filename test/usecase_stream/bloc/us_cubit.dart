import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../usecase/sync_usecase.dart';

class USCubit extends Cubit<int> {
  final SyncUsecase _syncUsecase;
  late final StreamSubscription<int> _syncSubscription;

  USCubit(this._syncUsecase) : super(_syncUsecase.result ?? 0) {
    _syncSubscription = _syncUsecase.stream.listen((syncValue) {
      emit(syncValue);
    });
  }

  @override
  Future<void> close() {
    _syncSubscription.cancel();
    return super.close();
  }

  void syncValue(int value) {
    final res = _syncUsecase(value);
    emit(res);
  }
}
