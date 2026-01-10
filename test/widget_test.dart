import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    expect(find.text('Tic Tac Toe'), findsOneWidget);
  });
}
