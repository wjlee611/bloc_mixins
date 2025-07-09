import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:example/data/counter_repository.dart';
import 'package:example/domain/usecase/add_one_usecase.dart';
import 'package:example/presentation/one_time_emit/bloc/ote_home_bloc.dart';
import 'package:example/presentation/one_time_emit/one_time_emit_home_page.dart';
import 'package:example/presentation/usecase_stream/bloc/us_home_bloc.dart';
import 'package:example/presentation/usecase_stream/usecase_stream_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CounterRepository(),
      child: MaterialApp(
        title: 'Bloc Mixins Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: ExampleRoute(),
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
                      child: const OneTimeEmitHomePage(),
                    ),
                  ),
                );
              },
              child: const Text('OneTimeEmit Example'),
            ),
          ],
        ),
      ),
    );
  }
}
