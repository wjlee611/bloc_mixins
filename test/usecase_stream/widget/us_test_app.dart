import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/material.dart';

import '../usecase/sync_usecase.dart';

class USTestApp extends StatelessWidget {
  final bool isProvide;
  final SyncUsecase syncUsecase;
  final Function(String)? thrownMessage;

  const USTestApp({
    Key? key,
    required this.syncUsecase,
    this.isProvide = false,
    this.thrownMessage,
  }) : super(key: key);

  void _pushPage(BuildContext context) {
    if (thrownMessage != null) {
      try {
        UsecaseProvider.of<SyncUsecase>(context);
      } catch (e) {
        thrownMessage!.call(e.toString());
      }
      return;
    }
    if (isProvide) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UsecaseProvider(
            lazy: false,
            create: (context) => syncUsecase,
            child: const PushPage(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UsecaseProvider.value(
            value: syncUsecase,
            child: const PushPage(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => _pushPage(context),
                child: const Text('Push Page'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PushPage extends StatelessWidget {
  const PushPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Push Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Pop Page'),
        ),
      ),
    );
  }
}
