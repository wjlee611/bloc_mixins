part of 'ote_home_bloc.dart';

class OTEHomeState extends Equatable {
  final int count;
  final bool isLoading;

  const OTEHomeState({required this.count, required this.isLoading});

  const OTEHomeState.init() : count = 0, isLoading = false;

  OTEHomeState copyWith({int? count, bool? isLoading}) {
    return OTEHomeState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [count, isLoading];
}
