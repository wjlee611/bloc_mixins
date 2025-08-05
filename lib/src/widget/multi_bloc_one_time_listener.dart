import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// {@template multi_bloc_one_time_listener}
/// Merges multiple [BlocOneTimeListener] widgets into one widget tree.
///
/// [MultiBlocOneTimeListener] improves the readability and eliminates the need
/// to nest multiple [BlocOneTimeListener]s.
///
/// By using [MultiBlocOneTimeListener] we can go from:
///
/// ```dart
/// BlocOneTimeListener<BlocA, BlocAOneTimeEmitEntity>(
///   listener: (context, value) {},
///   child: BlocOneTimeListener<BlocB, BlocBOneTimeEmitEntity>(
///     listener: (context, value) {},
///     child: BlocOneTimeListener<BlocC, BlocCOneTimeEmitEntity>(
///       listener: (context, value) {},
///       child: ChildA(),
///     ),
///   ),
/// )
/// ```
///
/// to:
///
/// ```dart
/// MultiBlocOneTimeListener(
///   listeners: [
///     BlocOneTimeListener<BlocA, BlocAOneTimeEmitEntity>(
///       listener: (context, value) {},
///     ),
///     BlocOneTimeListener<BlocB, BlocBOneTimeEmitEntity>(
///       listener: (context, value) {},
///     ),
///     BlocOneTimeListener<BlocC, BlocCOneTimeEmitEntity>(
///       listener: (context, value) {},
///     ),
///   ],
///   child: ChildA(),
/// )
/// ```
///
/// [MultiBlocOneTimeListener] converts the [BlocOneTimeListener] list into a
/// tree of nested [BlocOneTimeListener] widgets.
/// As a result, the only advantage of using [MultiBlocOneTimeListener] is
/// improved readability due to the reduction in nesting and boilerplate.
/// {@endtemplate}
class MultiBlocOneTimeListener extends MultiProvider {
  /// {@macro multi_bloc_one_time_listener}
  MultiBlocOneTimeListener({
    Key? key,
    required List<BlocOneTimeListener> listeners,
    required Widget child,
  }) : super(key: key, providers: listeners, child: child);
}
