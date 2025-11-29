class WeakPoint {
  final String category;
  final int jlptLevel;
  final double errorRate;
  final int totalAttempts;
  final int failedAttempts;
  final double averageResponseTime;
  final List<int> strugglingVocabularyIds;
  final double severity;

  WeakPoint({
    required this.category,
    required this.jlptLevel,
    required this.errorRate,
    required this.totalAttempts,
    required this.failedAttempts,
    required this.averageResponseTime,
    required this.strugglingVocabularyIds,
    required this.severity,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'jlpt_level': jlptLevel,
      'error_rate': errorRate,
      'total_attempts': totalAttempts,
      'failed_attempts': failedAttempts,
      'average_response_time': averageResponseTime,
      'struggling_vocabulary_ids': strugglingVocabularyIds.join(','),
      'severity': severity,
    };
  }

  factory WeakPoint.fromMap(Map<String, dynamic> map) {
    return WeakPoint(
      category: map['category'] as String,
      jlptLevel: map['jlpt_level'] as int,
      errorRate: map['error_rate'] as double,
      totalAttempts: map['total_attempts'] as int,
      failedAttempts: map['failed_attempts'] as int,
      averageResponseTime: map['average_response_time'] as double,
      strugglingVocabularyIds: (map['struggling_vocabulary_ids'] as String)
          .split(',')
          .where((s) => s.isNotEmpty)
          .map((s) => int.parse(s))
          .toList(),
      severity: map['severity'] as double,
    );
  }
}
