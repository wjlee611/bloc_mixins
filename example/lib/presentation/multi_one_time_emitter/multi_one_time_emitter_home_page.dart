import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:example/presentation/multi_one_time_emitter/bloc/multi_ote_home_bloc.dart';
import 'package:example/presentation/multi_one_time_emitter/bloc/multi_ote_home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiOneTimeEmitterHomePage extends StatefulWidget {
  const MultiOneTimeEmitterHomePage({super.key});

  @override
  State<MultiOneTimeEmitterHomePage> createState() =>
      _MultiOneTimeEmitterHomePageState();
}

class _MultiOneTimeEmitterHomePageState
    extends State<MultiOneTimeEmitterHomePage> {
  int _valueFromBloc = 0;
  int _valueFromCubit = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocOneTimeListener(
      listeners: [
        BlocOneTimeListener<MultiOTEHomeBloc, int>(
          listener: (context, value) {
            setState(() {
              _valueFromBloc = value;
            });
          },
        ),
        BlocOneTimeListener<MultiOTEHomeCubit, int>(
          listener: (context, value) {
            setState(() {
              _valueFromCubit = value;
            });
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Multi OneTimeEmitter Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<MultiOTEHomeBloc>().add(
                    MultiOTEHomeIncrementEvent(),
                  );
                },
                child: Text(
                  'Tap to increment count from bloc: $_valueFromBloc',
                ),
              ),
              SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {
                  context.read<MultiOTEHomeCubit>().increment();
                },
                child: Text(
                  'Tap to increment count from cubit: $_valueFromCubit',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Sum: ${_valueFromBloc + _valueFromCubit}',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
