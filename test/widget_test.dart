import 'package:flutter_test/flutter_test.dart';
import 'package:transcendent_mind/app/transzendent_app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TranszendentApp());
  });
}
