import 'package:flutter_test/flutter_test.dart';

import 'bloc/us_bloc.dart';
import 'bloc/us_cubit.dart';
import 'usecase/sync_usecase.dart';

void main() {
  Future<void> tick() => Future<void>.delayed(Duration.zero);

  group('UsecaseStream', () {
    late SyncUsecase syncUsecase;
    late USBloc usBloc;
    late USCubit usCubit;

    setUp(() {
      syncUsecase = SyncUsecase();
      usBloc = USBloc(syncUsecase);
      usCubit = USCubit(syncUsecase);
    });

    tearDown(() {
      usBloc.close();
      usCubit.close();
      syncUsecase.close();
    });

    test('emit once from bloc', () {
      expect(usBloc.state.value, 0);
      expect(usCubit.state, 0);
      expectLater(
        usBloc.stream,
        emitsInOrder([isA<USState>().having((s) => s.value, 'value', 1)]),
      );
      expectLater(usCubit.stream, emitsInOrder([1]));

      usBloc.add(USSyncEvent(1));
    });

    test('emit once from cubit', () {
      expect(usBloc.state.value, 0);
      expect(usCubit.state, 0);
      expectLater(
        usBloc.stream,
        emitsInOrder([isA<USState>().having((s) => s.value, 'value', 1)]),
      );
      expectLater(usCubit.stream, emitsInOrder([1]));

      usCubit.syncValue(1);
    });

    test('emit 100 from bloc', () {
      expect(usBloc.state.value, 0);
      expect(usCubit.state, 0);
      expectLater(
        usBloc.stream,
        emitsInOrder([
          for (var value in List.generate(100, (index) => index + 1))
            isA<USState>().having((s) => s.value, 'value', value),
        ]),
      );
      expectLater(
        usCubit.stream,
        emitsInOrder([
          for (var value in List.generate(100, (index) => index + 1)) value,
        ]),
      );

      for (var value in List.generate(100, (index) => index + 1)) {
        usBloc.add(USSyncEvent(value));
      }
    });

    test('emit 100 from cubit', () {
      expect(usBloc.state.value, 0);
      expect(usCubit.state, 0);
      expectLater(
        usBloc.stream,
        emitsInOrder([
          for (var value in List.generate(100, (index) => index + 1))
            isA<USState>().having((s) => s.value, 'value', value),
        ]),
      );
      expectLater(
        usCubit.stream,
        emitsInOrder([
          for (var value in List.generate(100, (index) => index + 1)) value,
        ]),
      );

      for (var value in List.generate(100, (index) => index + 1)) {
        usCubit.syncValue(value);
      }
    });
  });

  group('UsecaseStream late init and closable', () {
    test('late init bloc', () async {
      final syncUsecase = SyncUsecase();
      final usBloc = USBloc(syncUsecase);
      expect(usBloc.state.value, 0);

      usBloc.add(USSyncEvent(1));
      await tick();
      expect(usBloc.state.value, 1);

      var usCubit = USCubit(syncUsecase);
      expect(usCubit.state, 1);

      usCubit.syncValue(2);
      await tick();
      expect(usBloc.state.value, 2);
      expect(usCubit.state, 2);

      usCubit.close();
      syncUsecase.result = 0;
      await tick();
      usCubit = USCubit(syncUsecase);
      expect(usCubit.state, 0);

      usBloc.add(USSyncEvent(3));
      await tick();
      expect(usBloc.state.value, 3);
      expect(usCubit.state, 3);

      usBloc.close();
      usCubit.close();
      syncUsecase.close();
      await tick();
      expect(syncUsecase.isClosed, true);
      expect(usBloc.isClosed, true);
      expect(usCubit.isClosed, true);
    });
  });
}
