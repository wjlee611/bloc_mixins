import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:example/domain/add_one_usecase.dart';
import 'package:example/domain/dispose_test_usecase.dart';
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
        builder: (context) => BlocMixinsUsecaseProvider(
          lazy: false,
          create: (context) => DisposeTestUsecase(),
          child: BlocProvider(
            create: (context) => PushedCubit(
              initialCount: state.count,
              addOneUsecase: context.read<AddOneUsecase>(),
            ),
            child: const PushedPage(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
