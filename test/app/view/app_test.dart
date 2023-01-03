import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_counter_flutter/app/app.dart';
import 'package:web_socket_counter_flutter/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.runAsync(() => tester.pumpWidget(const App()));
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
