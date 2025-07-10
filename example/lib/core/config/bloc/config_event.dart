part of 'config_bloc.dart';

abstract class ConfigEvent {}

class ConfigLoadEvent extends ConfigEvent {}

class ConfigChangeSeedColorEvent extends ConfigEvent {
  final Color seedColor;

  ConfigChangeSeedColorEvent(this.seedColor);
}
