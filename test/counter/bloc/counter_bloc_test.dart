// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:counter_repository/counter_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_counter_flutter/counter/counter.dart';

class _MockCounterRepository extends Mock implements CounterRepository {}

void main() {
  group('CounterBloc', () {
    late CounterRepository counterRepository;

    setUp(() {
      counterRepository = _MockCounterRepository();
      when(
        () => counterRepository.connection,
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => counterRepository.count,
      ).thenAnswer((_) => const Stream.empty());
    });

    test('initial state is correct', () {
      expect(
        CounterBloc(counterRepository: counterRepository).state,
        equals(CounterState()),
      );
    });

    group('CounterStarted', () {
      blocTest<CounterBloc, CounterState>(
        'emits updated count when count changes',
        setUp: () {
          when(
            () => counterRepository.count,
          ).thenAnswer((_) => Stream.fromIterable([1, 2, 3]));
        },
        build: () => CounterBloc(counterRepository: counterRepository),
        act: (bloc) => bloc.add(CounterStarted()),
        expect: () => [
          CounterState(count: 1, status: CounterStatus.connected),
          CounterState(count: 2, status: CounterStatus.connected),
          CounterState(count: 3, status: CounterStatus.connected),
        ],
      );

      blocTest<CounterBloc, CounterState>(
        'emits updated status when connection changes',
        setUp: () {
          when(() => counterRepository.connection).thenAnswer(
            (_) => Stream.fromIterable(
              [Connected(), Disconnecting(), Disconnected()],
            ),
          );
        },
        build: () => CounterBloc(counterRepository: counterRepository),
        act: (bloc) => bloc.add(CounterStarted()),
        expect: () => [
          CounterState(status: CounterStatus.connected),
          CounterState(),
        ],
      );
    });

    group('CounterIncrementPressed', () {
      blocTest<CounterBloc, CounterState>(
        'calls increment.',
        build: () => CounterBloc(counterRepository: counterRepository),
        act: (bloc) => bloc.add(CounterIncrementPressed()),
        verify: (bloc) => verify(counterRepository.increment).called(1),
      );
    });

    group('CounterDecrementPressed', () {
      blocTest<CounterBloc, CounterState>(
        'calls decrement.',
        build: () => CounterBloc(counterRepository: counterRepository),
        act: (bloc) => bloc.add(CounterDecrementPressed()),
        verify: (bloc) => verify(counterRepository.decrement).called(1),
      );
    });
  });
}
