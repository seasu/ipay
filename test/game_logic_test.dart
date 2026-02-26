import 'package:flutter_test/flutter_test.dart';
import 'package:ipay/game_logic.dart';

void main() {
  group('GameLogic', () {
    test('initializes with correct bounds', () {
      final game = GameLogic(seed: 42);
      expect(game.currentMin, 1);
      expect(game.currentMax, 100);
      expect(game.isGameOver, false);
      expect(game.guessCount, 0);
    });

    test('narrows range on too-low guess', () {
      final game = GameLogic(seed: 42);
      final secret = game.secretNumber;
      if (secret > 1) {
        final result = game.makeGuess(secret - 1);
        expect(result, GuessResult.tooLow);
        expect(game.currentMin, secret);
      }
    });

    test('narrows range on too-high guess', () {
      final game = GameLogic(seed: 42);
      final secret = game.secretNumber;
      if (secret < 100) {
        final result = game.makeGuess(secret + 1);
        expect(result, GuessResult.tooHigh);
        expect(game.currentMax, secret);
      }
    });

    test('returns correct on exact guess', () {
      final game = GameLogic(seed: 42);
      final result = game.makeGuess(game.secretNumber);
      expect(result, GuessResult.correct);
      expect(game.isGameOver, true);
    });

    test('tracks guesses', () {
      final game = GameLogic(seed: 42);
      final secret = game.secretNumber;
      if (secret > 2) {
        game.makeGuess(1);
        game.makeGuess(2);
        expect(game.guessCount, 2);
        expect(game.guesses, [1, 2]);
      }
    });

    test('throws on guess after game over', () {
      final game = GameLogic(seed: 42);
      game.makeGuess(game.secretNumber);
      expect(() => game.makeGuess(50), throwsStateError);
    });

    test('throws on out-of-range guess', () {
      final game = GameLogic(seed: 42);
      expect(() => game.makeGuess(0), throwsRangeError);
      expect(() => game.makeGuess(101), throwsRangeError);
    });

    test('reset starts a new game', () {
      final game = GameLogic(seed: 42);
      game.makeGuess(game.secretNumber);
      expect(game.isGameOver, true);

      game.reset();
      expect(game.isGameOver, false);
      expect(game.currentMin, 1);
      expect(game.currentMax, 100);
      expect(game.guessCount, 0);
    });
  });
}
