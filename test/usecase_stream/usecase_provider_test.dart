import 'package:flutter_test/flutter_test.dart';

import 'usecase/sync_usecase.dart';
import 'widget/us_test_app.dart';

void main() {
  group('UsecaseProvider', () {
    testWidgets('provide (create)', (tester) async {
      final syncUsecase = SyncUsecase();

      await tester.pumpWidget(
        USTestApp(syncUsecase: syncUsecase, isProvide: true),
      );

      await tester.tap(find.text('Push Page'));
      await tester.pumpAndSettle();
      expect(find.text('Pop Page'), findsOneWidget);

      await tester.tap(find.text('Pop Page'));
      await tester.pumpAndSettle();
      expect(find.text('Push Page'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(syncUsecase.isClosed, true);
    });

    testWidgets('inject (value)', (tester) async {
      final syncUsecase = SyncUsecase();

      await tester.pumpWidget(
        USTestApp(syncUsecase: syncUsecase, isProvide: false),
      );

      await tester.tap(find.text('Push Page'));
      await tester.pumpAndSettle();
      expect(find.text('Pop Page'), findsOneWidget);

      await tester.tap(find.text('Pop Page'));
      await tester.pumpAndSettle();
      expect(find.text('Push Page'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(syncUsecase.isClosed, false);
    });
  });
}
