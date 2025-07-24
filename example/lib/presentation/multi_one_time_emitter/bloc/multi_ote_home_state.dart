part of 'multi_ote_home_bloc.dart';

class MultiOTEHomeState extends Equatable {
  final int count;

  const MultiOTEHomeState({required this.count});

  const MultiOTEHomeState.init() : count = 0;

  MultiOTEHomeState copyWith({int? count}) {
    return MultiOTEHomeState(count: count ?? this.count);
  }

  @override
  List<Object> get props => [count];
}
