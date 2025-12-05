import 'content.dart';

/// A single flashcard within a set
class Flashcard {
  final String id;
  final String front;
  final String back;
  final String? pronunciation;
  final String? example;
  final String? exampleTranslation;
  final String? notes;
  final String? imagePrompt;

  Flashcard({
    required this.id,
    required this.front,
    required this.back,
    this.pronunciation,
    this.example,
    this.exampleTranslation,
    this.notes,
    this.imagePrompt,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id']?.toString() ?? '',
      front: json['front'] as String? ?? '',
      back: json['back'] as String? ?? '',
      pronunciation: json['pronunciation'] as String?,
      example: json['example'] as String?,
      exampleTranslation: json['example_translation'] as String?,
      notes: json['notes'] as String?,
      imagePrompt: json['image_prompt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'front': front,
      'back': back,
      if (pronunciation != null) 'pronunciation': pronunciation,
      if (example != null) 'example': example,
      if (exampleTranslation != null) 'example_translation': exampleTranslation,
      if (notes != null) 'notes': notes,
      if (imagePrompt != null) 'image_prompt': imagePrompt,
    };
  }
}

/// A set of flashcards for vocabulary learning
class FlashcardSet extends Content {
  final List<Flashcard> cards;

  FlashcardSet({
    required super.id,
    super.schemaVersion,
    required super.language,
    required super.level,
    required super.metadata,
    required this.cards,
    super.createdAt,
    super.updatedAt,
    super.isFavorite,
    super.isArchived,
  }) : super(type: ContentType.flashcardSet.value);

  factory FlashcardSet.fromJson(Map<String, dynamic> json, {String? id}) {
    final cards =
        (json['cards'] as List<dynamic>?)
            ?.map((c) => Flashcard.fromJson(c as Map<String, dynamic>))
            .toList() ??
        [];

    return FlashcardSet(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      schemaVersion: json['schema_version'] as String? ?? '1.0',
      language: json['language'] as String? ?? 'ja',
      level: json['level'] as String? ?? 'A1',
      metadata: json['metadata'] != null
          ? ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : ContentMetadata(),
      cards: cards,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'schema_version': schemaVersion,
      'type': type,
      'language': language,
      'level': level,
      'metadata': metadata.toJson(),
      'cards': cards.map((c) => c.toJson()).toList(),
    };
  }

  /// Create a copy with modifications
  FlashcardSet copyWith({
    String? id,
    String? schemaVersion,
    String? language,
    String? level,
    ContentMetadata? metadata,
    List<Flashcard>? cards,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    bool? isArchived,
  }) {
    return FlashcardSet(
      id: id ?? this.id,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      language: language ?? this.language,
      level: level ?? this.level,
      metadata: metadata ?? this.metadata,
      cards: cards ?? this.cards,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
