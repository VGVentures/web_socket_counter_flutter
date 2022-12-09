import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

/// {@template web_socket_client}
/// A Dart WebSocket Client
/// {@endtemplate}
class WebSocketClient {
  /// {@macro web_socket_client}
  WebSocketClient({required Uri uri}) : _uri = uri;

  final _controller = StreamController.broadcast();
  final Uri _uri;

  StreamSubscription<dynamic>? _subscription;
  var _connected = false;

  WebSocketChannel? _channel;

  Future<void> _connect() async {
    if (_connected && _channel != null) return;

    final completer = Completer<void>();

    _connected = false;
    _channel = WebSocketChannel.connect(_uri);
    _subscription?.cancel().ignore();
    _subscription = _channel!.stream.listen(
      (message) {
        if (!completer.isCompleted) completer.complete();
        _connected = true;
        _controller.add(message);
      },
      onError: (error, stackTrace) {
        _channel = null;
        _connected = false;
        _reconnect();
      },
      onDone: () {
        _channel = null;
        _connected = false;
        _reconnect();
      },
      cancelOnError: false,
    );

    return completer.future;
  }

  Future<void> _reconnect() async {
    while (!_connected) {
      await _connect();
    }
  }

  /// The broadcast stream that emits values from the other endpoint.
  Stream<dynamic> get stream {
    if (!_connected) _connect();
    return _controller.stream;
  }

  /// Adds a message to the sink.
  void add(dynamic message) => _channel?.sink.add(message);

  /// Closes the connection and frees any resources.
  void close([int? code, String? reason]) {
    _channel?.sink.close(code, reason);
    _controller.close();
    _subscription?.cancel();
  }
}
