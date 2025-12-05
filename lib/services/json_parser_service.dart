import 'dart:convert';
import '../models/content.dart';
import '../models/flashcard_set.dart';
import '../models/quiz.dart';

/// Result of parsing JSON content
class ParseResult {
  final Content? content;
  final String? errorMessage;
  final int? errorLine;
  final List<String> suggestions;

  ParseResult.success(this.content)
      : errorMessage = null,
        errorLine = null,
        suggestions = [];

  ParseResult.error(this.errorMessage, {this.errorLine, this.suggestions = const []})
      : content = null;

  bool get isSuccess => content != null;
  bool get isError => content == null;
}

/// Service for parsing JSON content from LLM responses
class JsonParserService {
  /// Parse JSON string to content object
  ParseResult parse(String input) {
    // First, try to extract JSON from markdown code blocks
    final cleanedJson = _extractJson(input);
    
    if (cleanedJson.isEmpty) {
      return ParseResult.error(
        'No JSON content found',
        suggestions: [
          'Make sure your LLM response contains valid JSON',
          'Check if the JSON is wrapped in ```json code blocks',
        ],
      );
    }

    // Try to parse as JSON
    Map<String, dynamic> json;
    try {
      json = jsonDecode(cleanedJson) as Map<String, dynamic>;
    } on FormatException catch (e) {
      return ParseResult.error(
        'Invalid JSON format: ${e.message}',
        errorLine: _findErrorLine(cleanedJson, e),
        suggestions: [
          'Check for missing commas between items',
          'Ensure all strings are properly quoted',
          'Look for unescaped special characters',
          'Verify matching brackets and braces',
        ],
      );
    }

    // Determine content type and parse
    final type = json['type'] as String?;
    if (type == null) {
      return ParseResult.error(
        'Missing "type" field in JSON',
        suggestions: [
          'Add a "type" field with value "flashcard_set" or "quiz"',
        ],
      );
    }

    return _parseByType(type, json);
  }

  /// Parse JSON based on content type
  ParseResult _parseByType(String type, Map<String, dynamic> json) {
    try {
      switch (type) {
        case 'flashcard_set':
          return _parseFlashcardSet(json);
        case 'quiz':
          return _parseQuiz(json);
        default:
          return ParseResult.error(
            'Unknown content type: $type',
            suggestions: [
              'Supported types: flashcard_set, quiz',
            ],
          );
      }
    } catch (e) {
      return ParseResult.error(
        'Error parsing content: $e',
        suggestions: [
          'Check that all required fields are present',
          'Verify field types match the schema',
        ],
      );
    }
  }

  /// Parse flashcard set JSON
  ParseResult _parseFlashcardSet(Map<String, dynamic> json) {
    // Validate required fields
    if (!json.containsKey('cards')) {
      return ParseResult.error(
        'Missing "cards" array in flashcard set',
        suggestions: ['Add a "cards" array with flashcard objects'],
      );
    }

    final cards = json['cards'];
    if (cards is! List || cards.isEmpty) {
      return ParseResult.error(
        'Cards must be a non-empty array',
        suggestions: ['Add at least one flashcard to the "cards" array'],
      );
    }

    // Validate each card
    for (int i = 0; i < cards.length; i++) {
      final card = cards[i];
      if (card is! Map<String, dynamic>) {
        return ParseResult.error('Card at index $i is not a valid object');
      }
      if (!card.containsKey('front') || !card.containsKey('back')) {
        return ParseResult.error(
          'Card at index $i missing required fields',
          suggestions: ['Each card must have "front" and "back" fields'],
        );
      }
    }

    final flashcardSet = FlashcardSet.fromJson(json);
    return ParseResult.success(flashcardSet);
  }

  /// Parse quiz JSON
  ParseResult _parseQuiz(Map<String, dynamic> json) {
    // Validate required fields
    if (!json.containsKey('questions')) {
      return ParseResult.error(
        'Missing "questions" array in quiz',
        suggestions: ['Add a "questions" array with question objects'],
      );
    }

    final questions = json['questions'];
    if (questions is! List || questions.isEmpty) {
      return ParseResult.error(
        'Questions must be a non-empty array',
        suggestions: ['Add at least one question to the "questions" array'],
      );
    }

    // Validate each question
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      if (q is! Map<String, dynamic>) {
        return ParseResult.error('Question at index $i is not a valid object');
      }
      
      final requiredFields = ['question', 'options', 'correct_answer'];
      for (final field in requiredFields) {
        if (!q.containsKey(field)) {
          return ParseResult.error(
            'Question at index $i missing "$field" field',
            suggestions: ['Each question must have: ${requiredFields.join(", ")}'],
          );
        }
      }

      final options = q['options'];
      if (options is! List || options.length < 2) {
        return ParseResult.error(
          'Question at index $i must have at least 2 options',
        );
      }

      final correctAnswer = q['correct_answer'] as String?;
      if (correctAnswer != null && !options.contains(correctAnswer)) {
        return ParseResult.error(
          'Question at index $i: correct_answer not in options',
          suggestions: ['Make sure correct_answer matches one of the options exactly'],
        );
      }
    }

    final quiz = Quiz.fromJson(json);
    return ParseResult.success(quiz);
  }

  /// Extract JSON from markdown code blocks or raw text
  String _extractJson(String input) {
    // Try to find JSON in markdown code block
    final codeBlockPattern = RegExp(r'```(?:json)?\s*([\s\S]*?)```');
    final match = codeBlockPattern.firstMatch(input);
    if (match != null) {
      return match.group(1)?.trim() ?? '';
    }

    // Try to find JSON object directly
    final jsonPattern = RegExp(r'\{[\s\S]*\}');
    final jsonMatch = jsonPattern.firstMatch(input);
    if (jsonMatch != null) {
      return jsonMatch.group(0) ?? '';
    }

    return input.trim();
  }

  /// Try to find the line number where a JSON error occurred
  int? _findErrorLine(String json, FormatException e) {
    // FormatException often includes offset, try to extract it
    final offset = e.offset;
    if (offset == null) return null;

    final lines = json.substring(0, offset).split('\n');
    return lines.length;
  }
}
