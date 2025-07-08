import 'package:bloc_mixins/bloc_mixins.dart';

class SyncUsecase with UsecaseStream<int> {
  int call(int syncValue) {
    yieldData(syncValue);
    return syncValue;
  }
}
