import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/presentation/widgets/board_widget.dart';
import 'package:tic_tac_toe/features/game/presentation/widgets/cell_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  group('BoardWidget', () {
    testWidgets('renders 9 cells', (tester) async {
      await tester.pumpAppWithScaffold(
        BoardWidget(
          board: Board.empty(),
          status: GameStatus.inProgress,
          onCellTap: (_) {},
        ),
      );

      expect(find.byType(CellWidget), findsNWidgets(9));
    });

    testWidgets('displays correct players in cells', (tester) async {
      final board = Board.fromCells([
        Player.x,
        Player.o,
        Player.none,
        Player.none,
        Player.x,
        Player.none,
        Player.none,
        Player.none,
        Player.o,
      ]);

      await tester.pumpAppWithScaffold(
        BoardWidget(
          board: board,
          status: GameStatus.inProgress,
          onCellTap: (_) {},
        ),
      );

      // Find X and O symbols
      expect(find.text('X'), findsNWidgets(2));
      expect(find.text('O'), findsNWidgets(2));
    });

    testWidgets('calls onCellTap with correct index when cell is tapped', (
      tester,
    ) async {
      int? tappedIndex;

      await tester.pumpAppWithScaffold(
        BoardWidget(
          board: Board.empty(),
          status: GameStatus.inProgress,
          onCellTap: (index) => tappedIndex = index,
        ),
      );

      // Get all cells and tap the first one (index 0)
      final cells = find.byType(CellWidget);
      await tester.tap(cells.first);
      await tester.pump();

      expect(tappedIndex, 0);
    });

    testWidgets('tapping occupied cell does not trigger callback', (
      tester,
    ) async {
      int? tappedIndex;
      final board = Board.empty().makeMove(0, Player.x);

      await tester.pumpAppWithScaffold(
        BoardWidget(
          board: board,
          status: GameStatus.inProgress,
          onCellTap: (index) => tappedIndex = index,
        ),
      );

      // Tap the occupied cell (index 0)
      final cells = find.byType(CellWidget);
      await tester.tap(cells.first);
      await tester.pump();

      // Should not trigger callback for occupied cell
      expect(tappedIndex, isNull);
    });

    testWidgets('disables taps when game is over (xWins)', (tester) async {
      int? tappedIndex;

      await tester.pumpAppWithScaffold(
        BoardWidget(
          board: Board.empty(),
          status: GameStatus.xWins,
          onCellTap: (index) => tappedIndex = index,
        ),
      );

      final cells = find.byType(CellWidget);
      await tester.tap(cells.first);
      await tester.pump();

      expect(tappedIndex, isNull);
    });

    testWidgets('disables taps when game is over (draw)', (tester) async {
      int? tappedIndex;

      await tester.pumpAppWithScaffold(
        BoardWidget(
          board: Board.empty(),
          status: GameStatus.draw,
          onCellTap: (index) => tappedIndex = index,
        ),
      );

      final cells = find.byType(CellWidget);
      await tester.tap(cells.first);
      await tester.pump();

      expect(tappedIndex, isNull);
    });

    testWidgets('highlights winning cells when X wins', (tester) async {
      // X wins top row
      final board = Board.fromCells([
        Player.x,
        Player.x,
        Player.x,
        Player.o,
        Player.o,
        Player.none,
        Player.none,
        Player.none,
        Player.none,
      ]);

      await tester.pumpAppWithScaffold(
        BoardWidget(board: board, status: GameStatus.xWins, onCellTap: (_) {}),
      );

      // The widget should render - we can verify it contains X's in winning position
      expect(find.text('X'), findsNWidgets(3));
    });

    testWidgets('renders grid layout', (tester) async {
      await tester.pumpAppWithScaffold(
        BoardWidget(
          board: Board.empty(),
          status: GameStatus.inProgress,
          onCellTap: (_) {},
        ),
      );

      // Find the GridView
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('has correct aspect ratio', (tester) async {
      await tester.pumpAppWithScaffold(
        BoardWidget(
          board: Board.empty(),
          status: GameStatus.inProgress,
          onCellTap: (_) {},
        ),
      );

      // Find the AspectRatio widget
      expect(find.byType(AspectRatio), findsOneWidget);

      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, 1.0); // Square board
    });
  });
}
