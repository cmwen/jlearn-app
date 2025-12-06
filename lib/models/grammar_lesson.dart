import 'package:uuid/uuid.dart';
import 'content.dart';

/// Grammar lesson content for structured learning
class GrammarLesson extends Content {
  final String title;
  final String summary;
  final List<GrammarSection> sections;
  final List<PracticeExercise>? practiceExercises;
  final List<String>? relatedTopics;

  GrammarLesson({
    required super.id,
    super.schemaVersion = '1.0',
    required super.language,
    required super.level,
    required super.metadata,
    required this.title,
    required this.summary,
    required this.sections,
    this.practiceExercises,
    this.relatedTopics,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isFavorite = false,
    bool isArchived = false,
  }) : super(type: 'grammar_lesson');

  factory GrammarLesson.fromJson(Map<String, dynamic> json, {String? id}) {
    return GrammarLesson(
      id: id ?? json['id'] ?? const Uuid().v4(),
      schemaVersion: json['schema_version'] ?? '1.0',
      language: json['language'] as String,
      level: json['level'] as String,
      metadata: ContentMetadata.fromJson(
        (json['metadata'] as Map<String, dynamic>?) ?? {},
      ),
      title: json['title'] as String,
      summary: json['summary'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => GrammarSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      practiceExercises: (json['practice_exercises'] as List<dynamic>?)
          ?.map((e) => PracticeExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      relatedTopics: (json['related_topics'] as List<dynamic>?)
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
      'metadata': metadata.toJson(),
      'title': title,
      'summary': summary,
      'sections': sections.map((s) => s.toJson()).toList(),
      if (practiceExercises != null)
        'practice_exercises': practiceExercises!
            .map((e) => e.toJson())
            .toList(),
      if (relatedTopics != null) 'related_topics': relatedTopics,
    };
  }
}

/// Section within a grammar lesson
class GrammarSection {
  final String heading;
  final String content;
  final String type; // text, example_list, table
  final List<GrammarExample>? examples;

  GrammarSection({
    required this.heading,
    required this.content,
    required this.type,
    this.examples,
  });

  factory GrammarSection.fromJson(Map<String, dynamic> json) {
    return GrammarSection(
      heading: json['heading'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      examples: (json['examples'] as List<dynamic>?)
          ?.map((e) => GrammarExample.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heading': heading,
      'content': content,
      'type': type,
      if (examples != null)
        'examples': examples!.map((e) => e.toJson()).toList(),
    };
  }
}

/// Example within a grammar section
class GrammarExample {
  final String original;
  final String? conjugated;
  final String translation;
  final String? notes;

  GrammarExample({
    required this.original,
    this.conjugated,
    required this.translation,
    this.notes,
  });

  factory GrammarExample.fromJson(Map<String, dynamic> json) {
    return GrammarExample(
      original: json['original'] as String,
      conjugated: json['conjugated'] as String?,
      translation: json['translation'] as String,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original': original,
      if (conjugated != null) 'conjugated': conjugated,
      'translation': translation,
      if (notes != null) 'notes': notes,
    };
  }
}

/// Practice exercise in grammar lesson
class PracticeExercise {
  final String instruction;
  final List<ExerciseItem> items;

  PracticeExercise({required this.instruction, required this.items});

  factory PracticeExercise.fromJson(Map<String, dynamic> json) {
    return PracticeExercise(
      instruction: json['instruction'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => ExerciseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instruction': instruction,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

/// Individual exercise item
class ExerciseItem {
  final String prompt;
  final String answer;
  final String? explanation;

  ExerciseItem({required this.prompt, required this.answer, this.explanation});

  factory ExerciseItem.fromJson(Map<String, dynamic> json) {
    return ExerciseItem(
      prompt: json['prompt'] as String,
      answer: json['answer'] as String,
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'answer': answer,
      if (explanation != null) 'explanation': explanation,
    };
  }
}
