import 'package:web_socket_client/web_socket_client.dart';
import 'package:web_socket_counter_api/api.dart';

/// {@template web_socket_counter_client}
/// A Dart Client for the WebSocket Counter API.
/// {@endtemplate}
class WebSocketCounterClient {
  /// {@macro web_socket_counter_client}
  WebSocketCounterClient({required Uri uri}) : _ws = WebSocketClient(uri: uri);

  /// {@macro api_client}
  WebSocketCounterClient.localhost()
      : this(uri: Uri.parse('ws://10.0.2.2:8080/ws'));

  final WebSocketClient _ws;

  /// Send an increment message to the server.
  void increment() => _ws.add(Message.increment.value);

  /// Send an decrement message to the server.
  void decrement() => _ws.add(Message.decrement.value);

  /// Return a stream of real-time count updates from the server.
  Stream<int> get count => _ws.stream.cast<String>().map(int.parse);
}
