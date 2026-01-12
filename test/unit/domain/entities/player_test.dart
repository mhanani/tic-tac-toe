import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/features/game/domain/entities/player.dart';

void main() {
  group('Player', () {
    group('opponent', () {
      test('Player.x.opponent returns Player.o', () {
        expect(Player.x.opponent, Player.o);
      });

      test('Player.o.opponent returns Player.x', () {
        expect(Player.o.opponent, Player.x);
      });

      test('Player.none.opponent returns Player.none', () {
        expect(Player.none.opponent, Player.none);
      });
    });

    group('symbol', () {
      test('Player.x.symbol returns "X"', () {
        expect(Player.x.symbol, 'X');
      });

      test('Player.o.symbol returns "O"', () {
        expect(Player.o.symbol, 'O');
      });

      test('Player.none.symbol returns empty string', () {
        expect(Player.none.symbol, '');
      });
    });
  });
}
