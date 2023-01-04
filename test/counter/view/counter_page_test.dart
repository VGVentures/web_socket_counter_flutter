import 'package:bloc_test/bloc_test.dart';
import 'package:counter_repository/counter_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_counter_flutter/counter/counter.dart';
import 'package:web_socket_counter_flutter/l10n/l10n.dart';

import '../../helpers/helpers.dart';

class _MockCounterBloc extends MockBloc<CounterEvent, CounterState>
    implements CounterBloc {}

class _MockCounterRepository extends Mock implements CounterRepository {}

void main() {
  group('CounterPage', () {
    testWidgets('renders CounterView', (tester) async {
      final counterRepository = _MockCounterRepository();
      when(
        () => counterRepository.connection,
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => counterRepository.count,
      ).thenAnswer((_) => const Stream.empty());
      await tester.pumpApp(
        const CounterPage(),
        counterRepository: counterRepository,
      );
      expect(find.byType(CounterView), findsOneWidget);
    });
  });

  group('CounterView', () {
    late CounterBloc counterBloc;

    setUp(() {
      counterBloc = _MockCounterBloc();
    });

    testWidgets('renders current count (disconnected)', (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      const state = CounterState(count: 42);
      when(() => counterBloc.state).thenReturn(state);
      await tester.pumpApp(
        BlocProvider.value(
          value: counterBloc,
          child: const CounterView(),
        ),
      );
      expect(find.text('${state.count}'), findsOneWidget);
      expect(find.text(l10n.counterDisconnectedText), findsOneWidget);
    });

    testWidgets('renders current count (connected)', (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      const state = CounterState(count: 42, status: CounterStatus.connected);
      when(() => counterBloc.state).thenReturn(state);
      await tester.pumpApp(
        BlocProvider.value(
          value: counterBloc,
          child: const CounterView(),
        ),
      );
      expect(find.text('${state.count}'), findsOneWidget);
      expect(find.text(l10n.counterConnectedText), findsOneWidget);
    });

    testWidgets(
        'does not call increment '
        'when increment button is tapped '
        'and status is disconnected', (tester) async {
      when(() => counterBloc.state).thenReturn(const CounterState());
      await tester.pumpApp(
        BlocProvider.value(
          value: counterBloc,
          child: const CounterView(),
        ),
      );
      await tester.tap(find.byIcon(Icons.add));
      verifyNever(() => counterBloc.add(const CounterIncrementPressed()));
    });

    testWidgets(
        'does not call decrement '
        'when decrement button is tapped '
        'and status is disconnected', (tester) async {
      when(() => counterBloc.state).thenReturn(const CounterState());
      await tester.pumpApp(
        BlocProvider.value(
          value: counterBloc,
          child: const CounterView(),
        ),
      );
      await tester.tap(find.byIcon(Icons.remove));
      verifyNever(() => counterBloc.add(const CounterDecrementPressed()));
    });

    testWidgets(
        'calls increment '
        'when increment button is tapped '
        'and status is connected', (tester) async {
      when(
        () => counterBloc.state,
      ).thenReturn(const CounterState(status: CounterStatus.connected));
      await tester.pumpApp(
        BlocProvider.value(
          value: counterBloc,
          child: const CounterView(),
        ),
      );
      await tester.tap(find.byIcon(Icons.add));
      verify(() => counterBloc.add(const CounterIncrementPressed())).called(1);
    });

    testWidgets(
        'calls decrement '
        'when decrement button is tapped '
        'and status is connected', (tester) async {
      when(
        () => counterBloc.state,
      ).thenReturn(const CounterState(status: CounterStatus.connected));
      await tester.pumpApp(
        BlocProvider.value(
          value: counterBloc,
          child: const CounterView(),
        ),
      );
      await tester.tap(find.byIcon(Icons.remove));
      verify(() => counterBloc.add(const CounterDecrementPressed())).called(1);
    });
  });
}
