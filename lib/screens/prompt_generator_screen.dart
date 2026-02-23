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
    {'code': 'it', 'name': 'Italian'},
    {'code': 'pt', 'name': 'Portuguese'},
    {'code': 'ru', 'name': 'Russian'},
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'th', 'name': 'Thai'},
    {'code': 'vi', 'name': 'Vietnamese'},
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
      // all enum cases handled above; no default needed
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
    final options = _promptService.getContentTypes();

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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((option) {
                final isSelected = _selectedType == option.type;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_iconFromName(option.icon), size: 18),
                      const SizedBox(width: 6),
                      Text(option.label),
                    ],
                  ),
                  selected: isSelected,
                  tooltip: option.description,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = option.type;
                      _generatedPrompt = null;
                    });
                  },
                );
              }).toList(),
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
            if (_selectedType != ContentType.grammarLesson) ...[
              Row(
                children: [
                  Expanded(child: Text(_buildCountLabel())),
                  Slider(
                    value: _itemCount.toDouble(),
                    min: 4,
                    max: 20,
                    divisions: 16,
                    label: _itemCount.toString(),
                    onChanged: (value) {
                      setState(() => _itemCount = value.round());
                    },
                  ),
                ],
              ),
            ] else ...[
              Text(
                'Grammar lessons include sections and practice exercises. The prompt will request a full lesson plan.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
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

  String _buildCountLabel() {
    switch (_selectedType) {
      case ContentType.flashcardSet:
        return 'Number of cards: $_itemCount';
      case ContentType.quiz:
        return 'Number of questions: $_itemCount';
      case ContentType.conversation:
        return 'Number of exchanges: $_itemCount';
      case ContentType.grammarLesson:
        return '';
    }
  }

  IconData _iconFromName(String name) {
    switch (name) {
      case 'style':
        return Icons.style;
      case 'quiz':
        return Icons.quiz;
      case 'chat':
        return Icons.chat;
      case 'school':
        return Icons.school;
      default:
        return Icons.auto_awesome;
    }
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
