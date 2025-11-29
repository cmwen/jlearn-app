class SRSCard {
  final int vocabularyId;
  int repetitionNumber;
  double easinessFactor;
  int intervalDays;
  DateTime nextReviewDate;
  int consecutiveCorrect;
  int consecutiveIncorrect;
  double averageQuality;
  int totalReviews;

  SRSCard({
    required this.vocabularyId,
    this.repetitionNumber = 0,
    this.easinessFactor = 2.5,
    this.intervalDays = 0,
    required this.nextReviewDate,
    this.consecutiveCorrect = 0,
    this.consecutiveIncorrect = 0,
    this.averageQuality = 0.0,
    this.totalReviews = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'vocabulary_id': vocabularyId,
      'repetition_number': repetitionNumber,
      'easiness_factor': easinessFactor,
      'interval_days': intervalDays,
      'next_review_date': nextReviewDate.toIso8601String(),
      'consecutive_correct': consecutiveCorrect,
      'consecutive_incorrect': consecutiveIncorrect,
      'average_quality': averageQuality,
      'total_reviews': totalReviews,
    };
  }

  factory SRSCard.fromMap(Map<String, dynamic> map) {
    return SRSCard(
      vocabularyId: map['vocabulary_id'] as int,
      repetitionNumber: map['repetition_number'] as int,
      easinessFactor: map['easiness_factor'] as double,
      intervalDays: map['interval_days'] as int,
      nextReviewDate: DateTime.parse(map['next_review_date'] as String),
      consecutiveCorrect: map['consecutive_correct'] as int,
      consecutiveIncorrect: map['consecutive_incorrect'] as int,
      averageQuality: map['average_quality'] as double,
      totalReviews: map['total_reviews'] as int,
    );
  }

  bool isDue() {
    return DateTime.now().isAfter(nextReviewDate) ||
        DateTime.now().isAtSameMomentAs(nextReviewDate);
  }
}
