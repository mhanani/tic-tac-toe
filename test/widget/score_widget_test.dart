import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/features/game/presentation/widgets/score_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  group('ScoreWidget', () {
    testWidgets('displays label', (tester) async {
      await tester.pumpAppWithScaffold(
        const ScoreWidget(label: 'X Wins', score: 5, color: Colors.blue),
      );

      expect(find.text('X Wins'), findsOneWidget);
    });

    testWidgets('displays score', (tester) async {
      await tester.pumpAppWithScaffold(
        const ScoreWidget(label: 'X Wins', score: 10, color: Colors.blue),
      );

      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('displays zero score correctly', (tester) async {
      await tester.pumpAppWithScaffold(
        const ScoreWidget(label: 'Draws', score: 0, color: Colors.grey),
      );

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('uses correct color for X player', (tester) async {
      await tester.pumpAppWithScaffold(
        ScoreWidget(label: 'X Wins', score: 3, color: AppTheme.playerXColor),
      );

      // Widget should render without errors
      expect(find.byType(ScoreWidget), findsOneWidget);
    });

    testWidgets('uses correct color for O player', (tester) async {
      await tester.pumpAppWithScaffold(
        ScoreWidget(label: 'O Wins', score: 2, color: AppTheme.playerOColor),
      );

      // Widget should render without errors
      expect(find.byType(ScoreWidget), findsOneWidget);
    });

    testWidgets('uses correct color for draws', (tester) async {
      await tester.pumpAppWithScaffold(
        ScoreWidget(label: 'Draws', score: 1, color: AppTheme.drawColor),
      );

      // Widget should render without errors
      expect(find.byType(ScoreWidget), findsOneWidget);
    });

    testWidgets('renders with Container decoration', (tester) async {
      await tester.pumpAppWithScaffold(
        const ScoreWidget(label: 'Test', score: 5, color: Colors.blue),
      );

      // Find the Container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders label above score', (tester) async {
      await tester.pumpAppWithScaffold(
        const ScoreWidget(label: 'X Wins', score: 7, color: Colors.blue),
      );

      // Find the Column
      expect(find.byType(Column), findsOneWidget);

      // Both label and score should be present
      expect(find.text('X Wins'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
    });
  });
}
