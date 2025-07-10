import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BRMainAutoBloc extends Bloc<BRMainAutoEvent, BRMainAutoState>
    with BlocResetter {
  BRMainAutoBloc() : super(BRMainAutoInitialState()) {
    register(onReset: () => add(BRMainAutoLoadEvent()));

    on<BRMainAutoLoadEvent>((event, emit) async {
      // Need delay for equivalent behavior of test
      await Future.delayed(Duration.zero);
      emit(BRMainAutoLoadingState());
      await Future.delayed(Duration(milliseconds: 30));
      emit(BRMainAutoLoadedState());
    });

    add(BRMainAutoLoadEvent());
  }
}

abstract class BRMainAutoEvent {}

class BRMainAutoLoadEvent extends BRMainAutoEvent {}

sealed class BRMainAutoState {}

class BRMainAutoInitialState extends BRMainAutoState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BRMainAutoState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'BRMainAutoInitialState';
  }
}

class BRMainAutoLoadingState extends BRMainAutoState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BRMainAutoState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'BRMainAutoLoadingState';
  }
}

class BRMainAutoLoadedState extends BRMainAutoState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BRMainAutoState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'BRMainAutoLoadedState';
  }
}
