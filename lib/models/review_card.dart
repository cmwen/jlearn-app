class ReviewCard {
  final int? id;
  final int vocabularyId;
  final int repetitions;
  final double easeFactor;
  final int intervalDays;
  final DateTime nextReviewDate;
  final DateTime lastReviewedAt;
  final DateTime createdAt;

  ReviewCard({
    this.id,
    required this.vocabularyId,
    this.repetitions = 0,
    this.easeFactor = 2.5,
    this.intervalDays = 1,
    DateTime? nextReviewDate,
    DateTime? lastReviewedAt,
    DateTime? createdAt,
  }) : nextReviewDate = nextReviewDate ?? DateTime.now(),
       lastReviewedAt = lastReviewedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vocabulary_id': vocabularyId,
      'repetitions': repetitions,
      'ease_factor': easeFactor,
      'interval_days': intervalDays,
      'next_review_date': nextReviewDate.toIso8601String(),
      'last_reviewed_at': lastReviewedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ReviewCard.fromMap(Map<String, dynamic> map) {
    return ReviewCard(
      id: map['id'],
      vocabularyId: map['vocabulary_id'],
      repetitions: map['repetitions'],
      easeFactor: map['ease_factor'],
      intervalDays: map['interval_days'],
      nextReviewDate: DateTime.parse(map['next_review_date']),
      lastReviewedAt: DateTime.parse(map['last_reviewed_at']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  ReviewCard copyWith({
    int? id,
    int? vocabularyId,
    int? repetitions,
    double? easeFactor,
    int? intervalDays,
    DateTime? nextReviewDate,
    DateTime? lastReviewedAt,
    DateTime? createdAt,
  }) {
    return ReviewCard(
      id: id ?? this.id,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      repetitions: repetitions ?? this.repetitions,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
