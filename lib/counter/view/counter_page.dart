import 'package:counter_repository/counter_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_counter_flutter/counter/counter.dart';
import 'package:web_socket_counter_flutter/l10n/l10n.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(
        counterRepository: context.read<CounterRepository>(),
      )..add(const CounterStarted()),
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
        children: const [
          IncrementButton(),
          SizedBox(height: 8),
          DecrementButton(),
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
    final l10n = context.l10n;
    final connection = context.select((CounterBloc bloc) => bloc.state.status);
    switch (connection) {
      case CounterStatus.connected:
        return Text(
          l10n.counterConnectedText,
          style: theme.textTheme.caption?.copyWith(
            color: theme.colorScheme.primary,
          ),
        );

      case CounterStatus.disconnected:
        return Text(
          l10n.counterDisconnectedText,
          style: theme.textTheme.caption?.copyWith(
            color: theme.colorScheme.error,
          ),
        );
    }
  }
}

class IncrementButton extends StatelessWidget {
  const IncrementButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isConnected = context.select(
      (CounterBloc bloc) => bloc.state.status == CounterStatus.connected,
    );
    return FloatingActionButton(
      backgroundColor: isConnected ? null : Colors.grey,
      onPressed: isConnected
          ? () {
              context.read<CounterBloc>().add(const CounterIncrementPressed());
            }
          : null,
      child: const Icon(Icons.add),
    );
  }
}

class DecrementButton extends StatelessWidget {
  const DecrementButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isConnected = context.select(
      (CounterBloc bloc) => bloc.state.status == CounterStatus.connected,
    );
    return FloatingActionButton(
      backgroundColor: isConnected ? null : Colors.grey,
      onPressed: isConnected
          ? () {
              context.read<CounterBloc>().add(const CounterDecrementPressed());
            }
          : null,
      child: const Icon(Icons.remove),
    );
  }
}
