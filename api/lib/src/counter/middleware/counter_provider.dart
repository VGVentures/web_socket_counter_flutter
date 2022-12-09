import 'dart:async';

import 'package:broadcaster/broadcaster.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:web_socket_counter_api/api.dart';

final _broadcaster = Broadcaster();
final _counter = CounterCubit();

StreamSubscription<dynamic>? _subscription;

/// Providers an instance of a [Broadcaster].
final broadcasterProvider = provider<Broadcaster>((_) => _broadcaster);

/// Provides an instance of a [CounterCubit].
final counterProvider = provider<CounterCubit>((_) {
  // Lazily establish a single subscription to the counter.
  _subscription ??= _counter.stream.listen(
    // Broadcast changes to all listeners.
    (count) => _broadcaster.broadcast('$count'),
  );
  return _counter;
});
