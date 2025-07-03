import 'dart:async';
import 'dart:developer';

import 'package:bloc_mixins/bloc_mixins.dart';

class DisposeTestUsecase with BlocMixinsUsecase {
  DisposeTestUsecase() {
    log('created', name: 'DisposeTestUsecase');
  }

  @override
  FutureOr<void> close() async {
    log('disposed', name: 'DisposeTestUsecase');
    return super.close();
  }
}
