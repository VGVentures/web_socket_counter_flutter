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
    on<_CounterConnectionChanged>(_onCounterConnectionChanged);
    on<_CounterCountChanged>(_onCounterCountChanged);
    on<CounterIncrementPressed>(_onCounterIncrementPressed);
    on<CounterDecrementPressed>(_onCounterDecrementPressed);
  }

  final WebSocketCounterClient _client;
  StreamSubscription<int>? _countSubscription;
  StreamSubscription<WebSocketConnectionState>? _connectionSubscription;

  void _onCounterStarted(
    CounterStarted event,
    Emitter<CounterState> emit,
  ) {
    _countSubscription = _client.count.listen(
      (count) => add(_CounterCountChanged(count)),
    );
    _connectionSubscription = _client.connection.listen((connection) {
      add(_CounterConnectionChanged(connection));
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

  void _onCounterConnectionChanged(
    _CounterConnectionChanged event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(status: event.connection.toStatus()));
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

extension on WebSocketConnectionState {
  CounterStatus toStatus() {
    switch (this) {
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.closed:
        return CounterStatus.disconnected;
      case WebSocketConnectionState.open:
      case WebSocketConnectionState.closing:
        return CounterStatus.connected;
    }
  }
}
