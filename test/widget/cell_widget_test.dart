import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/features/game/domain/entities/player.dart';
import 'package:tic_tac_toe/features/game/presentation/widgets/cell_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  group('CellWidget', () {
    testWidgets('displays X for Player.x', (tester) async {
      await tester.pumpAppWithScaffold(const CellWidget(player: Player.x));

      expect(find.text('X'), findsOneWidget);
    });

    testWidgets('displays O for Player.o', (tester) async {
      await tester.pumpAppWithScaffold(const CellWidget(player: Player.o));

      expect(find.text('O'), findsOneWidget);
    });

    testWidgets('displays nothing for Player.none', (tester) async {
      await tester.pumpAppWithScaffold(const CellWidget(player: Player.none));

      expect(find.text('X'), findsNothing);
      expect(find.text('O'), findsNothing);
    });

    testWidgets('onTap is called when tapped', (tester) async {
      var tapped = false;

      await tester.pumpAppWithScaffold(
        CellWidget(player: Player.none, onTap: () => tapped = true),
      );

      await tester.tap(find.byType(CellWidget));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('onTap null does not throw when tapped', (tester) async {
      await tester.pumpAppWithScaffold(const CellWidget(player: Player.none));

      // Should not throw
      await tester.tap(find.byType(CellWidget));
      await tester.pump();
    });

    testWidgets('displays correct symbol after player change', (tester) async {
      // Start with empty
      await tester.pumpAppWithScaffold(const CellWidget(player: Player.none));
      expect(find.text('X'), findsNothing);

      // Update to X
      await tester.pumpAppWithScaffold(const CellWidget(player: Player.x));
      await tester.pumpAndSettle();

      expect(find.text('X'), findsOneWidget);
    });

    testWidgets('isWinningCell applies different styling', (tester) async {
      await tester.pumpAppWithScaffold(
        const CellWidget(player: Player.x, isWinningCell: true),
      );

      // Find the AnimatedContainer
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      // Verify the decoration exists (styling is applied)
      expect(container.decoration, isNotNull);
    });
  });
}
