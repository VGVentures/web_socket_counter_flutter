import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:counter_repository/counter_repository.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc({required CounterRepository counterRepository})
      : _counterRepository = counterRepository,
        super(const CounterState()) {
    on<CounterStarted>(_onCounterStarted);
    on<CounterIncrementPressed>(_onCounterIncrementPressed);
    on<CounterDecrementPressed>(_onCounterDecrementPressed);
  }

  final CounterRepository _counterRepository;

  Future<void> _onCounterStarted(
    CounterStarted event,
    Emitter<CounterState> emit,
  ) async {
    final countEmitter = emit.forEach<int>(
      _counterRepository.count,
      onData: (count) =>
          state.copyWith(count: count, status: CounterStatus.connected),
    );

    final connectionEmitter = emit.forEach<ConnectionState>(
      _counterRepository.connection,
      onData: (state) => this.state.copyWith(status: state.toStatus()),
    );

    await Future.wait([countEmitter, connectionEmitter]);
  }

  void _onCounterIncrementPressed(
    CounterIncrementPressed event,
    Emitter<CounterState> emit,
  ) {
    _counterRepository.increment();
  }

  void _onCounterDecrementPressed(
    CounterDecrementPressed event,
    Emitter<CounterState> emit,
  ) {
    _counterRepository.decrement();
  }
}

extension on ConnectionState {
  CounterStatus toStatus() {
    return this is Connected || this is Reconnected
        ? CounterStatus.connected
        : CounterStatus.disconnected;
  }
}
