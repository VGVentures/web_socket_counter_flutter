import 'package:dart_frog/dart_frog.dart';
import 'package:web_socket_counter_api/api.dart';

Handler middleware(Handler handler) {
  return handler.use(counterProvider).use(broadcasterProvider);
}
