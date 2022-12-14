part of 'counter_bloc.dart';

abstract class CounterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CounterStarted extends CounterEvent {}

class CounterIncrementPressed extends CounterEvent {}

class CounterDecrementPressed extends CounterEvent {}

class _CounterCountChanged extends CounterEvent {
  _CounterCountChanged(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}

class _CounterConnectionStateChanged extends CounterEvent {
  _CounterConnectionStateChanged(this.state);

  final ConnectionState state;

  @override
  List<Object?> get props => [state];
}
