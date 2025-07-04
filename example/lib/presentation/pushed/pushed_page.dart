import 'dart:developer';

import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:example/presentation/pushed/cubit/pushed_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PushedPage extends StatelessWidget {
  const PushedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocOneTimeListener<PushedCubit, String>(
      listener: (context, value) {
        log(value);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Pushed Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You have pushed the button this many times:'),
              BlocBuilder<PushedCubit, PushedState>(
                buildWhen: (previous, current) =>
                    previous.count != current.count,
                builder: (context, state) {
                  return Text(
                    '${state.count}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
              TextButton.icon(
                onPressed: () {
                  context.read<PushedCubit>().emitSameUiEvent();
                },
                label: const Text('oneTimeEmit logging sameUiEvent'),
                icon: const Icon(Icons.check),
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<PushedCubit, PushedState>(
          buildWhen: (previous, current) =>
              previous.isLoading != current.isLoading,
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {
                context.read<PushedCubit>().increment();
              },
              tooltip: 'Increment',
              child: Icon(state.isLoading ? Icons.hourglass_empty : Icons.add),
            );
          },
        ),
      ),
    );
  }
}
