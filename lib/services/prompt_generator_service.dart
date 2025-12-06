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

  /// Generate a conversation prompt
  String generateConversationPrompt({
    required String language,
    required String level,
    required String situation,
    required int exchangeCount,
  }) {
    final languageName = _languageCodeToName(language);

    return '''Generate a realistic conversation for learning $languageName at $level level.
Situation: $situation
Number of exchanges: $exchangeCount

Format your response as JSON following this exact schema:
{
  "schema_version": "1.0",
  "type": "conversation",
  "language": "$language",
  "level": "$level",
  "metadata": {
    "topic": "$situation",
    "tags": ["conversation", "practice"],
    "context": "Detailed description of the situation",
    "characters": ["Speaker1", "Speaker2"]
  },
  "messages": [
    {
      "id": "msg1",
      "speaker": "Speaker1",
      "text": "Message in target language",
      "translation": "English translation",
      "pronunciation": "romanization or phonetic guide",
      "notes": "Cultural or usage notes (optional)"
    }
  ],
  "practice_prompts": [
    "Follow-up practice suggestion 1",
    "Follow-up practice suggestion 2"
  ],
  "vocabulary": [
    {
      "word": "key word from conversation",
      "translation": "English translation",
      "pronunciation": "romanization"
    }
  ]
}

Important:
- Provide ONLY valid JSON, no additional text or markdown formatting
- Include at least $exchangeCount back-and-forth exchanges (double the message count)
- Make the conversation realistic and natural
- Include cultural context where appropriate
- Messages should alternate between speakers
- Include pronunciation for non-Latin scripts
- Keep language appropriate for $level learners''';
  }

  /// Generate a grammar lesson prompt
  String generateGrammarPrompt({
    required String language,
    required String level,
    required String grammarPoint,
  }) {
    final languageName = _languageCodeToName(language);

    return '''Generate a structured grammar lesson for $languageName at $level level.
Grammar Point: $grammarPoint

Format your response as JSON following this exact schema:
{
  "schema_version": "1.0",
  "type": "grammar_lesson",
  "language": "$language",
  "level": "$level",
  "metadata": {
    "topic": "$grammarPoint",
    "tags": ["grammar"],
    "estimated_time": 15
  },
  "title": "Clear, concise title for the grammar point",
  "summary": "Brief 1-2 sentence overview of what will be learned",
  "sections": [
    {
      "heading": "Rule Explanation",
      "content": "Clear explanation of the grammar rule with markdown formatting",
      "type": "text"
    },
    {
      "heading": "Examples",
      "content": "",
      "type": "example_list",
      "examples": [
        {
          "original": "word/phrase in target language",
          "conjugated": "conjugated or modified form",
          "translation": "English translation",
          "notes": "Additional notes about usage or pattern"
        }
      ]
    },
    {
      "heading": "Common Uses",
      "content": "Explanation of when and how to use this grammar point",
      "type": "text"
    }
  ],
  "practice_exercises": [
    {
      "instruction": "Clear instruction for the exercise",
      "items": [
        {
          "prompt": "Question or prompt for the learner",
          "answer": "Correct answer",
          "explanation": "Why this answer is correct"
        }
      ]
    }
  ],
  "related_topics": [
    "Related Topic 1",
    "Related Topic 2"
  ]
}

Important:
- Provide ONLY valid JSON, no additional text or markdown formatting
- Explain clearly for $level learners (avoid overly technical terminology)
- Include at least 5 concrete examples
- Make practice exercises practical and useful
- Use markdown formatting in content sections for readability
- Focus on the most common and useful aspects of the grammar point''';
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
      ContentTypeOption(
        type: ContentType.conversation,
        label: 'Conversation',
        description: 'Dialogue-based practice for real-world scenarios',
        icon: 'chat',
      ),
      ContentTypeOption(
        type: ContentType.grammarLesson,
        label: 'Grammar Lesson',
        description: 'Structured lessons with rules and exercises',
        icon: 'school',
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
