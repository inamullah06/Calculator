import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calculator/main.dart';

void main() {
  testWidgets('Calculator renders main components', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    // Verify AC button exists
    expect(find.text('AC'), findsOneWidget);

    // Verify equals button exists
    expect(find.text('='), findsOneWidget);
  });
}
