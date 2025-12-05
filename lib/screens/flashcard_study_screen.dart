import 'package:flutter/material.dart';
import '../models/flashcard_set.dart';
import '../services/tts_service.dart';

/// Screen for studying flashcards
class FlashcardStudyScreen extends StatefulWidget {
  final FlashcardSet flashcardSet;

  const FlashcardStudyScreen({super.key, required this.flashcardSet});

  @override
  State<FlashcardStudyScreen> createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen>
    with SingleTickerProviderStateMixin {
  final TtsService _tts = TtsService();
  
  int _currentIndex = 0;
  bool _showBack = false;
  int _knownCount = 0;
  int _reviewCount = 0;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  Flashcard get _currentCard => widget.flashcardSet.cards[_currentIndex];
  bool get _isLastCard => _currentIndex >= widget.flashcardSet.cards.length - 1;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.init();
    // Set language based on flashcard set
    await _tts.setLanguage(widget.flashcardSet.language);
  }

  @override
  void dispose() {
    _flipController.dispose();
    _tts.stop();
    super.dispose();
  }

  void _flipCard() {
    if (_showBack) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _showBack = !_showBack);
  }

  void _markKnown() {
    setState(() => _knownCount++);
    _nextCard();
  }

  void _markReview() {
    setState(() => _reviewCount++);
    _nextCard();
  }

  void _nextCard() {
    if (_isLastCard) {
      _showCompletionDialog();
    } else {
      setState(() {
        _currentIndex++;
        _showBack = false;
      });
      _flipController.reset();
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showBack = false;
      });
      _flipController.reset();
    }
  }

  void _speakFront() {
    _tts.speak(_currentCard.front);
  }

  void _showCompletionDialog() {
    final total = widget.flashcardSet.cards.length;
    final accuracy = total > 0 ? (_knownCount / total * 100).round() : 0;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Session Complete! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You reviewed all $total cards!'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatChip('Known', _knownCount, Colors.green),
                _buildStatChip('Review', _reviewCount, Colors.orange),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Accuracy: $accuracy%',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetSession();
            },
            child: const Text('Study Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int value, Color color) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color,
        child: Text(
          value.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      label: Text(label),
    );
  }

  void _resetSession() {
    setState(() {
      _currentIndex = 0;
      _knownCount = 0;
      _reviewCount = 0;
      _showBack = false;
    });
    _flipController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flashcardSet.metadata.topic ?? 'Flashcards'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_currentIndex + 1}/${widget.flashcardSet.cards.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.flashcardSet.cards.length,
            backgroundColor: Colors.grey.shade200,
          ),
          
          // Flashcard
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  _previousCard();
                } else if (details.primaryVelocity! < 0) {
                  _nextCard();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    final angle = _flipAnimation.value * 3.14159;
                    final showFront = angle < 1.5708; // π/2
                    
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: showFront
                          ? _buildCardFront()
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(3.14159),
                              child: _buildCardBack(),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.close,
                  label: 'Review',
                  color: Colors.orange,
                  onPressed: _markReview,
                ),
                _buildActionButton(
                  icon: Icons.refresh,
                  label: 'Flip',
                  color: Colors.blue,
                  onPressed: _flipCard,
                ),
                _buildActionButton(
                  icon: Icons.check,
                  label: 'Know',
                  color: Colors.green,
                  onPressed: _markKnown,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront() {
    return Card(
      elevation: 8,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentCard.front,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            if (_currentCard.pronunciation != null) ...[
              const SizedBox(height: 16),
              Text(
                _currentCard.pronunciation!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
            const SizedBox(height: 24),
            IconButton.filled(
              onPressed: _speakFront,
              icon: const Icon(Icons.volume_up),
              tooltip: 'Listen',
            ),
            const Spacer(),
            Text(
              'Tap to flip',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Card(
      elevation: 8,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentCard.back,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              if (_currentCard.example != null) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Example:',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _currentCard.example!,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                if (_currentCard.exampleTranslation != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _currentCard.exampleTranslation!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
              if (_currentCard.notes != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _currentCard.notes!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: label,
          onPressed: onPressed,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
