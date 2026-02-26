import 'dart:math';

enum GuessResult { tooLow, tooHigh, correct }

class GameLogic {
  GameLogic({this.minBound = 1, this.maxBound = 100, int? seed})
      : _random = Random(seed) {
    _secretNumber = _random.nextInt(maxBound - minBound + 1) + minBound;
    _currentMin = minBound;
    _currentMax = maxBound;
  }

  final int minBound;
  final int maxBound;
  final Random _random;

  late int _secretNumber;
  late int _currentMin;
  late int _currentMax;
  final List<int> _guesses = [];
  bool _isGameOver = false;

  int get secretNumber => _secretNumber;
  int get currentMin => _currentMin;
  int get currentMax => _currentMax;
  List<int> get guesses => List.unmodifiable(_guesses);
  bool get isGameOver => _isGameOver;
  int get guessCount => _guesses.length;

  GuessResult makeGuess(int guess) {
    if (_isGameOver) {
      throw StateError('Game is already over');
    }
    if (guess < _currentMin || guess > _currentMax) {
      throw RangeError('Guess must be between $_currentMin and $_currentMax');
    }

    _guesses.add(guess);

    if (guess == _secretNumber) {
      _isGameOver = true;
      return GuessResult.correct;
    } else if (guess < _secretNumber) {
      _currentMin = guess + 1;
      return GuessResult.tooLow;
    } else {
      _currentMax = guess - 1;
      return GuessResult.tooHigh;
    }
  }

  void reset() {
    _secretNumber = _random.nextInt(maxBound - minBound + 1) + minBound;
    _currentMin = minBound;
    _currentMax = maxBound;
    _guesses.clear();
    _isGameOver = false;
  }
}
