import 'dart:convert';

/// Base class for all content types
abstract class Content {
  final String id;
  final String schemaVersion;
  final String type;
  final String language;
  final String level;
  final ContentMetadata metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final bool isArchived;

  Content({
    required this.id,
    this.schemaVersion = '1.0',
    required this.type,
    required this.language,
    required this.level,
    required this.metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isFavorite = false,
    this.isArchived = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson();

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'type': type,
      'language': language,
      'level': level,
      'title': metadata.topic ?? 'Untitled',
      'json_data': jsonEncode(toJson()),
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'tags': jsonEncode(metadata.tags),
      'is_favorite': isFavorite ? 1 : 0,
      'is_archived': isArchived ? 1 : 0,
    };
  }
}

/// Metadata common to all content types
class ContentMetadata {
  final String? topic;
  final List<String> tags;
  final String? description;
  final int? timeLimit; // for quizzes

  ContentMetadata({
    this.topic,
    this.tags = const [],
    this.description,
    this.timeLimit,
  });

  factory ContentMetadata.fromJson(Map<String, dynamic> json) {
    return ContentMetadata(
      topic: json['topic'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      description: json['description'] as String?,
      timeLimit: json['time_limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (topic != null) 'topic': topic,
      'tags': tags,
      if (description != null) 'description': description,
      if (timeLimit != null) 'time_limit': timeLimit,
    };
  }
}

/// Content type enumeration
enum ContentType {
  flashcardSet('flashcard_set'),
  quiz('quiz'),
  conversation('conversation'),
  grammarLesson('grammar_lesson');

  final String value;
  const ContentType(this.value);

  static ContentType fromString(String value) {
    return ContentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ContentType.flashcardSet,
    );
  }
}
