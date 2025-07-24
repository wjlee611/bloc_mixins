import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiOTEHomeCubit extends Cubit<void> with OneTimeEmitter<int> {
  int _count = 0;

  MultiOTEHomeCubit() : super(0);

  void increment() {
    _count++;
    oneTimeEmit(_count);
  }
}
