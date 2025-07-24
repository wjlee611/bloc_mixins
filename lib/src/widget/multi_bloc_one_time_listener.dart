import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiBlocOneTimeListener extends MultiBlocListener {
  MultiBlocOneTimeListener({
    required List<BlocOneTimeListener> listeners,
    required Widget child,
    Key? key,
  }) : super(key: key, listeners: listeners, child: child);
}
