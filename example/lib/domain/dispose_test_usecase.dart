import 'dart:developer';

import 'package:bloc_mixins/bloc_mixins.dart';

class DisposeTestUsecase with BlocMixinsUsecase {
  DisposeTestUsecase() {
    log('created', name: 'DisposeTestUsecase');
  }

  @override
  void dispose() {
    log('disposed', name: 'DisposeTestUsecase');
    return super.dispose();
  }
}
