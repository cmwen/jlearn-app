import 'dart:math';
import '../../models/vocabulary_item.dart';
import '../../models/review_record.dart';
import '../../models/weak_point.dart';

class WeakPointDetector {
  static const int minReviewsForAnalysis = 3;
  static const double weaknessThreshold = 0.5;
  static const double severeWeaknessThreshold = 0.7;

  List<WeakPoint> detectWeakPoints(
    List<VocabularyItem> vocabulary,
    List<ReviewRecord> reviews,
  ) {
    final weakPoints = <WeakPoint>[];

    final categoryStats = _analyzeByCategoryAndLevel(vocabulary, reviews);

    for (final entry in categoryStats.entries) {
      final key = entry.key;
      final stats = entry.value;

      if (stats['totalAttempts']! < minReviewsForAnalysis) continue;

      final errorRate = stats['failedAttempts']! / stats['totalAttempts']!;

      if (errorRate >= weaknessThreshold) {
        final severity = _calculateSeverity(stats, errorRate);

        weakPoints.add(
          WeakPoint(
            category: key.split('_')[0],
            jlptLevel: int.parse(key.split('_')[1]),
            errorRate: errorRate,
            totalAttempts: stats['totalAttempts']!.toInt(),
            failedAttempts: stats['failedAttempts']!.toInt(),
            averageResponseTime: stats['avgResponseTime']!,
            strugglingVocabularyIds: stats['strugglingIds'] as List<int>,
            severity: severity,
          ),
        );
      }
    }

    weakPoints.sort((a, b) => b.severity.compareTo(a.severity));

    return weakPoints;
  }

  Map<String, dynamic> _analyzeByCategoryAndLevel(
    List<VocabularyItem> vocabulary,
    List<ReviewRecord> reviews,
  ) {
    final stats = <String, Map<String, dynamic>>{};

    final vocabMap = {for (var v in vocabulary) v.id: v};

    for (final review in reviews) {
      final vocab = vocabMap[review.vocabularyId];
      if (vocab == null) continue;

      final key = '${vocab.category}_${vocab.jlptLevel}';

      stats.putIfAbsent(
        key,
        () => {
          'totalAttempts': 0.0,
          'failedAttempts': 0.0,
          'totalResponseTime': 0.0,
          'avgResponseTime': 0.0,
          'strugglingIds': <int>[],
        },
      );

      stats[key]!['totalAttempts'] = stats[key]!['totalAttempts']! + 1;

      if (review.quality < 3) {
        stats[key]!['failedAttempts'] = stats[key]!['failedAttempts']! + 1;

        if (!(stats[key]!['strugglingIds'] as List<int>).contains(
          review.vocabularyId,
        )) {
          (stats[key]!['strugglingIds'] as List<int>).add(review.vocabularyId);
        }
      }

      stats[key]!['totalResponseTime'] =
          stats[key]!['totalResponseTime']! + review.responseTimeMs;
    }

    for (final entry in stats.entries) {
      final data = entry.value;
      data['avgResponseTime'] =
          data['totalResponseTime']! / data['totalAttempts']!;
    }

    return stats;
  }

  double _calculateSeverity(Map<String, dynamic> stats, double errorRate) {
    final errorWeight = 0.5;
    final volumeWeight = 0.3;
    final responseTimeWeight = 0.2;

    final normalizedErrorRate = errorRate;

    final maxAttempts = 100.0;
    final normalizedVolume = min(stats['totalAttempts']! / maxAttempts, 1.0);

    final avgResponseTime = stats['avgResponseTime']!;
    final expectedResponseTime = 5000.0;
    final normalizedResponseTime = min(
      (avgResponseTime - expectedResponseTime) / expectedResponseTime,
      1.0,
    ).clamp(0.0, 1.0);

    final severity =
        (normalizedErrorRate * errorWeight) +
        (normalizedVolume * volumeWeight) +
        (normalizedResponseTime * responseTimeWeight);

    return severity.clamp(0.0, 1.0);
  }

  List<int> getPriorityReviewItems(List<WeakPoint> weakPoints, int maxItems) {
    final priorityItems = <int>[];

    for (final weakPoint in weakPoints) {
      if (priorityItems.length >= maxItems) break;

      for (final vocabId in weakPoint.strugglingVocabularyIds) {
        if (priorityItems.length >= maxItems) break;
        if (!priorityItems.contains(vocabId)) {
          priorityItems.add(vocabId);
        }
      }
    }

    return priorityItems;
  }

  Map<String, dynamic> generateInsights(List<WeakPoint> weakPoints) {
    if (weakPoints.isEmpty) {
      return {
        'overallStatus': 'excellent',
        'weakCategories': <String>[],
        'recommendations': [
          'Keep up the great work! Continue regular reviews.',
        ],
      };
    }

    final severeWeaknesses = weakPoints
        .where((wp) => wp.errorRate >= severeWeaknessThreshold)
        .toList();

    final weakCategories = weakPoints.map((wp) => wp.category).toSet().toList();

    final recommendations = <String>[];

    if (severeWeaknesses.isNotEmpty) {
      recommendations.add(
        'Focus on ${severeWeaknesses.first.category} - high error rate detected',
      );
    }

    final highResponseTimeWeakness = weakPoints.firstWhere(
      (wp) => wp.averageResponseTime > 8000,
      orElse: () => weakPoints.first,
    );

    if (highResponseTimeWeakness.averageResponseTime > 8000) {
      recommendations.add(
        'Practice ${highResponseTimeWeakness.category} to improve recall speed',
      );
    }

    if (weakPoints.length > 3) {
      recommendations.add(
        'Consider reducing daily review volume and focus on mastery',
      );
    }

    return {
      'overallStatus': severeWeaknesses.isNotEmpty
          ? 'needs_attention'
          : 'improving',
      'weakCategories': weakCategories,
      'severeWeaknessCount': severeWeaknesses.length,
      'recommendations': recommendations,
    };
  }
}
