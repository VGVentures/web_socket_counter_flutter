import 'package:web_socket_client/web_socket_client.dart';

/// {@template message}
/// WebSocket Counter Messages
/// {@endtemplate}
enum Message {
  /// An increment message.
  increment('__increment__'),

  /// A decrement message.
  decrement('__decrement__');

  /// {@macro message}
  const Message(this.value);

  /// The value of the message.
  final String value;
}

/// {@template web_socket_counter_client}
/// A Dart Client for WebSocket Counter
/// {@endtemplate}
class WebSocketCounterClient {
  /// {@macro web_socket_counter_client}
  WebSocketCounterClient({required Uri uri}) : _ws = WebSocketClient(uri: uri);

  /// {@macro api_client}
  WebSocketCounterClient.localhost()
      : this(uri: Uri.parse('ws://localhost:8080/ws'));

  final WebSocketClient _ws;

  /// Increment count.
  void increment() => _ws.add(Message.increment.value);

  /// Decrement count.
  void decrement() => _ws.add(Message.decrement.value);

  /// Return a real-time count.
  Stream<int> get count => _ws.stream.cast<String>().map(int.parse);
}
