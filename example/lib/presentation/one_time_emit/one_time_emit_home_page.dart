import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:example/domain/model/ote_home_ui_event_model.dart';
import 'package:example/presentation/one_time_emit/bloc/ote_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OneTimeEmitHomePage extends StatelessWidget {
  const OneTimeEmitHomePage({super.key});

  void _showDialog(BuildContext context) {
    final bloc = context.read<OTEHomeBloc>();
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
                    BlocBuilder<OTEHomeBloc, OTEHomeState>(
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
                  BlocBuilder<OTEHomeBloc, OTEHomeState>(
                    buildWhen: (previous, current) =>
                        previous.isLoading != current.isLoading,
                    builder: (context, state) {
                      return TextButton(
                        onPressed: () {
                          context.read<OTEHomeBloc>().add(
                            OTEHomeIncrementEvent(),
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

  void _showResetDialog(BuildContext context, OTEHomeDialogModel value) {
    final bloc = context.read<OTEHomeBloc>();
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
    return BlocOneTimeListener<OTEHomeBloc, OTEHomeUiEventModel>(
      listener: (context, value) {
        switch (value) {
          case OTEHomeSnackBarModel():
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(value.message)));
            break;
          case OTEHomeDialogModel():
            _showResetDialog(context, value);
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('OneTimeEmitter Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Count:'),
              BlocBuilder<OTEHomeBloc, OTEHomeState>(
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
                onPressed: () => _showDialog(context),
                label: const Text('Increment from dialog'),
                icon: const Icon(Icons.arrow_circle_up_outlined),
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<OTEHomeBloc, OTEHomeState>(
          buildWhen: (previous, current) =>
              previous.isLoading != current.isLoading,
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {
                context.read<OTEHomeBloc>().add(OTEHomeIncrementEvent());
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
