import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_live_solver/main.dart';

void main() {
  testWidgets('App launches with title and video controls', (WidgetTester tester) async {
    await tester.pumpWidget(const MeowdokuApp());
    await tester.pump();

    expect(find.text('🐱 Meowdoku Live Solver'), findsOneWidget);
    expect(find.text('VDO.Ninja Connection'), findsOneWidget);
    expect(find.text('Connect Stream'), findsOneWidget);
  });
}
