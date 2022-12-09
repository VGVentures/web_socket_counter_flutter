import 'package:broadcaster/broadcaster.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:web_socket_counter_api/api.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler(
    (channel, protocol) {
      final broadcaster = context.read<Broadcaster>()..add(channel);
      final cubit = context.read<CounterCubit>();

      void onMessage(dynamic value) {
        switch ('$value'.toMessage()) {
          case Message.increment:
            cubit.increment();
            break;
          case Message.decrement:
            cubit.decrement();
            break;
          case null:
            break;
        }
      }

      void onDone() => broadcaster.remove(channel);

      channel.sink.add('${cubit.state}');
      channel.stream.listen(onMessage, onDone: onDone);
    },
  );

  return handler(context);
}

extension on String {
  Message? toMessage() {
    for (final message in Message.values) {
      if (this == message.value) {
        return message;
      }
    }
    return null;
  }
}
