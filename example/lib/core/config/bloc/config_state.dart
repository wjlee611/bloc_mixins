part of 'config_bloc.dart';

sealed class ConfigState extends Equatable {}

class ConfigInitialState extends ConfigState {
  @override
  List<Object?> get props => [];
}

class ConfigLoadingState extends ConfigState {
  @override
  List<Object?> get props => [];
}

class ConfigLoadedState extends ConfigState {
  final Color seedColor;

  ConfigLoadedState(this.seedColor);

  @override
  List<Object?> get props => [seedColor];
}

class ConfigErrorState extends ConfigState {
  final String error;

  ConfigErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
