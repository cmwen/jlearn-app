import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/database_helper.dart';
import '../services/json_parser_service.dart';
import '../models/content.dart';
import '../models/flashcard_set.dart';
import '../models/quiz.dart';

/// Screen for importing JSON content from LLM responses
class ContentImportScreen extends StatefulWidget {
  final String? prefilledJson;

  const ContentImportScreen({super.key, this.prefilledJson});

  @override
  State<ContentImportScreen> createState() => _ContentImportScreenState();
}

class _ContentImportScreenState extends State<ContentImportScreen> {
  final TextEditingController _jsonController = TextEditingController();
  final JsonParserService _parser = JsonParserService();
  final DatabaseHelper _db = DatabaseHelper.instance;

  ParseResult? _parseResult;
  bool _isParsing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledJson != null) {
      _jsonController.text = widget.prefilledJson!;
      _parseJson();
    }
  }

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _jsonController.text = data!.text!;
      _parseJson();
    }
  }

  void _parseJson() {
    setState(() {
      _isParsing = true;
      _parseResult = null;
    });

    // Small delay for UI feedback
    Future.delayed(const Duration(milliseconds: 100), () {
      final result = _parser.parse(_jsonController.text);
      setState(() {
        _parseResult = result;
        _isParsing = false;
      });
    });
  }

  Future<void> _saveContent() async {
    if (_parseResult?.content == null) return;

    setState(() => _isSaving = true);

    try {
      await _db.saveContent(_parseResult!.content!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Content saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving content: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Content'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.paste),
            onPressed: _pasteFromClipboard,
            tooltip: 'Paste from clipboard',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Paste the JSON response from your LLM',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TextField(
                      controller: _jsonController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Paste JSON here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isParsing ? null : _parseJson,
                          icon: _isParsing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.check_circle_outline),
                          label: const Text('Validate JSON'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              _parseResult?.isSuccess == true && !_isSaving
                              ? _saveContent
                              : null,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: const Text('Save Content'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_parseResult != null) _buildResultPanel(),
        ],
      ),
    );
  }

  Widget _buildResultPanel() {
    final isSuccess = _parseResult!.isSuccess;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSuccess
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        border: Border(
          top: BorderSide(
            color: isSuccess ? Colors.green : Colors.red,
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isSuccess
                      ? 'Valid ${_getContentTypeName(_parseResult!.content!)}'
                      : 'Parsing Error',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSuccess
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
          if (isSuccess) ...[
            const SizedBox(height: 8),
            _buildContentPreview(_parseResult!.content!),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              _parseResult!.errorMessage ?? 'Unknown error',
              style: TextStyle(color: Colors.red.shade700),
            ),
            if (_parseResult!.suggestions.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Suggestions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...(_parseResult!.suggestions.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(s)),
                    ],
                  ),
                ),
              )),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildContentPreview(Content content) {
    if (content is FlashcardSet) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Topic: ${content.metadata.topic ?? "Untitled"}'),
          Text('Cards: ${content.cards.length}'),
          Text('Level: ${content.level}'),
          if (content.cards.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Preview: "${content.cards.first.front}" → "${content.cards.first.back}"',
              style: const TextStyle(fontStyle: FontStyle.italic),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      );
    } else if (content is Quiz) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Topic: ${content.metadata.topic ?? "Untitled"}'),
          Text('Questions: ${content.questions.length}'),
          Text('Level: ${content.level}'),
          if (content.questions.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Preview: "${content.questions.first.question}"',
              style: const TextStyle(fontStyle: FontStyle.italic),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      );
    }
    return const SizedBox.shrink();
  }

  String _getContentTypeName(Content content) {
    if (content is FlashcardSet) return 'Flashcard Set';
    if (content is Quiz) return 'Quiz';
    return 'Content';
  }
}
