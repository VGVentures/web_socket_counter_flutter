import 'package:web_socket_channel/web_socket_channel.dart';

/// {@template broadcaster}
/// A WebSocket broadcaster
/// {@endtemplate}
class Broadcaster {
  final _channels = <WebSocketChannel>[];

  /// Broadcast [message] to all clients.
  void broadcast(String message) {
    for (final channel in _channels) {
      channel.sink.add(message);
    }
  }

  /// Add a new [channel].
  void add(WebSocketChannel channel) => _channels.add(channel);

  /// Remove an existing [channel].
  void remove(WebSocketChannel channel) => _channels.remove(channel);
}
