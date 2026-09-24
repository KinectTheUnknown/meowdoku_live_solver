import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_live_solver/main.dart';

void main() {
  testWidgets('App launches with title and video controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MeowdokuApp()));
    await tester.pump();

    expect(find.text('🐱 Meowdoku Live Solver'), findsOneWidget);
    expect(find.text('VDO.Ninja Feed'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
  });
}
