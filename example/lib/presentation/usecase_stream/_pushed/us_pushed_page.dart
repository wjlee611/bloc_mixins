import 'package:example/presentation/usecase_stream/_pushed/cubit/us_pushed_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class USPushedPage extends StatelessWidget {
  const USPushedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pushed Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Count:'),
            BlocBuilder<USPushedCubit, USPushedState>(
              buildWhen: (previous, current) => previous.count != current.count,
              builder: (context, state) {
                return Text(
                  '${state.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<USPushedCubit, USPushedState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              context.read<USPushedCubit>().increment();
            },
            tooltip: 'Increment',
            child: Icon(state.isLoading ? Icons.hourglass_empty : Icons.add),
          );
        },
      ),
    );
  }
}
