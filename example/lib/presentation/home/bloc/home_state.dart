part of 'home_bloc.dart';

class HomeState extends Equatable {
  final int count;
  final bool isLoading;

  const HomeState({required this.count, required this.isLoading});

  const HomeState.init() : count = 0, isLoading = false;

  HomeState copyWith({int? count, bool? isLoading}) {
    return HomeState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [count, isLoading];
}
