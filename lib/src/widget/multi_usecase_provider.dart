import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// {@template multi_usecase_provider}
/// Merges multiple [UsecaseProvider] widgets into one widget tree.
///
/// [MultiUsecaseProvider] improves the readability and eliminates the need
/// to nest multiple [UsecaseProvider]s.
///
/// By using [MultiUsecaseProvider] we can go from:
///
/// ```dart
/// UsecaseProvider<UsecaseA>(
///   create: (context) => UsecaseA(),
///   child: UsecaseProvider<UsecaseB>(
///     create: (context) => UsecaseB(),
///     child: UsecaseProvider<UsecaseC>(
///       create: (context) => UsecaseC(),
///       child: ChildA(),
///     )
///   )
/// )
/// ```
///
/// to:
///
/// ```dart
/// MultiUsecaseProvider(
///   providers: [
///     UsecaseProvider<UsecaseA>(create: (context) => UsecaseA()),
///     UsecaseProvider<UsecaseB>(create: (context) => UsecaseB()),
///     UsecaseProvider<UsecaseC>(create: (context) => UsecaseC()),
///   ],
///   child: ChildA(),
/// )
/// ```
///
/// [MultiUsecaseProvider] converts the [UsecaseProvider] list into a tree
/// of nested [UsecaseProvider] widgets.
/// As a result, the only advantage of using [MultiUsecaseProvider] is
/// improved readability due to the reduction in nesting and boilerplate.
/// {@endtemplate}
class MultiUsecaseProvider extends MultiProvider {
  /// {@macro multi_usecase_provider}
  MultiUsecaseProvider({
    required List<UsecaseProvider> providers,
    required Widget child,
    Key? key,
  }) : super(key: key, providers: providers, child: child);
}
