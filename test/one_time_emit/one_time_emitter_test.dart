// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'bloc/ote_bloc.dart' as b;
import 'bloc/ote_cubit.dart' as c;

void main() {
  group('bloc_test', () {
    late b.OTEBloc oteBloc;

    setUpAll(() {
      oteBloc = b.OTEBloc();
    });

    tearDownAll(() {
      oteBloc.close();
    });

    test('oneTimeEmit once', () {
      expect(oteBloc.state, isA<b.OTEState>());
      expectLater(oteBloc.oneTimeStream, emitsInOrder([b.oneTimeEmitValue]));

      oteBloc.add(b.OTEOpenDialogEvent());
    }, timeout: const Timeout(Duration(seconds: 1)));

    test('oneTimeEmit 100', () {
      expect(oteBloc.state, isA<b.OTEState>());
      expectLater(
        oteBloc.oneTimeStream,
        emitsInOrder([
          for (var _ in List.generate(100, (index) => b.oneTimeEmitValue))
            b.oneTimeEmitValue,
        ]),
      );

      for (var _ in List.generate(100, (index) => b.oneTimeEmitValue)) {
        oteBloc.add(b.OTEOpenDialogEvent());
      }
    }, timeout: const Timeout(Duration(seconds: 1)));

    test('oneTimeEmit after close', () async {
      expect(oteBloc.state, isA<b.OTEState>());

      // Completer resolves when the stream is done(closed)
      final completer = Completer<void>();
      final subscription = oteBloc.oneTimeStream.listen(
        (event) {
          expect(event, b.oneTimeEmitValue);
        },
        onDone: () {
          completer.complete();
        },
      );

      oteBloc.add(b.OTEOpenDialogEvent());
      await oteBloc.close();

      // After closing the bloc
      completer.future.then((_) {
        subscription.cancel();
        expect(oteBloc.oneTimeStream, emitsDone);
        try {
          oteBloc.add(b.OTEOpenDialogEvent());
          // Do not reach here
          expect(false, true);
        } catch (e) {
          expect(e, isA<StateError>());
        } finally {
          expect(oteBloc.isClosed, true);
          expect(oteBloc.stream, emitsDone);
          expect(oteBloc.oneTimeStream, emitsDone);
        }
      });
    }, timeout: const Timeout(Duration(seconds: 1)));
  });

  group('cubit_test', () {
    late c.OTECubit oteCubit;

    setUpAll(() {
      oteCubit = c.OTECubit();
    });

    tearDownAll(() {
      oteCubit.close();
    });

    test('oneTimeEmit once', () {
      expect(oteCubit.state, isA<c.OTEState>());
      expectLater(oteCubit.oneTimeStream, emitsInOrder([c.oneTimeEmitValue]));

      oteCubit.openDialog();
    }, timeout: const Timeout(Duration(seconds: 1)));

    test('oneTimeEmit 100', () {
      expect(oteCubit.state, isA<c.OTEState>());
      expectLater(
        oteCubit.oneTimeStream,
        emitsInOrder([
          for (var _ in List.generate(100, (index) => c.oneTimeEmitValue))
            c.oneTimeEmitValue,
        ]),
      );

      for (var _ in List.generate(100, (index) => c.oneTimeEmitValue)) {
        oteCubit.openDialog();
      }
    }, timeout: const Timeout(Duration(seconds: 1)));

    test('oneTimeEmit after close', () async {
      expect(oteCubit.state, isA<c.OTEState>());

      // Completer resolves when the stream is done(closed)
      final completer = Completer<void>();
      final subscription = oteCubit.oneTimeStream.listen(
        (event) {
          expect(event, c.oneTimeEmitValue);
        },
        onDone: () {
          completer.complete();
        },
      );

      oteCubit.openDialog();
      await oteCubit.close();

      // After closing the cubit
      completer.future.then((_) {
        subscription.cancel();
        expect(oteCubit.oneTimeStream, emitsDone);
        try {
          oteCubit.openDialog();
          // reach here
        } catch (e) {
          expect(false, true);
        } finally {
          expect(oteCubit.isClosed, true);
          expect(oteCubit.stream, emitsDone);
          expect(oteCubit.oneTimeStream, emitsDone);
        }
      });
    }, timeout: const Timeout(Duration(seconds: 1)));
  });
}
