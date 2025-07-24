import 'dart:async';

import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Signature for the [listener] function which takes the `BuildContext` along
/// with the `value` and is responsible for executing in response to
/// `oneTimeEmit(value)` called.
typedef BlocOneTimeWidgetListener<T> = void Function(
    BuildContext context, T value);

/// {@template bloc_one_time_listener}
/// A listener widget that receives one-time UI events emitted by
/// [OneTimeEmitter.oneTimeEmit].
///
/// The basic usage is almost similar to [BlocListener].
///
/// _Example_
/// ```dart
/// BlocOneTimeListener<HomeBloc, HomeUiEventModel>(
///   listener: (context, value) {
///     // Handle the value (event)
///   },
///   child: ...
/// )
/// ```
///
/// Subscribes to Bloc's `oneTimeStream` and automatically unsubscribes
/// when the Bloc changes or the widget is disposed.
///
/// For more information, see [OneTimeEmitter.oneTimeEmit].
/// {@endtemplate}
class BlocOneTimeListener<B extends OneTimeEmitter<T>, T>
    extends StatefulWidget {
  ///{@macro bloc_one_time_listener}
  const BlocOneTimeListener({
    Key? key,
    required this.child,
    this.bloc,
    required this.listener,
  }) : super(key: key);

  /// The widget which will be rendered as a descendant of the
  /// [BlocOneTimeListener].
  final Widget child;

  /// The [bloc] whose one-time UI event will be listened to.
  ///
  /// Whenever the [bloc]'s `oneTimeEmit` called, [listener] will be invoked.
  final B? bloc;

  /// The [BlocOneTimeWidgetListener] which will be called on
  /// every `oneTimeEmit` call.
  ///
  /// This [listener] should be used for any code which needs to execute
  /// in response to a `oneTimeEmit` call.
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
