import 'package:counter_repository/counter_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_counter_flutter/l10n/l10n.dart';

class _MockCounterRepository extends Mock implements CounterRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget, {CounterRepository? counterRepository}) {
    return pumpWidget(
      RepositoryProvider(
        create: (_) => counterRepository ?? _MockCounterRepository(),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
