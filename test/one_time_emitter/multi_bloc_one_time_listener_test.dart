import 'package:flutter_test/flutter_test.dart';

import 'bloc/ote_bloc.dart' as b;
import 'bloc/ote_cubit.dart' as c;
import 'widget/bloc_cubit_injected_app.dart';

void main() {
  group('MultiBlocOneTimeListener', () {
    testWidgets('listen single event', (tester) async {
      int blocEventCount = 0;
      String? blocEmittedValue;
      int cubitEventCount = 0;
      String? cubitEmittedValue;

      await tester.pumpWidget(BlocCubitInjectedApp(
        blocListener: (context, value) {
          blocEmittedValue = value;
          blocEventCount++;
        },
        cubitListener: (context, value) {
          cubitEmittedValue = value;
          cubitEventCount++;
        },
      ));

      await tester.tap(find.text('OTEOpenDialogEvent'));
      await tester.pump();
      expect(blocEventCount, 1);
      expect(cubitEventCount, 1);
      expect(blocEmittedValue, b.oneTimeEmitValue);
      expect(cubitEmittedValue, c.oneTimeEmitValue);
    });

    testWidgets('listen 100 event', (tester) async {
      int blocEventCount = 0;
      String? blocEmittedValue;
      int cubitEventCount = 0;
      String? cubitEmittedValue;

      await tester.pumpWidget(BlocCubitInjectedApp(
        blocListener: (context, value) {
          blocEmittedValue = value;
          blocEventCount++;
        },
        cubitListener: (context, value) {
          cubitEmittedValue = value;
          cubitEventCount++;
        },
      ));

      for (var i = 0; i < 100; i++) {
        await tester.tap(find.text('OTEOpenDialogEvent'));
        await tester.pump();
        expect(blocEventCount, i + 1);
        expect(blocEmittedValue, b.oneTimeEmitValue);
        expect(cubitEventCount, i + 1);
        expect(cubitEmittedValue, c.oneTimeEmitValue);
      }
    });
  });
}
