part of 'us_home_bloc.dart';

class USHomeState extends Equatable {
  final int count;
  final bool isLoading;

  const USHomeState({required this.count, required this.isLoading});

  const USHomeState.init() : count = 0, isLoading = false;

  USHomeState copyWith({int? count, bool? isLoading}) {
    return USHomeState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [count, isLoading];
}
