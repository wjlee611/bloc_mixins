import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:example/data/counter_repository.dart';
import 'package:example/domain/add_one_usecase.dart';
import 'package:example/presentation/home/bloc/home_bloc.dart';
import 'package:example/presentation/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CounterRepository(),
      child: UsecaseProvider(
        create: (context) =>
            AddOneUsecase(counterRepository: context.read<CounterRepository>()),
        child: MaterialApp(
          title: 'Bloc Mixins Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: BlocProvider(
            create: (context) =>
                HomeBloc(addOneUsecase: context.read<AddOneUsecase>()),
            child: HomePage(),
          ),
        ),
      ),
    );
  }
}
