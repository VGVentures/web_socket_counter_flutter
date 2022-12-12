import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

/// The state of a WebSocket connection.
enum WebSocketConnectionState {
  /// Attempting to establish a connection.
  connecting,

  /// Connection is established.
  open,

  /// Closing a connection.
  closing,

  /// Connection is closed.
  closed,
}

/// {@template web_socket_client}
/// A Dart WebSocket Client
/// {@endtemplate}
class WebSocketClient {
  /// {@macro web_socket_client}
  WebSocketClient({required Uri uri}) : _uri = uri;

  final _messageController = StreamController.broadcast();
  final _connectionStateController =
      StreamController<WebSocketConnectionState>.broadcast();
  final Uri _uri;

  StreamSubscription<dynamic>? _subscription;

  var __connectionState = WebSocketConnectionState.connecting;

  WebSocketConnectionState get _connectionState => __connectionState;

  set _connectionState(WebSocketConnectionState state) {
    __connectionState = state;
    _connectionStateController.add(state);
  }

  bool get _connected {
    return _connectionState == WebSocketConnectionState.open ||
        _connectionState == WebSocketConnectionState.closing;
  }

  WebSocketChannel? _channel;

  Future<void> _connect() async {
    if (_connected && _channel != null) return;

    final completer = Completer<void>();

    _connectionState = WebSocketConnectionState.connecting;
    _channel = WebSocketChannel.connect(_uri);
    _subscription?.cancel().ignore();
    _subscription = _channel!.stream.listen(
      (message) {
        if (!completer.isCompleted) completer.complete();
        _connectionState = WebSocketConnectionState.open;
        _messageController.add(message);
      },
      onError: (error, stackTrace) {
        _channel = null;
        _connectionState = WebSocketConnectionState.connecting;
        _reconnect();
      },
      onDone: () {
        _channel = null;
        _connectionState = WebSocketConnectionState.connecting;
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
    return _messageController.stream;
  }

  /// A stream of the [WebSocketConnectionState].
  Stream<WebSocketConnectionState> get connection {
    return _connectionStateController.stream.distinct();
  }

  /// Adds a message to the sink.
  void add(dynamic message) => _channel?.sink.add(message);

  /// Closes the connection and frees any resources.
  void close([int? code, String? reason]) {
    final channel = _channel;
    final subscription = _subscription;
    _connectionState = WebSocketConnectionState.closing;
    Future.wait<void>([
      if (channel != null) channel.sink.close(code, reason),
      _connectionStateController.close(),
      _messageController.close(),
      if (subscription != null) subscription.cancel(),
    ]).whenComplete(() => _connectionState = WebSocketConnectionState.closed);
  }
}
