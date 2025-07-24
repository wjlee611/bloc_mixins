import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter_test/flutter_test.dart';

import 'bloc/ote_bloc.dart';
import 'widget/multiple_bloc_provider_app.dart';
import 'widget/single_bloc_injected_app.dart';

void main() {
  group('BlocOneTimeListener', () {
    late OTEBloc oteBloc;

    setUp(() {
      oteBloc = OTEBloc();
    });

    tearDown(() {
      oteBloc.close();
    });

    testWidgets('listen single event', (tester) async {
      int eventCount = 0;
      String? emittedValue;

      await tester.pumpWidget(
        SingleBlocInjectedApp(
          listener: (context, value) {
            emittedValue = value;
            eventCount++;
          },
        ),
      );

      await tester.tap(find.text('OTEOpenDialogEvent'));
      await tester.pump();
      expect(eventCount, 1);
      expect(emittedValue, oneTimeEmitValue);
    });

    testWidgets('listen 100 event', (tester) async {
      int eventCount = 0;
      String? emittedValue;

      await tester.pumpWidget(
        SingleBlocInjectedApp(
          listener: (context, value) {
            emittedValue = value;
            eventCount++;
          },
        ),
      );

      for (var i = 0; i < 100; i++) {
        await tester.tap(find.text('OTEOpenDialogEvent'));
        await tester.pump();
        expect(eventCount, i + 1);
        expect(emittedValue, oneTimeEmitValue);
      }
    });

    testWidgets('replacement bloc', (tester) async {
      int eventCount = 0;
      String? emittedValue;

      await tester.pumpWidget(
        SingleBlocInjectedApp(
          listener: (context, value) {
            emittedValue = value;
            eventCount++;
          },
        ),
      );

      await tester.tap(find.text('OTEOpenDialogEvent'));
      await tester.pump();
      expect(eventCount, 1);
      expect(emittedValue, oneTimeEmitValue);

      await tester.tap(find.text('Reset'));
      await tester.pump();
      expect(eventCount, 1);
      expect(emittedValue, oneTimeEmitValue);

      await tester.tap(find.text('OTEOpenDialogEvent'));
      await tester.pump();
      expect(eventCount, 2);
      expect(emittedValue, oneTimeEmitValue);
    });

    testWidgets('rebuild', (tester) async {
      int eventCount = 0;
      String? emittedValue;

      await tester.pumpWidget(
        SingleBlocInjectedApp(
          listener: (context, value) {
            emittedValue = value;
            eventCount++;
          },
        ),
      );

      await tester.tap(find.text('OTEOpenDialogEvent'));
      await tester.pump();
      expect(eventCount, 1);
      expect(emittedValue, oneTimeEmitValue);

      await tester.tap(find.text('Rebuild'));
      await tester.pump();
      expect(eventCount, 1);
      expect(emittedValue, oneTimeEmitValue);

      await tester.tap(find.text('OTEOpenDialogEvent'));
      await tester.pump();
      expect(eventCount, 2);
      expect(emittedValue, oneTimeEmitValue);
    });

    testWidgets('switching blocs for change dependencies', (tester) async {
      int eventCount = 0;
      List<String> emittedValues = [];

      await tester.pumpWidget(
        MultipleBlocProviderApp(
          listener: (context, value) {
            emittedValues.add(value);
            eventCount++;
          },
        ),
      );

      await tester.tap(find.text('Trigger Current Bloc Event'));
      await tester.pump();
      expect(eventCount, 1);
      expect(emittedValues.last, oneTimeEmitValue);

      await tester.tap(find.text('Use Bloc 2'));
      await tester.pump();

      await tester.tap(find.text('Trigger Current Bloc Event'));
      await tester.pump();
      expect(eventCount, 2);
      expect(emittedValues.last, oneTimeEmitValue);

      await tester.tap(find.text('Use Bloc 3'));
      await tester.pump();

      await tester.tap(find.text('Trigger Current Bloc Event'));
      await tester.pump();
      expect(eventCount, 3);
      expect(emittedValues.last, oneTimeEmitValue);

      await tester.tap(find.text('Use Bloc 1'));
      await tester.pump();

      await tester.tap(find.text('Trigger Current Bloc Event'));
      await tester.pump();
      expect(eventCount, 4);
      expect(emittedValues.last, oneTimeEmitValue);
    });

    testWidgets(
        'throws AssertionError '
        'when child is not specified', (tester) async {
      const expected =
          '''BlocOneTimeListener<OTEBloc, String> used outside of MultiBlocOneTimeListener must specify a child''';
      await tester.pumpWidget(
        BlocOneTimeListener<OTEBloc, String>(
          bloc: oteBloc,
          listener: (context, state) {},
        ),
      );
      expect(
        tester.takeException(),
        isA<AssertionError>().having((e) => e.message, 'message', expected),
      );
    });
  });
}
