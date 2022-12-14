import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_counter_api/client.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc(WebSocketCounterClient client)
      : _client = client,
        super(const CounterState()) {
    on<CounterStarted>(_onCounterStarted);
    on<_CounterConnectionStateChanged>(_onCounterConnectionStateChanged);
    on<_CounterCountChanged>(_onCounterCountChanged);
    on<CounterIncrementPressed>(_onCounterIncrementPressed);
    on<CounterDecrementPressed>(_onCounterDecrementPressed);
  }

  final WebSocketCounterClient _client;
  StreamSubscription<int>? _countSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;

  void _onCounterStarted(
    CounterStarted event,
    Emitter<CounterState> emit,
  ) {
    _countSubscription = _client.count.listen(
      (count) => add(_CounterCountChanged(count)),
    );
    _connectionSubscription = _client.connection.listen((state) {
      add(_CounterConnectionStateChanged(state));
    });
  }

  void _onCounterIncrementPressed(
    CounterIncrementPressed event,
    Emitter<CounterState> emit,
  ) {
    _client.increment();
  }

  void _onCounterDecrementPressed(
    CounterDecrementPressed event,
    Emitter<CounterState> emit,
  ) {
    _client.decrement();
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
    _client.close();
    return super.close();
  }
}

extension on ConnectionState {
  CounterStatus toStatus() {
    return this is Connected
        ? CounterStatus.connected
        : CounterStatus.disconnected;
  }
}
