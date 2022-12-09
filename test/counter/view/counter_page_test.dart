import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_counter_flutter/counter/counter.dart';

import '../../helpers/helpers.dart';

class MockCounterBloc extends MockBloc<CounterEvent, int>
    implements CounterBloc {}

void main() {
  group('CounterPage', () {
    testWidgets('renders CounterView', (tester) async {
      await tester.pumpApp(const CounterPage());
      expect(find.byType(CounterView), findsOneWidget);
    });
  });

  group('CounterView', () {
    late CounterBloc counterBloc;

    setUp(() {
      counterBloc = MockCounterBloc();
    });

    testWidgets('renders current count', (tester) async {
      const state = 42;
      when(() => counterBloc.state).thenReturn(state);
      await tester.pumpApp(
        BlocProvider.value(
          value: counterBloc,
          child: const CounterView(),
        ),
      );
      expect(find.text('$state'), findsOneWidget);
    });

    testWidgets(
        'calls increment '
        'when increment button is tapped', (tester) async {
      when(() => counterBloc.state).thenReturn(0);
      await tester.pumpApp(
        BlocProvider.value(
          value: counterBloc,
          child: const CounterView(),
        ),
      );
      await tester.tap(find.byIcon(Icons.add));
      verify(() => counterBloc.add(CounterIncrementPressed())).called(1);
    });

    testWidgets(
        'calls decrement '
        'when decrement button is tapped', (tester) async {
      when(() => counterBloc.state).thenReturn(0);
      await tester.pumpApp(
        BlocProvider.value(
          value: counterBloc,
          child: const CounterView(),
        ),
      );
      await tester.tap(find.byIcon(Icons.remove));
      verify(() => counterBloc.add(CounterDecrementPressed())).called(1);
    });
  });
}
