import 'content.dart';

/// A single quiz question
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;
  final int points;
  final String? difficulty;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.points = 1,
    this.difficulty,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id']?.toString() ?? '',
      question: json['question'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      correctAnswer: json['correct_answer'] as String? ?? '',
      explanation: json['explanation'] as String?,
      points: json['points'] as int? ?? 1,
      difficulty: json['difficulty'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      if (explanation != null) 'explanation': explanation,
      'points': points,
      if (difficulty != null) 'difficulty': difficulty,
    };
  }

  bool isCorrect(String answer) => answer == correctAnswer;
}

/// A quiz containing multiple questions
class Quiz extends Content {
  final List<QuizQuestion> questions;

  Quiz({
    required super.id,
    super.schemaVersion,
    required super.language,
    required super.level,
    required super.metadata,
    required this.questions,
    super.createdAt,
    super.updatedAt,
    super.isFavorite,
    super.isArchived,
  }) : super(type: ContentType.quiz.value);

  factory Quiz.fromJson(Map<String, dynamic> json, {String? id}) {
    final questions = (json['questions'] as List<dynamic>?)
            ?.map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
            .toList() ??
        [];

    return Quiz(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      schemaVersion: json['schema_version'] as String? ?? '1.0',
      language: json['language'] as String? ?? 'ja',
      level: json['level'] as String? ?? 'A1',
      metadata: json['metadata'] != null
          ? ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : ContentMetadata(),
      questions: questions,
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
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  /// Total possible points
  int get totalPoints => questions.fold(0, (sum, q) => sum + q.points);

  /// Create a copy with modifications
  Quiz copyWith({
    String? id,
    String? schemaVersion,
    String? language,
    String? level,
    ContentMetadata? metadata,
    List<QuizQuestion>? questions,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    bool? isArchived,
  }) {
    return Quiz(
      id: id ?? this.id,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      language: language ?? this.language,
      level: level ?? this.level,
      metadata: metadata ?? this.metadata,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
