import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/review_card.dart';
import '../models/vocabulary.dart';
import '../services/spaced_repetition_service.dart';
import '../services/tts_service.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final SpacedRepetitionService _srs = SpacedRepetitionService();
  final TtsService _tts = TtsService();

  List<ReviewCard> _reviewCards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _isLoading = true;
  Vocabulary? _currentVocabulary;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _loadReviewCards();
  }

  Future<void> _initializeTts() async {
    await _tts.initialize();
  }

  Future<void> _loadReviewCards() async {
    final cards = await _db.getDueReviewCards();
    if (cards.isEmpty) {
      if (mounted) {
        Navigator.pop(context, true);
      }
      return;
    }

    final vocab = await _db.getVocabularyById(cards[0].vocabularyId);
    setState(() {
      _reviewCards = cards;
      _currentVocabulary = vocab;
      _isLoading = false;
    });
  }

  Future<void> _speakText(String text) async {
    setState(() => _isSpeaking = true);
    await _tts.speak(text);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isSpeaking = false);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _handleRating(int quality) async {
    if (_currentIndex >= _reviewCards.length) return;

    final currentCard = _reviewCards[_currentIndex];
    final updatedCard = _srs.calculateNextReview(currentCard, quality);
    await _db.updateReviewCard(updatedCard);

    if (_currentIndex + 1 >= _reviewCards.length) {
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Review session complete! Great job!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      return;
    }

    final nextVocab = await _db.getVocabularyById(
      _reviewCards[_currentIndex + 1].vocabularyId,
    );
    setState(() {
      _currentIndex++;
      _currentVocabulary = nextVocab;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentVocabulary == null) {
      return const Scaffold(body: Center(child: Text('No vocabulary found')));
    }

    final progress = (_currentIndex + 1) / _reviewCards.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review ${_currentIndex + 1}/${_reviewCards.length}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: progress, minHeight: 6),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _showAnswer ? _buildAnswerCard() : _buildQuestionCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      elevation: 8,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vocabulary',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    _currentVocabulary!.word,
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _isSpeaking
                      ? null
                      : () => _speakText(_currentVocabulary!.word),
                  tooltip: 'Play audio',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _currentVocabulary!.reading,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 48),
            const Icon(Icons.touch_app, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('Tap to reveal meaning'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => setState(() => _showAnswer = true),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Show Answer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerCard() {
    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            _currentVocabulary!.word,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isSpeaking
                                ? Icons.volume_up
                                : Icons.volume_up_outlined,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: _isSpeaking
                              ? null
                              : () => _speakText(_currentVocabulary!.word),
                          tooltip: 'Play audio',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentVocabulary!.reading,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _currentVocabulary!.meaning,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              if (_currentVocabulary!.partOfSpeech != null) ...[
                const SizedBox(height: 24),
                Text(
                  'Type: ${_currentVocabulary!.partOfSpeech}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              if (_currentVocabulary!.exampleSentence != null) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Example:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        _isSpeaking
                            ? Icons.volume_up
                            : Icons.volume_up_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: _isSpeaking
                          ? null
                          : () => _speakText(
                              _currentVocabulary!.exampleSentence!,
                            ),
                      tooltip: 'Play example',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _currentVocabulary!.exampleSentence!,
                  style: const TextStyle(fontSize: 18),
                ),
                if (_currentVocabulary!.exampleReading != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _currentVocabulary!.exampleReading!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
                if (_currentVocabulary!.exampleTranslation != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _currentVocabulary!.exampleTranslation!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ],
              const SizedBox(height: 32),
              Text(
                'How well did you know this?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildRatingButton(
                      label: 'Again',
                      emoji: '😟',
                      quality: 0,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildRatingButton(
                      label: 'Hard',
                      emoji: '😐',
                      quality: 2,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildRatingButton(
                      label: 'Good',
                      emoji: '🙂',
                      quality: 3,
                      color: Colors.lightGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildRatingButton(
                      label: 'Easy',
                      emoji: '😄',
                      quality: 4,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingButton({
    required String label,
    required String emoji,
    required int quality,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: () => _handleRating(quality),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withAlpha(25),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color, width: 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
