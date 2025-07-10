part of 'global_bloc.dart';

sealed class GlobalState extends Equatable {}

class GlobalInitialState extends GlobalState {
  @override
  List<Object?> get props => [];
}

class GlobalLoadingState extends GlobalState {
  @override
  List<Object?> get props => [];
}

class GlobalLoadedState extends GlobalState {
  @override
  List<Object?> get props => [];
}
