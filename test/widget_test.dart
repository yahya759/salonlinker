import 'package:flutter_test/flutter_test.dart';
import 'package:salon/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BarbershopApp());
    expect(find.text('Barbershop Dashboard'), findsOneWidget);
  });
}
