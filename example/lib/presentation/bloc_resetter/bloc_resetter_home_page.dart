import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:example/presentation/bloc_resetter/bloc/global_bloc.dart';
import 'package:example/presentation/bloc_resetter/bloc/local_bloc.dart';
import 'package:example/widget/registered_blocs_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocResetterHomePage extends StatelessWidget {
  const BlocResetterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('BlocResetter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<GlobalBloc, GlobalState>(
              builder: (context, state) {
                return Text(
                  '$state',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            BlocBuilder<LocalCubit, LocalState>(
              builder: (context, state) {
                return Text(
                  '$state',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            TextButton.icon(
              onPressed: () {
                BlocResetRegistry.resetBlocs();
              },
              label: const Text('Reset'),
              icon: const Icon(Icons.clear_all),
            ),
            SizedBox(height: 20),
            RegisteredBlocsCounter(),
          ],
        ),
      ),
    );
  }
}
