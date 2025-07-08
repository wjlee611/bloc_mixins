import 'package:flutter_test/flutter_test.dart';

import 'bloc/ote_bloc.dart';
import 'widget/multiple_bloc_provider_app.dart';
import 'widget/single_bloc_injected_app.dart';

void main() {
  group('BlocOneTimeListener, bloc injected', () {
    late OTEBloc oteBloc;

    setUpAll(() {
      oteBloc = OTEBloc();
    });

    tearDownAll(() {
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
  });
}
