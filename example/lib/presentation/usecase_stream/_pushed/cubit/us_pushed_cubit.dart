import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:example/domain/usecase/add_one_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class USPushedCubit extends Cubit<USPushedState> {
  final AddOneUsecase _addOneUsecase;

  late final StreamSubscription<int> _addOneUsecaseSubscription;

  USPushedCubit({required AddOneUsecase addOneUsecase})
    : _addOneUsecase = addOneUsecase,
      super(USPushedState.init(initialCount: addOneUsecase.result ?? 0)) {
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
    await _addOneUsecase.call(state.count, delay: 2000);
    if (isClosed) return;
    emit(state.copyWith(isLoading: false));
  }
}

class USPushedState extends Equatable {
  final int count;
  final bool isLoading;

  const USPushedState({required this.count, required this.isLoading});

  const USPushedState.init({int initialCount = 0})
    : count = initialCount,
      isLoading = false;

  USPushedState copyWith({int? count, bool? isLoading}) {
    return USPushedState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [count, isLoading];
}
