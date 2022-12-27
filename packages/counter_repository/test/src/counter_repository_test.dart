import 'package:counter_repository/counter_repository.dart';
import 'package:test/test.dart';

void main() {
  group('CounterRepository', () {
    test('can be instantiated', () {
      expect(CounterRepository(), isNotNull);
    });
  });
}
