import 'package:bloc/bloc.dart';
import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'config_event.dart';
part 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState>
    with BlocResetter<ConfigEvent, ConfigState> {
  ConfigBloc() : super(ConfigInitialState()) {
    addResetRegistry(onReset: (bloc) => bloc.add(ConfigLoadEvent()));

    on<ConfigLoadEvent>(_loadEventHandler);
    on<ConfigChangeSeedColorEvent>(_changeSeedColorEventHandler);

    add(ConfigLoadEvent());
  }

  // =========================================
  // MARK: LoadEvent
  // =========================================
  Future<void> _loadEventHandler(
    ConfigLoadEvent event,
    Emitter<ConfigState> emit,
  ) async {
    emit(ConfigLoadingState());
    await Future.delayed(Duration(seconds: 2));
    emit(ConfigLoadedState(Colors.blue));
  }

  // =========================================
  // MARK: ChangeSeedColorEvent
  // =========================================
  Future<void> _changeSeedColorEventHandler(
    ConfigChangeSeedColorEvent event,
    Emitter<ConfigState> emit,
  ) async {
    if (state is ConfigLoadingState) return;
    emit(ConfigLoadedState(event.seedColor));
  }
}
