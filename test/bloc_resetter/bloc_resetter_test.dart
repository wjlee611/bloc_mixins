import 'package:flutter_test/flutter_test.dart';

import 'bloc/br_global_auto_cubit.dart';
import 'bloc/br_local_bloc.dart';
import 'bloc/br_main_auto_bloc.dart';

void main() {
  Future<void> tick() => Future<void>.delayed(Duration.zero);
  Future<void> wait() => Future<void>.delayed(Duration(milliseconds: 50));

  group('BlocResetter bloc with no auto emitted event', () {
    late BRLocalBloc brLocalBloc;

    setUp(() {
      brLocalBloc = BRLocalBloc();
    });

    tearDown(() {
      brLocalBloc.close();
    });

    test('just reset', () async {
      expect(brLocalBloc.state, BRLocalInitialState());
      expectLater(brLocalBloc.stream, emitsInOrder([BRLocalInitialState()]));

      await wait();
      brLocalBloc.reset();
      await wait();
    });

    test('load and reset', () async {
      expect(brLocalBloc.state, BRLocalInitialState());
      expectLater(
        brLocalBloc.stream,
        emitsInOrder([
          BRLocalLoadingState(),
          BRLocalLoadedState(),
          BRLocalInitialState(),
        ]),
      );

      await wait();
      brLocalBloc.add(BRLocalLoadEvent());
      await wait();
      brLocalBloc.reset();
      await wait();
    });

    test('close', () async {
      expect(brLocalBloc.state, BRLocalInitialState());
      await wait();
      brLocalBloc.close();
      await tick();
      expect(brLocalBloc.isClosed, true);
    });
  });

  group('BlocResetter bloc with auto emitted event', () {
    late BRMainAutoBloc brMainAutoBloc;

    setUp(() {
      brMainAutoBloc = BRMainAutoBloc();
    });

    tearDown(() {
      brMainAutoBloc.close();
    });

    test('just reset', () async {
      expect(brMainAutoBloc.state, BRMainAutoInitialState());
      expectLater(
        brMainAutoBloc.stream,
        emitsInOrder([
          BRMainAutoLoadingState(),
          BRMainAutoLoadedState(),

          BRMainAutoInitialState(),
          BRMainAutoLoadingState(),
          BRMainAutoLoadedState(),
        ]),
      );

      await wait();
      brMainAutoBloc.reset();
      await wait();
    });

    test('load and reset', () async {
      expect(brMainAutoBloc.state, BRMainAutoInitialState());
      expectLater(
        brMainAutoBloc.stream,
        emitsInOrder([
          BRMainAutoLoadingState(),
          BRMainAutoLoadedState(),

          BRMainAutoLoadingState(),
          BRMainAutoLoadedState(),

          BRMainAutoInitialState(),
          BRMainAutoLoadingState(),
          BRMainAutoLoadedState(),
        ]),
      );

      await wait();
      brMainAutoBloc.add(BRMainAutoLoadEvent());
      await wait();
      brMainAutoBloc.reset();
      await wait();
    });

    test('close', () async {
      expect(brMainAutoBloc.state, BRMainAutoInitialState());
      await wait();
      brMainAutoBloc.close();
      await tick();
      expect(brMainAutoBloc.isClosed, true);
    });
  });

  group('BlocResetter cubit with auto emitted event', () {
    late BRGlobalAutoCubit brGlobalAutoCubit;

    setUp(() {
      brGlobalAutoCubit = BRGlobalAutoCubit();
    });

    tearDown(() {
      brGlobalAutoCubit.close();
    });

    test('just reset', () async {
      expect(brGlobalAutoCubit.state, BRGlobalAutoInitialState());
      expectLater(
        brGlobalAutoCubit.stream,
        emitsInOrder([
          BRGlobalAutoLoadingState(),
          BRGlobalAutoLoadedState(),

          BRGlobalAutoInitialState(),
          BRGlobalAutoLoadingState(),
          BRGlobalAutoLoadedState(),
        ]),
      );

      await wait();
      brGlobalAutoCubit.reset();
      await wait();
    });

    test('load and reset', () async {
      expect(brGlobalAutoCubit.state, BRGlobalAutoInitialState());
      expectLater(
        brGlobalAutoCubit.stream,
        emitsInOrder([
          BRGlobalAutoLoadingState(),
          BRGlobalAutoLoadedState(),

          BRGlobalAutoLoadingState(),
          BRGlobalAutoLoadedState(),

          BRGlobalAutoInitialState(),
          BRGlobalAutoLoadingState(),
          BRGlobalAutoLoadedState(),
        ]),
      );

      await wait();
      brGlobalAutoCubit.load();
      await wait();
      brGlobalAutoCubit.reset();
      await wait();
    });

    test('close', () async {
      expect(brGlobalAutoCubit.state, BRGlobalAutoInitialState());
      await wait();
      brGlobalAutoCubit.close();
      await tick();
      expect(brGlobalAutoCubit.isClosed, true);
    });
  });
}
