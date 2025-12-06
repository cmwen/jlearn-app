import 'package:flutter/material.dart';
import '../models/grammar_lesson.dart';
// removed unused import 'flutter/gestures.dart' — not used in this file

/// Screen for studying grammar lesson content
class GrammarLessonStudyScreen extends StatefulWidget {
  final GrammarLesson lesson;

  const GrammarLessonStudyScreen({super.key, required this.lesson});

  @override
  State<GrammarLessonStudyScreen> createState() =>
      _GrammarLessonStudyScreenState();
}

class _GrammarLessonStudyScreenState extends State<GrammarLessonStudyScreen> {
  int _currentSectionIndex = 0;
  final Map<String, String> _exerciseAnswers = {};
  bool _showExerciseFeedback = false;

  void _nextSection() {
    if (_currentSectionIndex < widget.lesson.sections.length - 1) {
      setState(() {
        _currentSectionIndex++;
        _showExerciseFeedback = false;
      });
    } else {
      // Show exercises if available
      if (widget.lesson.practiceExercises != null &&
          widget.lesson.practiceExercises!.isNotEmpty) {
        _showPracticeExercises();
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  void _previousSection() {
    if (_currentSectionIndex > 0) {
      setState(() {
        _currentSectionIndex--;
        _showExerciseFeedback = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final section = widget.lesson.sections[_currentSectionIndex];
    final progress = (_currentSectionIndex + 1) / widget.lesson.sections.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(value: progress),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section counter
                  Text(
                    'Section ${_currentSectionIndex + 1} of ${widget.lesson.sections.length}',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Summary (only on first section)
                  if (_currentSectionIndex == 0) ...[
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Summary',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.lesson.summary,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Section heading
                  Text(
                    section.heading,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section content based on type
                  _buildSectionContent(section),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _currentSectionIndex > 0
                        ? _previousSection
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _nextSection,
                    icon: Icon(
                      _currentSectionIndex < widget.lesson.sections.length - 1
                          ? Icons.arrow_forward
                          : Icons.check,
                    ),
                    label: Text(
                      _currentSectionIndex < widget.lesson.sections.length - 1
                          ? 'Next'
                          : 'Practice',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(GrammarSection section) {
    switch (section.type) {
      case 'example_list':
        return _buildExampleList(section);
      case 'table':
        return _buildTableContent(section);
      case 'text':
      default:
        return _buildTextContent(section);
    }
  }

  Widget _buildTextContent(GrammarSection section) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          section.content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildExampleList(GrammarSection section) {
    if (section.examples == null || section.examples!.isEmpty) {
      return _buildTextContent(section);
    }

    return Column(
      children: [
        if (section.content.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                section.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        const SizedBox(height: 8),
        ...section.examples!.map((example) => _buildExampleCard(example)),
      ],
    );
  }

  Widget _buildExampleCard(GrammarExample example) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Original',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectableText(
                    example.original,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            // Conjugated (if present)
            if (example.conjugated != null) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Form',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectableText(
                      example.conjugated!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Translation
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Meaning',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectableText(
                    example.translation,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),

            // Notes (if present)
            if (example.notes != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        example.notes!,
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
    );
  }

  Widget _buildTableContent(GrammarSection section) {
    // For now, just display as text content
    // Could be enhanced to parse markdown tables
    return _buildTextContent(section);
  }

  void _showPracticeExercises() {
    if (widget.lesson.practiceExercises == null) {
      Navigator.of(context).pop();
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Practice Exercises',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: widget.lesson.practiceExercises!.length,
                        itemBuilder: (context, exerciseIdx) {
                          final exercise =
                              widget.lesson.practiceExercises![exerciseIdx];
                          return _buildExerciseSection(
                            exercise,
                            exerciseIdx,
                            setModalState,
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Finish Lesson'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildExerciseSection(
    PracticeExercise exercise,
    int exerciseIdx,
    StateSetter setModalState,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.instruction,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...exercise.items.asMap().entries.map((entry) {
              final itemIdx = entry.key;
              final item = entry.value;
              final key = 'ex${exerciseIdx}_$itemIdx';
              return _buildExerciseItem(item, key, setModalState);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(
    ExerciseItem item,
    String key,
    StateSetter setModalState,
  ) {
    final userAnswer = _exerciseAnswers[key];
    final showAnswer = _showExerciseFeedback && userAnswer != null;
    final isCorrect =
        userAnswer?.trim().toLowerCase() == item.answer.trim().toLowerCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.prompt, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Your answer',
              border: const OutlineInputBorder(),
              suffixIcon: showAnswer
                  ? Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? Colors.green : Colors.red,
                    )
                  : null,
            ),
            onChanged: (value) {
              setModalState(() {
                _exerciseAnswers[key] = value;
              });
            },
          ),
          if (showAnswer) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCorrect
                      ? Colors.green.shade200
                      : Colors.red.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCorrect ? '✓ Correct!' : '✗ Incorrect',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCorrect
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                    ),
                  ),
                  if (!isCorrect) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Correct answer: ${item.answer}',
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ],
                  if (item.explanation != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      item.explanation!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
