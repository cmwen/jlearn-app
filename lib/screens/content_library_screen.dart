import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/content.dart';
import '../models/flashcard_set.dart';
import '../models/quiz.dart';
import '../models/conversation.dart';
import '../models/grammar_lesson.dart';
import 'flashcard_study_screen.dart';
import 'quiz_study_screen.dart';
import 'conversation_study_screen.dart';
import 'grammar_lesson_study_screen.dart';

/// Screen for browsing and managing saved content
class ContentLibraryScreen extends StatefulWidget {
  const ContentLibraryScreen({super.key});

  @override
  State<ContentLibraryScreen> createState() => _ContentLibraryScreenState();
}

class _ContentLibraryScreenState extends State<ContentLibraryScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Content> _content = [];
  bool _isLoading = true;
  String? _filterType;
  final bool _showArchived = false;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() => _isLoading = true);

    try {
      final content = await _db.getAllContent(
        type: _filterType,
        includeArchived: _showArchived,
      );
      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading content: $e')));
      }
    }
  }

  void _openContent(Content content) {
    if (content is FlashcardSet) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FlashcardStudyScreen(flashcardSet: content),
        ),
      );
    } else if (content is Quiz) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => QuizStudyScreen(quiz: content)),
      );
    } else if (content is Conversation) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConversationStudyScreen(conversation: content),
        ),
      );
    } else if (content is GrammarLesson) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GrammarLessonStudyScreen(lesson: content),
        ),
      );
    }
  }

  Future<void> _deleteContent(Content content) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Content'),
        content: Text(
          'Are you sure you want to delete "${content.metadata.topic ?? "this content"}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _db.deleteContent(content.id);
      _loadContent();
    }
  }

  Future<void> _toggleFavorite(Content content) async {
    await _db.toggleFavorite(content.id);
    _loadContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Library'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onSelected: (value) {
              setState(() => _filterType = value);
              _loadContent();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All Types')),
              const PopupMenuItem(
                value: 'flashcard_set',
                child: Text('Flashcards'),
              ),
              const PopupMenuItem(value: 'quiz', child: Text('Quizzes')),
              const PopupMenuItem(
                value: 'conversation',
                child: Text('Conversations'),
              ),
              const PopupMenuItem(
                value: 'grammar_lesson',
                child: Text('Grammar Lessons'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _content.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadContent,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _content.length,
                itemBuilder: (context, index) {
                  return _buildContentCard(_content[index]);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No content yet',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate content using the + button',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(Content content) {
    // Determine content type info
    IconData icon;
    Color iconColor;
    int itemCount;
    String itemLabel;

    if (content is FlashcardSet) {
      icon = Icons.style;
      iconColor = Colors.blue;
      itemCount = content.cards.length;
      itemLabel = 'cards';
    } else if (content is Quiz) {
      icon = Icons.quiz;
      iconColor = Colors.purple;
      itemCount = content.questions.length;
      itemLabel = 'questions';
    } else if (content is Conversation) {
      icon = Icons.chat;
      iconColor = Colors.green;
      itemCount = content.messages.length;
      itemLabel = 'messages';
    } else if (content is GrammarLesson) {
      icon = Icons.school;
      iconColor = Colors.orange;
      itemCount = content.sections.length;
      itemLabel = 'sections';
    } else {
      icon = Icons.article;
      iconColor = Colors.grey;
      itemCount = 0;
      itemLabel = 'items';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openContent(content),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content.metadata.topic ?? 'Untitled',
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildChip(content.level),
                            const SizedBox(width: 8),
                            _buildChip('$itemCount $itemLabel'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      content.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: content.isFavorite ? Colors.red : null,
                    ),
                    onPressed: () => _toggleFavorite(content),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'study',
                        child: Row(
                          children: [
                            Icon(Icons.play_arrow),
                            SizedBox(width: 8),
                            Text('Study'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'study':
                          _openContent(content);
                          break;
                        case 'delete':
                          _deleteContent(content);
                          break;
                      }
                    },
                  ),
                ],
              ),
              if (content.metadata.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: content.metadata.tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelStyle: const TextStyle(fontSize: 12),
                      padding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                _formatDate(content.createdAt),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
