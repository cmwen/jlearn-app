import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../services/sample_data_service.dart';
import 'review_screen.dart';
import 'prompt_generator_screen.dart';
import 'content_import_screen.dart';
import 'content_library_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final SampleDataService _sampleData = SampleDataService();

  int _dueReviewCount = 0;
  // Total vocabulary is tracked via content counts
  Map<String, int> _contentCounts = {};
  Map<String, int> _languageCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _sampleData.initializeSampleData();
    await _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    final dueCount = await _db.getDueReviewCount();
    final contentCounts = await _db.getContentCounts();
    final languageCounts = await _db.getLanguageCounts();
    setState(() {
      _dueReviewCount = dueCount;
      _contentCounts = contentCounts;
      _languageCounts = languageCounts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JLearn'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books),
            tooltip: 'Content Library',
            onPressed: _openLibrary,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildWelcomeCard(),
                  const SizedBox(height: 16),
                  _buildStatsCard(),
                  const SizedBox(height: 16),
                  _buildLLMContentCard(),
                  const SizedBox(height: 16),
                  _buildActionCard(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showGenerateOptions,
        icon: const Icon(Icons.add),
        label: const Text('Create'),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.wb_sunny,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _buildWelcomeSubtitle(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    final flashcardCount = _contentCounts['flashcard_set'] ?? 0;
    final quizCount = _contentCounts['quiz'] ?? 0;
    final conversationCount = _contentCounts['conversation'] ?? 0;
    final grammarCount = _contentCounts['grammar_lesson'] ?? 0;
    final totalContent = _contentCounts.values.fold<int>(0, (sum, val) => sum + val);

    return InkWell(
      onTap: _openLibrary,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Progress',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          totalContent > 0
                              ? '$totalContent items across ${_languageCounts.length} languages'
                              : 'Start by creating or importing content',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildStatItem(
                    icon: Icons.notifications_active,
                    label: 'Due Reviews',
                    value: '$_dueReviewCount',
                    color: Colors.orange,
                  ),
                  _buildStatItem(
                    icon: Icons.style,
                    label: 'Flashcards',
                    value: '$flashcardCount',
                    color: Colors.blue,
                  ),
                  _buildStatItem(
                    icon: Icons.quiz,
                    label: 'Quizzes',
                    value: '$quizCount',
                    color: Colors.purple,
                  ),
                  _buildStatItem(
                    icon: Icons.chat,
                    label: 'Conversations',
                    value: '$conversationCount',
                    color: Colors.green,
                  ),
                  _buildStatItem(
                    icon: Icons.school,
                    label: 'Grammar',
                    value: '$grammarCount',
                    color: Colors.teal,
                  ),
                ],
              ),
              if (_languageCounts.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Languages in your library',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _languageCounts.entries.map((entry) {
                    return Chip(
                      label: Text('${_languageName(entry.key)} (${entry.value})'),
                      avatar: const Icon(Icons.language, size: 16),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((0.08 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 28, color: color),
              const Spacer(),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildActionCard() {
    final hasContent =
        (_contentCounts['flashcard_set'] ?? 0) > 0 ||
        (_contentCounts['quiz'] ?? 0) > 0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_dueReviewCount > 0) ...[
              ElevatedButton.icon(
                onPressed: _startReview,
                icon: const Icon(Icons.play_arrow),
                label: Text('Start Review ($_dueReviewCount cards)'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (!hasContent && _dueReviewCount == 0) ...[
              Text(
                '🚀 Get Started!',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Create your first learning content using AI. Tap the "Create" button below to generate flashcards or quizzes!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ] else if (_dueReviewCount == 0) ...[
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Great! You\'re all caught up! 🎉'),
                    ),
                  );
                },
                icon: const Icon(Icons.celebration),
                label: const Text('All Caught Up!'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _buildWelcomeSubtitle() {
    if (_languageCounts.isEmpty) {
      return 'Ready to learn a new language?';
    }

    final languages = _languageCounts.keys.map(_languageName).toList();

    if (languages.length == 1) {
      return 'Ready to keep learning ${languages.first}?';
    }

    final preview = languages.take(2).join(', ');
    final extraCount = languages.length - 2;
    return extraCount > 0
        ? 'Learning $preview and $extraCount more languages'
        : 'Learning $preview';
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning!';
    if (hour < 18) return 'Good afternoon!';
    return 'Good evening!';
  }

  String _languageName(String code) {
    const names = {
      'ja': 'Japanese',
      'ko': 'Korean',
      'zh': 'Chinese',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian',
      'pt': 'Portuguese',
      'ru': 'Russian',
      'ar': 'Arabic',
      'hi': 'Hindi',
      'th': 'Thai',
      'vi': 'Vietnamese',
      'en': 'English',
    };
    return names[code] ?? code.toUpperCase();
  }

  Future<void> _startReview() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReviewScreen()),
    );

    if (result == true) {
      await _loadStats();
    }
  }

  void _openLibrary() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContentLibraryScreen()),
    ).then((_) => _loadStats());
  }

  void _showGenerateOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('Generate with AI'),
              subtitle: const Text('Create flashcards or quizzes with LLM'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PromptGeneratorScreen(),
                  ),
                ).then((_) => _loadStats());
              },
            ),
            ListTile(
              leading: const Icon(Icons.paste),
              title: const Text('Import JSON'),
              subtitle: const Text('Paste content from ChatGPT/Claude/Gemini'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContentImportScreen(),
                  ),
                ).then((_) => _loadStats());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLLMContentCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI-Powered Learning',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Generate flashcards, quizzes, conversations, and grammar lessons with your favorite LLM.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PromptGeneratorScreen(),
                        ),
                      ).then((_) => _loadStats());
                    },
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Generate'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContentImportScreen(),
                        ),
                      ).then((_) => _loadStats());
                    },
                    icon: const Icon(Icons.paste),
                    label: const Text('Import'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
