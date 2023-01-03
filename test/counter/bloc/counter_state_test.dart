// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_counter_flutter/counter/counter.dart';

void main() {
  group('CounterState', () {
    test('supports value equality', () {
      final stateA = CounterState();
      final stateB = CounterState();
      final stateC = CounterState(count: 1);

      expect(stateA, equals(stateB));
      expect(stateA, isNot(equals(stateC)));
      expect(stateB, isNot(equals(stateC)));
    });

    group('copyWith', () {
      test('returns copy with overwritten properties', () {
        final original = CounterState();

        final countCopy = original.copyWith(count: 1);
        expect(countCopy.status, equals(original.status));
        expect(countCopy.count, equals(1));

        final statusCopy = original.copyWith(status: CounterStatus.connected);
        expect(statusCopy.count, equals(original.count));
        expect(statusCopy.status, equals(CounterStatus.connected));

        final allCopy = original.copyWith(
          count: 1,
          status: CounterStatus.connected,
        );
        expect(allCopy.status, equals(CounterStatus.connected));
        expect(allCopy.count, equals(1));
      });
    });
  });
}
