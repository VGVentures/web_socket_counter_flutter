import 'package:counter_repository/counter_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:web_socket_counter/counter/counter.dart';

class _MockWebSocket extends Mock implements WebSocket {}

class _MockConnection extends Mock implements Connection {}

void main() {
  group('CounterRepository', () {
    late WebSocket socket;
    late CounterRepository counterRepository;

    setUp(() {
      socket = _MockWebSocket();
      counterRepository = CounterRepository(socket: socket);
    });

    test('can be instantiated without an explicit WebSocket', () {
      expect(CounterRepository(), isNotNull);
    });

    group('increment', () {
      test('sends the correct message', () {
        counterRepository.increment();
        verify(() => socket.send(Message.increment.value)).called(1);
      });
    });

    group('decrement', () {
      test('sends the correct message', () {
        counterRepository.decrement();
        verify(() => socket.send(Message.decrement.value)).called(1);
      });
    });

    group('connection', () {
      test('returns the correct connection state stream', () {
        const connectionStates = [
          Connecting(),
          Connected(),
          Disconnecting(),
          Disconnected(),
        ];
        final connectionStream = Stream.fromIterable(connectionStates);
        final connection = _MockConnection();
        when(
          () => connection.listen(
            any(),
            onError: any(named: 'onError'),
            onDone: any(named: 'onDone'),
            cancelOnError: any(named: 'cancelOnError'),
          ),
        ).thenAnswer(
          (invocation) => connectionStream.listen(
            invocation.positionalArguments.first as void Function(dynamic),
          ),
        );
        when(() => connection.isBroadcast).thenReturn(true);
        when(() => socket.connection).thenAnswer((_) => connection);

        expect(counterRepository.connection, emitsInOrder(connectionStates));
      });
    });

    group('count', () {
      test('returns stream of count messages', () {
        const messages = ['0', '1', '2', '3'];
        final messageStream = Stream.fromIterable(messages);

        when(() => socket.messages).thenAnswer((_) => messageStream);

        expect(counterRepository.count, emitsInOrder(messages.map(int.parse)));
      });
    });

    group('close', () {
      test('closes the underlying WebSocket', () {
        counterRepository.close();
        verify(socket.close).called(1);
      });
    });
  });
}
