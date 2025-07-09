import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:example/domain/usecase/add_one_usecase.dart';
import 'package:example/domain/usecase/dispose_test_usecase.dart';
import 'package:example/presentation/usecase_stream/_pushed/cubit/us_pushed_cubit.dart';
import 'package:example/presentation/usecase_stream/_pushed/us_pushed_page.dart';
import 'package:example/presentation/usecase_stream/bloc/us_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsecaseStreamHomePage extends StatelessWidget {
  const UsecaseStreamHomePage({super.key});

  void _pushPage(BuildContext context) {
    final state = context.read<USHomeBloc>().state;
    final usecase = context.read<AddOneUsecase>();
    if (state.isLoading) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UsecaseProvider(
          lazy: false,
          create: (context) => DisposeTestUsecase(),
          child: BlocProvider(
            create: (context) => USPushedCubit(addOneUsecase: usecase),
            child: const USPushedPage(),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    final bloc = context.read<USHomeBloc>();
    if (bloc.state.isLoading) return;
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: Builder(
            builder: (context) {
              return AlertDialog(
                title: const Text('Dialog'),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Count:'),
                    BlocBuilder<USHomeBloc, USHomeState>(
                      buildWhen: (previous, current) =>
                          previous.count != current.count,
                      builder: (context, state) {
                        return Text(
                          '${state.count}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        );
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  BlocBuilder<USHomeBloc, USHomeState>(
                    buildWhen: (previous, current) =>
                        previous.isLoading != current.isLoading,
                    builder: (context, state) {
                      return TextButton(
                        onPressed: () {
                          context.read<USHomeBloc>().add(
                            USHomeIncrementEvent(),
                          );
                        },
                        child: Text(
                          state.isLoading ? 'Loading...' : 'Increment',
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('UsecaseStream Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Count:'),
            BlocBuilder<USHomeBloc, USHomeState>(
              buildWhen: (previous, current) => previous.count != current.count,
              builder: (context, state) {
                return Text(
                  '${state.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            TextButton.icon(
              onPressed: () => _pushPage(context),
              label: const Text('Increment from other page'),
              icon: const Icon(Icons.arrow_circle_right_outlined),
            ),
            TextButton.icon(
              onPressed: () => _showDialog(context),
              label: const Text('Increment from dialog'),
              icon: const Icon(Icons.arrow_circle_up_outlined),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<USHomeBloc, USHomeState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              context.read<USHomeBloc>().add(USHomeIncrementEvent());
            },
            tooltip: 'Increment',
            child: Icon(state.isLoading ? Icons.hourglass_empty : Icons.add),
          );
        },
      ),
    );
  }
}
