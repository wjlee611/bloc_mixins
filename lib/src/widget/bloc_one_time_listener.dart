import 'dart:async';

import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef BlocOneTimeWidgetListener<T> =
    void Function(BuildContext context, T value);

class BlocOneTimeListener<B extends OneTimeEmitter<T>, T>
    extends StatefulWidget {
  const BlocOneTimeListener({
    super.key,
    required this.child,
    this.bloc,
    required this.listener,
  });

  final Widget child;

  final B? bloc;

  final BlocOneTimeWidgetListener<T> listener;

  @override
  State<BlocOneTimeListener<B, T>> createState() =>
      _BlocOneTimeListenerState<B, T>();
}

class _BlocOneTimeListenerState<B extends OneTimeEmitter<T>, T>
    extends State<BlocOneTimeListener<B, T>> {
  StreamSubscription<T>? _subscription;
  late B _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant BlocOneTimeListener<B, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      if (_subscription != null) {
        _unsubscribe();
        _bloc = currentBloc;
      }
      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      if (_subscription != null) {
        _unsubscribe();
        _bloc = bloc;
      }
      _subscribe();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscription = _bloc.oneTimeStream.listen((value) {
      if (!mounted) return;
      widget.listener(context, value);
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bloc == null) {
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return widget.child;
  }
}
