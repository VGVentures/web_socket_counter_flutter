part of 'counter_bloc.dart';

enum CounterStatus { connected, disconnected }

class CounterState extends Equatable {
  const CounterState({
    this.count = 0,
    this.status = CounterStatus.disconnected,
  });

  final int count;
  final CounterStatus status;

  @override
  List<Object?> get props => [count, status];

  CounterState copyWith({int? count, CounterStatus? status}) {
    return CounterState(
      count: count ?? this.count,
      status: status ?? this.status,
    );
  }
}
