class ReviewRecord {
  final int id;
  final int vocabularyId;
  final DateTime reviewDate;
  final int quality;
  final int repetitionNumber;
  final double easinessFactor;
  final int intervalDays;
  final DateTime? nextReviewDate;
  final int responseTimeMs;

  ReviewRecord({
    required this.id,
    required this.vocabularyId,
    required this.reviewDate,
    required this.quality,
    required this.repetitionNumber,
    required this.easinessFactor,
    required this.intervalDays,
    this.nextReviewDate,
    required this.responseTimeMs,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vocabulary_id': vocabularyId,
      'review_date': reviewDate.toIso8601String(),
      'quality': quality,
      'repetition_number': repetitionNumber,
      'easiness_factor': easinessFactor,
      'interval_days': intervalDays,
      'next_review_date': nextReviewDate?.toIso8601String(),
      'response_time_ms': responseTimeMs,
    };
  }

  factory ReviewRecord.fromMap(Map<String, dynamic> map) {
    return ReviewRecord(
      id: map['id'] as int,
      vocabularyId: map['vocabulary_id'] as int,
      reviewDate: DateTime.parse(map['review_date'] as String),
      quality: map['quality'] as int,
      repetitionNumber: map['repetition_number'] as int,
      easinessFactor: map['easiness_factor'] as double,
      intervalDays: map['interval_days'] as int,
      nextReviewDate: map['next_review_date'] != null
          ? DateTime.parse(map['next_review_date'] as String)
          : null,
      responseTimeMs: map['response_time_ms'] as int,
    );
  }
}
