import 'package:flutter/material.dart';
import 'package:web_socket_counter_flutter/counter/counter.dart';
import 'package:web_socket_counter_flutter/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CounterPage(),
    );
  }
}
