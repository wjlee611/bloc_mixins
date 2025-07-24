import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/br_global_auto_cubit.dart';
import '../bloc/br_local_bloc.dart';
import '../bloc/br_main_auto_bloc.dart';

class BlocResetTestApp extends StatelessWidget {
  const BlocResetTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BRGlobalAutoCubit(),
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    key: const Key('push_button'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => BRLocalBloc(),
                            child: _PushedPage(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Push'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PushedPage extends StatelessWidget {
  const _PushedPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<BRMainAutoBloc, BRMainAutoState>(
            bloc: BlocResetRegistry.get<BRMainAutoBloc>(),
            builder: (context, state) {
              return Text(
                '$state',
                style: Theme.of(context).textTheme.headlineMedium,
              );
            },
          ),
          BlocBuilder<BRGlobalAutoCubit, BRGlobalAutoState>(
            builder: (context, state) {
              return Text(
                '$state',
                style: Theme.of(context).textTheme.headlineMedium,
              );
            },
          ),
          BlocBuilder<BRLocalBloc, BRLocalState>(
            builder: (context, state) {
              return Text(
                '$state',
                style: Theme.of(context).textTheme.headlineMedium,
              );
            },
          ),
          TextButton.icon(
            key: const Key('emit_button'),
            onPressed: () {
              context.read<BRLocalBloc>().add(BRLocalLoadEvent());
            },
            label: const Text('Reset'),
            icon: const Icon(Icons.clear_all),
          ),
          TextButton.icon(
            key: const Key('reset_button'),
            onPressed: () {
              BlocResetRegistry.resetBlocs();
            },
            label: const Text('Reset'),
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
    );
  }
}
