import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'bloc/br_global_auto_cubit.dart';
import 'bloc/br_local_bloc.dart';
import 'bloc/br_main_auto_bloc.dart';
import 'widget/bloc_reset_test_app.dart';

void main() {
  group('BlocResetRegistry', () {
    late final Finder pushButton;
    late final Finder emitButton;
    late final Finder resetButton;

    setUpAll(() {
      BlocResetRegistry.getAll().forEach((bloc) {
        BlocResetRegistry.removeBloc(bloc);
      });
    });

    testWidgets('complete test', (tester) async {
      // Init static-like bloc for register BlocResetRegistry
      BRMainAutoBloc();

      // Build first page
      await tester.pumpWidget(BlocResetTestApp());
      await tester.pumpAndSettle();
      pushButton = find.byKey(const Key('push_button'));
      // [BRMainAutoBloc]
      expect(BlocResetRegistry.registeredBlocCount, 1);

      // Tap push button
      await tester.tap(pushButton);
      await tester.pump();

      // Build first frame of pushed page
      await tester.pump(Duration.zero);
      emitButton = find.byKey(const Key('emit_button'));
      resetButton = find.byKey(const Key('reset_button'));
      // [BRMainAutoBloc, BRGlobalAutoCubit, BRLocalBloc]
      expect(BlocResetRegistry.registeredBlocCount, 3);
      expect(find.text('BRMainAutoLoadedState'), findsOneWidget);
      expect(find.text('BRGlobalAutoLoadingState'), findsOneWidget);
      expect(find.text('BRLocalInitialState'), findsOneWidget);

      // Check for loaded
      await tester.pump(Duration(milliseconds: 30));
      expect(find.text('BRMainAutoLoadedState'), findsOneWidget);
      expect(find.text('BRGlobalAutoLoadedState'), findsOneWidget);
      expect(find.text('BRLocalInitialState'), findsOneWidget);

      // Tap emit button
      await tester.tap(emitButton);
      await tester.pump();

      // Build next frame
      await tester.pump(Duration.zero);
      expect(find.text('BRMainAutoLoadedState'), findsOneWidget);
      expect(find.text('BRGlobalAutoLoadedState'), findsOneWidget);
      expect(find.text('BRLocalLoadingState'), findsOneWidget);

      // Check for loaded
      await tester.pump(Duration(milliseconds: 30));
      expect(find.text('BRMainAutoLoadedState'), findsOneWidget);
      expect(find.text('BRGlobalAutoLoadedState'), findsOneWidget);
      expect(find.text('BRLocalLoadedState'), findsOneWidget);

      // Tap reset button
      await tester.tap(resetButton);
      await tester.pump();

      expect(find.text('BRMainAutoInitialState'), findsOneWidget);
      expect(find.text('BRGlobalAutoInitialState'), findsOneWidget);
      expect(find.text('BRLocalInitialState'), findsOneWidget);

      // Build next frame
      await tester.pump(Duration.zero);
      expect(find.text('BRMainAutoLoadingState'), findsOneWidget);
      expect(find.text('BRGlobalAutoLoadingState'), findsOneWidget);
      expect(find.text('BRLocalInitialState'), findsOneWidget);

      // Check for loaded
      await tester.pump(Duration(milliseconds: 30));
      expect(find.text('BRMainAutoLoadedState'), findsOneWidget);
      expect(find.text('BRGlobalAutoLoadedState'), findsOneWidget);
      expect(find.text('BRLocalInitialState'), findsOneWidget);

      // Tap back button
      await tester.tap(find.backButton());
      await tester.pump();

      // Build first frame after popping
      await tester.pump(Duration.zero);
      // [BRMainAutoBloc, BRGlobalAutoCubit, BRLocalBloc]
      expect(BlocResetRegistry.registeredBlocCount, 3);

      // Build after pushed page disposed
      await tester.pumpAndSettle();
      // [BRMainAutoBloc, BRGlobalAutoCubit]
      expect(BlocResetRegistry.registeredBlocCount, 2);
      expect(BlocResetRegistry.get<BRMainAutoBloc>().isClosed, false);
      expect(BlocResetRegistry.get<BRGlobalAutoCubit>().isClosed, false);
      late Exception ex;
      late String eMsg;
      try {
        BlocResetRegistry.get<BRLocalBloc>();
      } on BlocResetRegistryGetNullException catch (e) {
        ex = e;
        eMsg = e.toString();
      }
      expect(ex.runtimeType, BlocResetRegistryGetNullException);
      expect(eMsg, 'Cannot find Bloc <$BRLocalBloc> from the registry.');
    });
  });
}
