import 'dart:async';

import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/material.dart';

import '../usecase/async_usecase.dart';
import '../usecase/sync_usecase.dart';

class MultiUSTestApp extends StatelessWidget {
  final Function(int) onSyncData;
  final Function(int) onAsyncData;

  const MultiUSTestApp({
    Key? key,
    required this.onSyncData,
    required this.onAsyncData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiUsecaseProvider(
        providers: [
          UsecaseProvider<SyncUsecase>(
            create: (context) => SyncUsecase(),
          ),
          UsecaseProvider<AsyncUsecase>(
            create: (context) => AsyncUsecase(),
            dispose: (value) {
              onAsyncData(-1);
            },
          ),
        ],
        child: Scaffold(
          body: _Child(
            onSyncData: onSyncData,
            onAsyncData: onAsyncData,
          ),
        ),
      ),
    );
  }
}

class _Child extends StatefulWidget {
  final Function(int) onSyncData;
  final Function(int) onAsyncData;

  const _Child({
    Key? key,
    required this.onSyncData,
    required this.onAsyncData,
  }) : super(key: key);

  @override
  State<_Child> createState() => _ChildState();
}

class _ChildState extends State<_Child> {
  late final StreamSubscription<int> _syncSubscription;
  late final StreamSubscription<int> _asyncSubscription;

  @override
  void initState() {
    super.initState();
    final syncUS = UsecaseProvider.of<SyncUsecase>(context);
    final asyncUS = UsecaseProvider.of<AsyncUsecase>(context);
    _syncSubscription = syncUS.stream.listen((widget.onSyncData));
    _asyncSubscription = asyncUS.stream.listen((widget.onAsyncData));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      syncUS.call(1);
      asyncUS.call(2);
    });
  }

  @override
  void dispose() {
    _syncSubscription.cancel();
    _asyncSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
