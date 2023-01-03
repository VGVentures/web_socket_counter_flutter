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
    on<_CounterConnectionStateChanged>(_onCounterConnectionStateChanged);
    on<_CounterCountChanged>(_onCounterCountChanged);
    on<CounterIncrementPressed>(_onCounterIncrementPressed);
    on<CounterDecrementPressed>(_onCounterDecrementPressed);
  }

  final CounterRepository _counterRepository;
  StreamSubscription<int>? _countSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;

  void _onCounterStarted(
    CounterStarted event,
    Emitter<CounterState> emit,
  ) {
    _countSubscription = _counterRepository.count.listen(
      (count) => add(_CounterCountChanged(count)),
    );
    _connectionSubscription = _counterRepository.connection.listen((state) {
      add(_CounterConnectionStateChanged(state));
    });
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

  void _onCounterConnectionStateChanged(
    _CounterConnectionStateChanged event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(status: event.state.toStatus()));
  }

  void _onCounterCountChanged(
    _CounterCountChanged event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(count: event.count, status: CounterStatus.connected));
  }

  @override
  Future<void> close() {
    _connectionSubscription?.cancel();
    _countSubscription?.cancel();
    return super.close();
  }
}

extension on ConnectionState {
  CounterStatus toStatus() {
    return this is Connected || this is Reconnected
        ? CounterStatus.connected
        : CounterStatus.disconnected;
  }
}
