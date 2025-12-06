import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/content.dart';
import '../models/user_profile.dart';
import '../services/prompt_generator_service.dart';
import 'content_import_screen.dart';

/// Screen for generating prompts to send to LLMs
class PromptGeneratorScreen extends StatefulWidget {
  const PromptGeneratorScreen({super.key});

  @override
  State<PromptGeneratorScreen> createState() => _PromptGeneratorScreenState();
}

class _PromptGeneratorScreenState extends State<PromptGeneratorScreen> {
  final PromptGeneratorService _promptService = PromptGeneratorService();
  final TextEditingController _topicController = TextEditingController();

  ContentType _selectedType = ContentType.flashcardSet;
  String _selectedLanguage = 'ja';
  String _selectedLevel = 'A1';
  int _itemCount = 10;
  String? _generatedPrompt;
  bool _promptCopied = false;

  final List<Map<String, String>> _languages = [
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'ko', 'name': 'Korean'},
    {'code': 'zh', 'name': 'Chinese'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
  ];

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _generatePrompt() {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a topic')));
      return;
    }

    String prompt;
    switch (_selectedType) {
      case ContentType.flashcardSet:
        prompt = _promptService.generateFlashcardPrompt(
          language: _selectedLanguage,
          level: _selectedLevel,
          topic: topic,
          cardCount: _itemCount,
        );
        break;
      case ContentType.quiz:
        prompt = _promptService.generateQuizPrompt(
          language: _selectedLanguage,
          level: _selectedLevel,
          topic: topic,
          questionCount: _itemCount,
        );
        break;
      case ContentType.conversation:
        prompt = _promptService.generateConversationPrompt(
          language: _selectedLanguage,
          level: _selectedLevel,
          situation: topic,
          exchangeCount: _itemCount,
        );
        break;
      case ContentType.grammarLesson:
        prompt = _promptService.generateGrammarPrompt(
          language: _selectedLanguage,
          level: _selectedLevel,
          grammarPoint: topic,
        );
        break;
      default:
        prompt = '';
    }

    setState(() {
      _generatedPrompt = prompt;
      _promptCopied = false;
    });
  }

  Future<void> _copyPrompt() async {
    if (_generatedPrompt == null) return;

    await Clipboard.setData(ClipboardData(text: _generatedPrompt!));
    setState(() => _promptCopied = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Prompt copied to clipboard!'),
          action: SnackBarAction(
            label: 'Import Response',
            onPressed: _navigateToImport,
          ),
        ),
      );
    }
  }

  void _navigateToImport() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ContentImportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Content'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildContentTypeSelector(),
            const SizedBox(height: 16),
            _buildOptionsCard(),
            const SizedBox(height: 16),
            _buildTopicInput(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _generatePrompt,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Prompt'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            if (_generatedPrompt != null) ...[
              const SizedBox(height: 24),
              _buildPromptResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContentTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SegmentedButton<ContentType>(
              segments: const [
                ButtonSegment(
                  value: ContentType.flashcardSet,
                  label: Text('Flashcards'),
                  icon: Icon(Icons.style),
                ),
                ButtonSegment(
                  value: ContentType.quiz,
                  label: Text('Quiz'),
                  icon: Icon(Icons.quiz),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedType = selected.first;
                  _generatedPrompt = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Options', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
              ),
              items: _languages.map((lang) {
                return DropdownMenuItem(
                  value: lang['code'],
                  child: Text(lang['name']!),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLanguage = value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedLevel,
              decoration: const InputDecoration(
                labelText: 'Level',
                border: OutlineInputBorder(),
              ),
              items: ProficiencyLevel.all.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(
                    '$level - ${ProficiencyLevel.description(level)}',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLevel = value);
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedType == ContentType.flashcardSet
                        ? 'Number of cards: $_itemCount'
                        : 'Number of questions: $_itemCount',
                  ),
                ),
                Slider(
                  value: _itemCount.toDouble(),
                  min: 5,
                  max: 20,
                  divisions: 15,
                  label: _itemCount.toString(),
                  onChanged: (value) {
                    setState(() => _itemCount = value.round());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Topic', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                hintText: 'e.g., Daily Greetings, Food vocabulary...',
                border: const OutlineInputBorder(),
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.lightbulb_outline),
                  tooltip: 'Suggestions',
                  onSelected: (topic) {
                    _topicController.text = topic;
                  },
                  itemBuilder: (context) {
                    return _promptService
                        .getCommonTopics(_selectedLanguage)
                        .map((topic) {
                          return PopupMenuItem(
                            value: topic,
                            child: Text(topic),
                          );
                        })
                        .toList();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptResult() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _promptCopied ? Icons.check : Icons.content_copy,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _promptCopied
                        ? 'Prompt copied! Paste it to your LLM'
                        : 'Generated Prompt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _copyPrompt,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: SelectableText(
                _generatedPrompt!,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _copyPrompt,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Prompt'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _navigateToImport,
                    icon: const Icon(Icons.download),
                    label: const Text('Import Response'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
