import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BRLocalBloc extends Bloc<BRLocalEvent, BRLocalState> with BlocResetter {
  BRLocalBloc() : super(BRLocalInitialState()) {
    register();

    on<BRLocalLoadEvent>((event, emit) async {
      // Need delay for equivalent behavior of test
      await Future.delayed(Duration.zero);
      emit(BRLocalLoadingState());
      await Future.delayed(Duration(milliseconds: 30));
      emit(BRLocalLoadedState());
    });
  }
}

abstract class BRLocalEvent {}

class BRLocalLoadEvent extends BRLocalEvent {}

sealed class BRLocalState {}

class BRLocalInitialState extends BRLocalState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BRLocalState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'BRLocalInitialState';
  }
}

class BRLocalLoadingState extends BRLocalState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BRLocalState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'BRLocalLoadingState';
  }
}

class BRLocalLoadedState extends BRLocalState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BRLocalState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'BRLocalLoadedState';
  }
}
