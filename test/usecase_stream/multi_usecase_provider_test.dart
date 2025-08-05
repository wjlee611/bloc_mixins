import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget/multi_us_test_app.dart';

void main() {
  group('MultiUsecaseProvider', () {
    testWidgets('with custom dispose method', (tester) async {
      int syncValue = 0;
      int asyncValue = 0;

      await tester.pumpWidget(
        MultiUSTestApp(
          onSyncData: (value) {
            syncValue = value;
          },
          onAsyncData: (value) {
            asyncValue = value;
          },
        ),
      );

      expect(syncValue, 1);
      expect(asyncValue, 0);

      await tester.pump(Duration(milliseconds: 500));

      expect(syncValue, 1);
      expect(asyncValue, 2);

      await tester.pumpWidget(SizedBox());
      await tester.pumpAndSettle();

      expect(syncValue, 1);
      expect(asyncValue, -1);
    });
  });
}
