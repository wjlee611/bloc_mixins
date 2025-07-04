import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:example/domain/model/home_ui_event_model.dart';
import 'package:example/domain/usecase/add_one_usecase.dart';
import 'package:example/domain/usecase/dispose_test_usecase.dart';
import 'package:example/presentation/home/bloc/home_bloc.dart';
import 'package:example/presentation/pushed/cubit/pushed_cubit.dart';
import 'package:example/presentation/pushed/pushed_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _pushPage(BuildContext context) {
    final state = context.read<HomeBloc>().state;
    if (state.isLoading) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UsecaseProvider(
          lazy: false,
          create: (context) => DisposeTestUsecase(),
          child: BlocProvider(
            create: (context) =>
                PushedCubit(addOneUsecase: context.read<AddOneUsecase>()),
            child: const PushedPage(),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    final bloc = context.read<HomeBloc>();
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
                    const Text('You have pushed the button this many times:'),
                    BlocBuilder<HomeBloc, HomeState>(
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
                  BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (previous, current) =>
                        previous.isLoading != current.isLoading,
                    builder: (context, state) {
                      return TextButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(HomeIncrementEvent());
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

  void _showResetDialog(BuildContext context, HomeDialogModel value) {
    final bloc = context.read<HomeBloc>();
    if (bloc.state.isLoading) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Wow'),
          content: Text(value.content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () {
                bloc.add(value.okEvent);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocOneTimeListener<HomeBloc, HomeUiEventModel>(
      listener: (context, value) {
        switch (value) {
          case HomeSnackBarModel():
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(value.message)));
            break;
          case HomeDialogModel():
            _showResetDialog(context, value);
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Bloc Mixins Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You have pushed the button this many times:'),
              BlocBuilder<HomeBloc, HomeState>(
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
        floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
              previous.isLoading != current.isLoading,
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {
                context.read<HomeBloc>().add(HomeIncrementEvent());
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
