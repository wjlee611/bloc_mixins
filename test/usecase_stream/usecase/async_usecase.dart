import 'package:bloc_mixins/bloc_mixins.dart';

class AsyncUsecase with UsecaseStream<int> {
  Future<int> call(int syncValue) async {
    await Future.delayed(const Duration(milliseconds: 500));
    yieldData(syncValue);
    return syncValue;
  }
}
