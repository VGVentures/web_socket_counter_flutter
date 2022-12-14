import 'package:web_socket_client/web_socket_client.dart';
import 'package:web_socket_counter_api/api.dart';

/// {@template web_socket_counter_client}
/// A Dart Client for the WebSocket Counter API.
/// {@endtemplate}
class WebSocketCounterClient {
  /// {@macro web_socket_counter_client}
  WebSocketCounterClient(Uri uri) : _ws = WebSocket(uri);

  /// {@macro api_client}
  WebSocketCounterClient.localhost()
      : this(Uri.parse('ws://localhost:8080/ws'));

  final WebSocket _ws;

  /// Send an increment message to the server.
  void increment() => _ws.send(Message.increment.value);

  /// Send an decrement message to the server.
  void decrement() => _ws.send(Message.decrement.value);

  /// Return a stream of real-time count updates from the server.
  Stream<int> get count => _ws.messages.cast<String>().map(int.parse);

  /// Return a stream of connection updates from the server.
  Stream<ConnectionState> get connection => _ws.connection;

  /// Close the connection.
  void close() => _ws.close();
}
