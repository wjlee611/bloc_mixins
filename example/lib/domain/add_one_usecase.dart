import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:example/data/counter_repository.dart';

class AddOneUsecase with BlocMixinsUsecase<int> {
  final CounterRepository _counterRepository;

  AddOneUsecase({required CounterRepository counterRepository})
    : _counterRepository = counterRepository;

  Future<int> call(int value, {int delay = 2}) async {
    final result = await _counterRepository.increment(value, delay);
    yieldData(result);
    return result;
  }
}
