import 'package:bloc/bloc.dart';
import 'package:web_socket_counter_api/client.dart';

part 'counter_event.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc(WebSocketCounterClient client) : super(0) {
    on<CounterStarted>(
      (event, emit) => emit.forEach(client.count, onData: (count) => count),
    );
    on<CounterIncrementPressed>((event, emit) => client.increment());
    on<CounterDecrementPressed>((event, emit) => client.decrement());
  }
}
