import 'package:broadcaster/broadcaster.dart';
import 'package:test/test.dart';

void main() {
  group('Broadcaster', () {
    test('can be instantiated', () {
      expect(Broadcaster(), isNotNull);
    });
  });
}
