import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../services/tts_service.dart';

/// Screen for studying conversation content
class ConversationStudyScreen extends StatefulWidget {
  final Conversation conversation;

  const ConversationStudyScreen({super.key, required this.conversation});

  @override
  State<ConversationStudyScreen> createState() =>
      _ConversationStudyScreenState();
}

class _ConversationStudyScreenState extends State<ConversationStudyScreen> {
  final TtsService _tts = TtsService();
  int _currentMessageIndex = 0;
  bool _showTranslation = false;
  bool _showPronunciation = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _tts.initialize();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _nextMessage() {
    if (_currentMessageIndex < widget.conversation.messages.length - 1) {
      setState(() {
        _currentMessageIndex++;
        _showTranslation = false;
        _showPronunciation = false;
      });
    }
  }

  void _previousMessage() {
    if (_currentMessageIndex > 0) {
      setState(() {
        _currentMessageIndex--;
        _showTranslation = false;
        _showPronunciation = false;
      });
    }
  }

  Future<void> _speakMessage(String text) async {
    setState(() => _isSpeaking = true);
    await _tts.speak(text);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isSpeaking = false);
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.conversation.messages[_currentMessageIndex];
    final progress =
        (_currentMessageIndex + 1) / widget.conversation.messages.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.metadata.topic ?? 'Conversation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showContextDialog,
            tooltip: 'Show Context',
          ),
        ],
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
                  // Message counter
                  Text(
                    'Message ${_currentMessageIndex + 1} of ${widget.conversation.messages.length}',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Speaker badge
                  _buildSpeakerBadge(message.speaker),
                  const SizedBox(height: 16),

                  // Main text card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  message.text,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isSpeaking
                                      ? Icons.volume_up
                                      : Icons.volume_up_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () => _speakMessage(message.text),
                                tooltip: 'Play audio',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pronunciation toggle
                  if (message.pronunciation != null)
                    CheckboxListTile(
                      title: const Text('Show Pronunciation'),
                      value: _showPronunciation,
                      onChanged: (value) {
                        setState(() => _showPronunciation = value ?? false);
                      },
                    ),

                  // Pronunciation
                  if (_showPronunciation && message.pronunciation != null)
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pronunciation',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message.pronunciation!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Translation toggle
                  CheckboxListTile(
                    title: const Text('Show Translation'),
                    value: _showTranslation,
                    onChanged: (value) {
                      setState(() => _showTranslation = value ?? false);
                    },
                  ),

                  // Translation
                  if (_showTranslation)
                    Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Translation',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message.translation,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Notes
                  if (message.notes != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  size: 16,
                                  color: Colors.orange.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Note',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message.notes!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                    onPressed: _currentMessageIndex > 0
                        ? _previousMessage
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _currentMessageIndex <
                            widget.conversation.messages.length - 1
                        ? _nextMessage
                        : () => Navigator.of(context).pop(),
                    icon: Icon(
                      _currentMessageIndex <
                              widget.conversation.messages.length - 1
                          ? Icons.arrow_forward
                          : Icons.check,
                    ),
                    label: Text(
                      _currentMessageIndex <
                              widget.conversation.messages.length - 1
                          ? 'Next'
                          : 'Finish',
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

  Widget _buildSpeakerBadge(String speaker) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
      // avoid deprecated withOpacity usage
      color: Theme.of(context)
        .colorScheme
        .primary
        .withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            speaker,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showContextDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conversation Context'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.conversation.context != null) ...[
                Text(
                  'Situation',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(widget.conversation.context!),
                const SizedBox(height: 16),
              ],
              if (widget.conversation.characters != null) ...[
                Text(
                  'Characters',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                ...widget.conversation.characters!.map(
                  (char) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 16),
                        const SizedBox(width: 4),
                        Text(char),
                      ],
                    ),
                  ),
                ),
              ],
              if (widget.conversation.vocabulary != null &&
                  widget.conversation.vocabulary!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Key Vocabulary',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ...widget.conversation.vocabulary!.map(
                  (vocab) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vocab.word,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(vocab.translation),
                        if (vocab.pronunciation != null)
                          Text(
                            vocab.pronunciation!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
