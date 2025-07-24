import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:example/core/config/bloc/config_bloc.dart';
import 'package:example/presentation/bloc_resetter/bloc/global_bloc.dart';
import 'package:example/data/counter_repository.dart';
import 'package:example/domain/usecase/add_one_usecase.dart';
import 'package:example/presentation/bloc_resetter/bloc/local_bloc.dart';
import 'package:example/presentation/bloc_resetter/bloc_resetter_home_page.dart';
import 'package:example/presentation/multi_one_time_emitter/bloc/multi_ote_home_bloc.dart';
import 'package:example/presentation/multi_one_time_emitter/bloc/multi_ote_home_cubit.dart';
import 'package:example/presentation/multi_one_time_emitter/multi_one_time_emitter_home_page.dart';
import 'package:example/presentation/one_time_emitter/bloc/ote_home_bloc.dart';
import 'package:example/presentation/one_time_emitter/one_time_emitter_home_page.dart';
import 'package:example/presentation/usecase_stream/bloc/us_home_bloc.dart';
import 'package:example/presentation/usecase_stream/usecase_stream_home_page.dart';
import 'package:example/widget/registered_blocs_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  ConfigBloc();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CounterRepository(),
      child: BlocProvider(
        create: (context) => GlobalBloc(),
        child: BlocBuilder<ConfigBloc, ConfigState>(
          bloc: BlocResetRegistry.get<ConfigBloc>(),
          builder: (context, state) {
            return MaterialApp(
              title: 'Bloc Mixins Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: state is! ConfigLoadedState
                      ? Colors.deepPurple
                      : state.seedColor,
                ),
              ),
              home: ExampleRoute(),
            );
          },
        ),
      ),
    );
  }
}

class ExampleRoute extends StatelessWidget {
  const ExampleRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Bloc Mixins Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsecaseProvider(
                      create: (context) => AddOneUsecase(
                        counterRepository: context.read<CounterRepository>(),
                      ),
                      child: BlocProvider(
                        create: (context) => USHomeBloc(
                          addOneUsecase: context.read<AddOneUsecase>(),
                        ),
                        child: const UsecaseStreamHomePage(),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('UsecaseStream Example'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => OTEHomeBloc(
                        counterRepository: context.read<CounterRepository>(),
                      ),
                      child: const OneTimeEmitterHomePage(),
                    ),
                  ),
                );
              },
              child: const Text('OneTimeEmitter Example'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(create: (context) => MultiOTEHomeBloc()),
                        BlocProvider(create: (context) => MultiOTEHomeCubit()),
                      ],
                      child: const MultiOneTimeEmitterHomePage(),
                    ),
                  ),
                );
              },
              child: const Text('Multi OneTimeEmitter Example'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => LocalCubit(),
                      child: BlocResetterHomePage(),
                    ),
                  ),
                );
              },
              child: const Text('InitStateResetter Example'),
            ),
            SizedBox(height: 4),
            RegisteredBlocsCounter(),
          ],
        ),
      ),
    );
  }
}
