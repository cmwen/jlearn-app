import 'package:uuid/uuid.dart';
import 'content.dart';

/// Conversation content for dialogue-based learning
class Conversation extends Content {
  final List<ConversationMessage> messages;
  final List<String>? practicePrompts;
  final List<VocabularyItem>? vocabulary;
  final String? context;
  final List<String>? characters;

  Conversation({
    required String id,
    String schemaVersion = '1.0',
    required String language,
    required String level,
    required ContentMetadata metadata,
    required this.messages,
    this.practicePrompts,
    this.vocabulary,
    this.context,
    this.characters,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isFavorite = false,
    bool isArchived = false,
  }) : super(
          id: id,
          schemaVersion: schemaVersion,
          type: 'conversation',
          language: language,
          level: level,
          metadata: metadata,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isFavorite: isFavorite,
          isArchived: isArchived,
        );

  factory Conversation.fromJson(Map<String, dynamic> json, {String? id}) {
    return Conversation(
      id: id ?? json['id'] ?? const Uuid().v4(),
      schemaVersion: json['schema_version'] ?? '1.0',
      language: json['language'] as String,
      level: json['level'] as String,
      metadata: ContentMetadata.fromJson(
        (json['metadata'] as Map<String, dynamic>?) ?? {},
      ),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ConversationMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      practicePrompts: (json['practice_prompts'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      vocabulary: (json['vocabulary'] as List<dynamic>?)
          ?.map((e) => VocabularyItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      context: (json['metadata'] as Map<String, dynamic>?)?['context'] as String?,
      characters: ((json['metadata'] as Map<String, dynamic>?)?['characters']
              as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schema_version': schemaVersion,
      'type': type,
      'language': language,
      'level': level,
      'metadata': {
        ...metadata.toJson(),
        if (context != null) 'context': context,
        if (characters != null) 'characters': characters,
      },
      'messages': messages.map((m) => m.toJson()).toList(),
      if (practicePrompts != null) 'practice_prompts': practicePrompts,
      if (vocabulary != null)
        'vocabulary': vocabulary!.map((v) => v.toJson()).toList(),
    };
  }
}

/// Individual message in a conversation
class ConversationMessage {
  final String id;
  final String speaker;
  final String text;
  final String translation;
  final String? pronunciation;
  final String? notes;

  ConversationMessage({
    required this.id,
    required this.speaker,
    required this.text,
    required this.translation,
    this.pronunciation,
    this.notes,
  });

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    return ConversationMessage(
      id: json['id'] as String,
      speaker: json['speaker'] as String,
      text: json['text'] as String,
      translation: json['translation'] as String,
      pronunciation: json['pronunciation'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speaker': speaker,
      'text': text,
      'translation': translation,
      if (pronunciation != null) 'pronunciation': pronunciation,
      if (notes != null) 'notes': notes,
    };
  }
}

/// Vocabulary item in conversation
class VocabularyItem {
  final String word;
  final String translation;
  final String? pronunciation;

  VocabularyItem({
    required this.word,
    required this.translation,
    this.pronunciation,
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) {
    return VocabularyItem(
      word: json['word'] as String,
      translation: json['translation'] as String,
      pronunciation: json['pronunciation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translation': translation,
      if (pronunciation != null) 'pronunciation': pronunciation,
    };
  }
}
