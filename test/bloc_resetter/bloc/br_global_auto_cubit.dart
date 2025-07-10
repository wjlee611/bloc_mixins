import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BRGlobalAutoCubit extends Cubit<BRGlobalAutoState> with BlocResetter {
  BRGlobalAutoCubit() : super(BRGlobalAutoInitialState()) {
    register(onReset: load);
    load();
  }

  void load() async {
    // Need delay for equivalent behavior of test
    await Future.delayed(Duration.zero);
    emit(BRGlobalAutoLoadingState());
    await Future.delayed(const Duration(milliseconds: 30));
    emit(BRGlobalAutoLoadedState());
  }
}

sealed class BRGlobalAutoState {}

class BRGlobalAutoInitialState extends BRGlobalAutoState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BRGlobalAutoState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'BRGlobalAutoInitialState';
  }
}

class BRGlobalAutoLoadingState extends BRGlobalAutoState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BRGlobalAutoState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'BRGlobalAutoLoadingState';
  }
}

class BRGlobalAutoLoadedState extends BRGlobalAutoState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BRGlobalAutoState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'BRGlobalAutoLoadedState';
  }
}
