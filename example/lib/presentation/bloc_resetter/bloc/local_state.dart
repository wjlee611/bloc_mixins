part of 'local_bloc.dart';

sealed class LocalState extends Equatable {}

class LocalInitialState extends LocalState {
  @override
  List<Object?> get props => [];
}

class LocalLoadingState extends LocalState {
  @override
  List<Object?> get props => [];
}

class LocalLoadedState extends LocalState {
  @override
  List<Object?> get props => [];
}
