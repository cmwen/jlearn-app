import 'package:flutter/material.dart';
import '../models/quiz.dart';

/// Screen for taking a quiz
class QuizStudyScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizStudyScreen({super.key, required this.quiz});

  @override
  State<QuizStudyScreen> createState() => _QuizStudyScreenState();
}

class _QuizStudyScreenState extends State<QuizStudyScreen> {
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _hasAnswered = false;
  int _correctCount = 0;
  List<QuizResult> _results = [];

  QuizQuestion get _currentQuestion => widget.quiz.questions[_currentIndex];
  bool get _isLastQuestion => _currentIndex >= widget.quiz.questions.length - 1;
  bool get _isCorrect => _selectedAnswer == _currentQuestion.correctAnswer;

  void _selectAnswer(String answer) {
    if (_hasAnswered) return;

    setState(() {
      _selectedAnswer = answer;
      _hasAnswered = true;
      if (_isCorrect) {
        _correctCount++;
      }
      _results.add(
        QuizResult(
          questionId: _currentQuestion.id,
          selectedAnswer: answer,
          isCorrect: _isCorrect,
        ),
      );
    });
  }

  void _nextQuestion() {
    if (_isLastQuestion) {
      _showResultsDialog();
    } else {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _hasAnswered = false;
      });
    }
  }

  void _showResultsDialog() {
    final total = widget.quiz.questions.length;
    final accuracy = total > 0 ? (_correctCount / total * 100).round() : 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(_getResultTitle(accuracy)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildScoreCircle(accuracy),
            const SizedBox(height: 24),
            Text(
              '$_correctCount out of $total correct',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _getResultMessage(accuracy),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetQuiz();
            },
            child: const Text('Try Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showReviewMode();
            },
            child: const Text('Review Answers'),
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

  Widget _buildScoreCircle(int accuracy) {
    Color color;
    if (accuracy >= 80) {
      color = Colors.green;
    } else if (accuracy >= 60) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: accuracy / 100,
            strokeWidth: 12,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Center(
            child: Text(
              '$accuracy%',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getResultTitle(int accuracy) {
    if (accuracy >= 90) return 'Excellent! 🌟';
    if (accuracy >= 80) return 'Great Job! 🎉';
    if (accuracy >= 60) return 'Good Effort! 👍';
    if (accuracy >= 40) return 'Keep Practicing! 💪';
    return 'Don\'t Give Up! 📚';
  }

  String _getResultMessage(int accuracy) {
    if (accuracy >= 90) return 'Outstanding! You\'ve mastered this topic!';
    if (accuracy >= 80) return 'Great work! Just a few more to perfect!';
    if (accuracy >= 60)
      return 'Good progress! Review the explanations to improve.';
    if (accuracy >= 40) return 'You\'re on the right track! Keep studying.';
    return 'This is a tough topic. Review and try again!';
  }

  void _resetQuiz() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswer = null;
      _hasAnswered = false;
      _correctCount = 0;
      _results = [];
    });
  }

  void _showReviewMode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            QuizReviewScreen(quiz: widget.quiz, results: _results),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.metadata.topic ?? 'Quiz'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_currentIndex + 1}/${widget.quiz.questions.length}',
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
            value: (_currentIndex + 1) / widget.quiz.questions.length,
            backgroundColor: Colors.grey.shade200,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_currentQuestion.difficulty != null)
                            Chip(
                              label: Text(_currentQuestion.difficulty!),
                              backgroundColor: _getDifficultyColor(
                                _currentQuestion.difficulty!,
                              ),
                            ),
                          const SizedBox(height: 12),
                          Text(
                            _currentQuestion.question,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Options
                  ..._currentQuestion.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    return _buildOptionButton(option, index);
                  }),

                  // Explanation (shown after answering)
                  if (_hasAnswered && _currentQuestion.explanation != null) ...[
                    const SizedBox(height: 24),
                    Card(
                      color: _isCorrect
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb,
                                  color: _isCorrect
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Explanation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _isCorrect
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(_currentQuestion.explanation!),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Next button
          if (_hasAnswered)
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(_isLastQuestion ? 'See Results' : 'Next Question'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option, int index) {
    final letters = ['A', 'B', 'C', 'D'];
    final letter = index < letters.length ? letters[index] : '${index + 1}';

    final isSelected = _selectedAnswer == option;
    final isCorrectOption = option == _currentQuestion.correctAnswer;

    Color? backgroundColor;
    Color? borderColor;

    if (_hasAnswered) {
      if (isCorrectOption) {
        backgroundColor = Colors.green.withValues(alpha: 0.2);
        borderColor = Colors.green;
      } else if (isSelected && !isCorrectOption) {
        backgroundColor = Colors.red.withValues(alpha: 0.2);
        borderColor = Colors.red;
      }
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primaryContainer;
      borderColor = Theme.of(context).colorScheme.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _hasAnswered ? null : () => _selectAnswer(option),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor ?? Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              if (_hasAnswered)
                Icon(
                  isCorrectOption
                      ? Icons.check_circle
                      : (isSelected ? Icons.cancel : null),
                  color: isCorrectOption
                      ? Colors.green
                      : (isSelected ? Colors.red : null),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green.shade100;
      case 'medium':
        return Colors.orange.shade100;
      case 'hard':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}

/// Result of answering a quiz question
class QuizResult {
  final String questionId;
  final String selectedAnswer;
  final bool isCorrect;

  QuizResult({
    required this.questionId,
    required this.selectedAnswer,
    required this.isCorrect,
  });
}

/// Screen for reviewing quiz answers
class QuizReviewScreen extends StatelessWidget {
  final Quiz quiz;
  final List<QuizResult> results;

  const QuizReviewScreen({
    super.key,
    required this.quiz,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Answers'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quiz.questions.length,
        itemBuilder: (context, index) {
          final question = quiz.questions[index];
          final result = results.firstWhere(
            (r) => r.questionId == question.id,
            orElse: () => QuizResult(
              questionId: question.id,
              selectedAnswer: '',
              isCorrect: false,
            ),
          );

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        result.isCorrect ? Icons.check_circle : Icons.cancel,
                        color: result.isCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Question ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.question,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (!result.isCorrect &&
                      result.selectedAnswer.isNotEmpty) ...[
                    Text(
                      'Your answer: ${result.selectedAnswer}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    'Correct answer: ${question.correctAnswer}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (question.explanation != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(question.explanation!),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
