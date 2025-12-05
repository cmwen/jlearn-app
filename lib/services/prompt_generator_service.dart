import '../models/content.dart';

/// Service for generating prompts to send to LLMs
class PromptGeneratorService {
  /// Generate a flashcard prompt
  String generateFlashcardPrompt({
    required String language,
    required String level,
    required String topic,
    required int cardCount,
  }) {
    final languageName = _languageCodeToName(language);

    return '''Generate a flashcard set for learning $languageName at $level level.
Topic: $topic
Number of cards: $cardCount

Format your response as JSON following this exact schema:
{
  "schema_version": "1.0",
  "type": "flashcard_set",
  "language": "$language",
  "level": "$level",
  "metadata": {
    "topic": "$topic",
    "tags": ["vocabulary"],
    "description": "Brief description of the flashcard set"
  },
  "cards": [
    {
      "id": "1",
      "front": "word or phrase in target language",
      "back": "translation or explanation in English",
      "pronunciation": "romanization or phonetic guide",
      "example": "example sentence using this word",
      "example_translation": "translation of example",
      "notes": "usage notes or context"
    }
  ]
}

Important:
- Provide ONLY valid JSON, no additional text or markdown formatting
- Include exactly $cardCount cards
- Focus on practical, commonly used vocabulary for $level learners
- Include pronunciation for non-Latin scripts
- Provide example sentences for each word''';
  }

  /// Generate a quiz prompt
  String generateQuizPrompt({
    required String language,
    required String level,
    required String topic,
    required int questionCount,
  }) {
    final languageName = _languageCodeToName(language);

    return '''Generate a multiple-choice quiz for $languageName at $level level.
Topic: $topic
Number of questions: $questionCount

Format your response as JSON following this exact schema:
{
  "schema_version": "1.0",
  "type": "quiz",
  "language": "$language",
  "level": "$level",
  "metadata": {
    "topic": "$topic",
    "tags": ["quiz"],
    "description": "Brief description of the quiz"
  },
  "questions": [
    {
      "id": "q1",
      "question": "The question text (can include target language)",
      "options": [
        "Option A",
        "Option B",
        "Option C",
        "Option D"
      ],
      "correct_answer": "The correct option (must exactly match one option)",
      "explanation": "Explanation of why this answer is correct",
      "difficulty": "easy/medium/hard"
    }
  ]
}

Important:
- Provide ONLY valid JSON, no additional text or markdown formatting
- Include exactly $questionCount questions
- Each question must have exactly 4 options
- correct_answer must exactly match one of the options
- Include explanations to help learners understand
- Mix difficulty levels appropriately for $level''';
  }

  /// Get list of supported content types for UI
  List<ContentTypeOption> getContentTypes() {
    return [
      ContentTypeOption(
        type: ContentType.flashcardSet,
        label: 'Flashcards',
        description: 'Vocabulary cards with translations and examples',
        icon: 'style', // Material icon name
      ),
      ContentTypeOption(
        type: ContentType.quiz,
        label: 'Quiz',
        description: 'Multiple-choice questions to test knowledge',
        icon: 'quiz',
      ),
    ];
  }

  /// Get common topics for a language
  List<String> getCommonTopics(String language) {
    // Common topics that work well for language learning
    return [
      'Daily Greetings',
      'Food & Dining',
      'Travel & Transportation',
      'Shopping',
      'Numbers & Counting',
      'Time & Dates',
      'Family & Relationships',
      'Weather',
      'Work & Business',
      'Hobbies & Entertainment',
      'Colors & Shapes',
      'Body Parts',
      'Animals',
      'Emotions & Feelings',
      'Common Verbs',
      'Common Adjectives',
    ];
  }

  /// Convert language code to full name
  String _languageCodeToName(String code) {
    const languageNames = {
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
    };
    return languageNames[code] ?? code;
  }
}

/// Represents a content type option for UI
class ContentTypeOption {
  final ContentType type;
  final String label;
  final String description;
  final String icon;

  ContentTypeOption({
    required this.type,
    required this.label,
    required this.description,
    required this.icon,
  });
}
