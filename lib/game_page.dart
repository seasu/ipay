import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_logic.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  late GameLogic _game;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _message = '';
  bool _showBomb = false;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _game = GameLogic();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _submitGuess() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final guess = int.tryParse(text);
    if (guess == null) {
      setState(() => _message = '請輸入有效的數字');
      return;
    }
    if (guess < _game.currentMin || guess > _game.currentMax) {
      setState(() => _message = '請輸入 ${_game.currentMin} ~ ${_game.currentMax} 之間的數字');
      return;
    }

    final result = _game.makeGuess(guess);
    _controller.clear();

    setState(() {
      switch (result) {
        case GuessResult.tooLow:
          _message = '$guess 太小了！';
          _shakeController.forward(from: 0);
        case GuessResult.tooHigh:
          _message = '$guess 太大了！';
          _shakeController.forward(from: 0);
        case GuessResult.correct:
          _message = '💥 踩到了！答案就是 $guess';
          _showBomb = true;
      }
    });

    _focusNode.requestFocus();
  }

  void _resetGame() {
    setState(() {
      _game.reset();
      _controller.clear();
      _message = '';
      _showBomb = false;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rangeText = '${_game.currentMin} ~ ${_game.currentMax}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('I-Pay 終極密碼'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重新開始',
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_showBomb) ...[
                  const Text('💣', style: TextStyle(fontSize: 80)),
                  const SizedBox(height: 12),
                ] else ...[
                  const Text('🤔', style: TextStyle(fontSize: 80)),
                  const SizedBox(height: 12),
                ],

                Text(
                  '猜測範圍',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    final progress = _shakeController.value;
                    final offset = _shakeController.isAnimating
                        ? 10 * (0.5 - progress).abs() *
                            (progress < 0.5 ? 1 : -1)
                        : 0.0;
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: Text(
                    rangeText,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                if (!_game.isGameOver) ...[
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      autofocus: true,
                      style: theme.textTheme.headlineSmall,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintText: rangeText,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _submitGuess(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _submitGuess,
                    icon: const Icon(Icons.send),
                    label: const Text('猜！'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                  ),
                ] else ...[
                  FilledButton.icon(
                    onPressed: _resetGame,
                    icon: const Icon(Icons.replay),
                    label: const Text('再玩一次'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                if (_message.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _game.isGameOver
                          ? theme.colorScheme.errorContainer
                          : theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _message,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: _game.isGameOver
                            ? theme.colorScheme.onErrorContainer
                            : theme.colorScheme.onSecondaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 20),
                if (_game.guesses.isNotEmpty)
                  Text(
                    '已猜 ${_game.guessCount} 次：${_game.guesses.join(", ")}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

