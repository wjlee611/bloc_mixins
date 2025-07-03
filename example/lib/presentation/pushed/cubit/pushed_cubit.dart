import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:example/domain/add_one_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PushedCubit extends Cubit<PushedState> {
  final AddOneUsecase _addOneUsecase;

  late final StreamSubscription<int> _addOneUsecaseSubscription;

  PushedCubit({required AddOneUsecase addOneUsecase})
    : _addOneUsecase = addOneUsecase,
      super(PushedState.init(initialCount: addOneUsecase.result ?? 0)) {
    _addOneUsecaseSubscription = _addOneUsecase.stream.listen((data) {
      emit(state.copyWith(count: data));
    });
  }

  @override
  Future<void> close() {
    _addOneUsecaseSubscription.cancel();
    return super.close();
  }

  Future<void> increment() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    await _addOneUsecase.call(state.count);
    if (isClosed) return;
    emit(state.copyWith(isLoading: false));
  }
}

class PushedState extends Equatable {
  final int count;
  final bool isLoading;

  const PushedState({required this.count, required this.isLoading});

  const PushedState.init({int initialCount = 0})
    : count = initialCount,
      isLoading = false;

  PushedState copyWith({int? count, bool? isLoading}) {
    return PushedState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [count, isLoading];
}
