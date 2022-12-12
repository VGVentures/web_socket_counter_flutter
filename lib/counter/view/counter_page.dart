import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_counter_api/client.dart';
import 'package:web_socket_counter_flutter/counter/counter.dart';
import 'package:web_socket_counter_flutter/l10n/l10n.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(WebSocketCounterClient.localhost())
        ..add(CounterStarted()),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CounterText(),
            ConnectionText(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<CounterBloc>().add(CounterIncrementPressed());
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              context.read<CounterBloc>().add(CounterDecrementPressed());
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterBloc bloc) => bloc.state.count);
    return Text('$count', style: theme.textTheme.headline1);
  }
}

class ConnectionText extends StatelessWidget {
  const ConnectionText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connection = context.select((CounterBloc bloc) => bloc.state.status);
    switch (connection) {
      case CounterStatus.connected:
        return Text(
          'Connected',
          style: theme.textTheme.caption?.copyWith(
            color: theme.colorScheme.primary,
          ),
        );

      case CounterStatus.disconnected:
        return Text(
          'Disconnected',
          style: theme.textTheme.caption?.copyWith(
            color: theme.colorScheme.error,
          ),
        );
    }
  }
}
