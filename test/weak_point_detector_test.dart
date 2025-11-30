import 'package:flutter_test/flutter_test.dart';
import 'package:jlearn/models/vocabulary_item.dart';
import 'package:jlearn/models/review_record.dart';
import 'package:jlearn/services/ml/weak_point_detector.dart';

void main() {
  group('WeakPointDetector', () {
    late WeakPointDetector detector;
    late List<VocabularyItem> vocabulary;

    setUp(() {
      detector = WeakPointDetector();

      vocabulary = [
        VocabularyItem(
          id: 1,
          word: '食べる',
          reading: 'たべる',
          meaning: 'to eat',
          category: 'verbs',
          jlptLevel: 5,
        ),
        VocabularyItem(
          id: 2,
          word: '飲む',
          reading: 'のむ',
          meaning: 'to drink',
          category: 'verbs',
          jlptLevel: 5,
        ),
        VocabularyItem(
          id: 3,
          word: '見る',
          reading: 'みる',
          meaning: 'to see',
          category: 'verbs',
          jlptLevel: 5,
        ),
        VocabularyItem(
          id: 4,
          word: '猫',
          reading: 'ねこ',
          meaning: 'cat',
          category: 'nouns',
          jlptLevel: 5,
        ),
        VocabularyItem(
          id: 5,
          word: '犬',
          reading: 'いぬ',
          meaning: 'dog',
          category: 'nouns',
          jlptLevel: 5,
        ),
      ];
    });

    test('detects no weak points with perfect reviews', () {
      final reviews = [
        _createReview(1, 5),
        _createReview(1, 5),
        _createReview(2, 4),
        _createReview(2, 5),
        _createReview(3, 4),
      ];

      final weakPoints = detector.detectWeakPoints(vocabulary, reviews);
      expect(weakPoints, isEmpty);
    });

    test('detects weak points with high error rate', () {
      final reviews = [
        _createReview(1, 0),
        _createReview(1, 1),
        _createReview(1, 2),
        _createReview(1, 1),
        _createReview(2, 0),
        _createReview(2, 1),
        _createReview(2, 2),
      ];

      final weakPoints = detector.detectWeakPoints(vocabulary, reviews);

      expect(weakPoints, isNotEmpty);
      expect(weakPoints.first.category, 'verbs');
      expect(weakPoints.first.errorRate, greaterThan(0.5));
    });

    test('calculates severity correctly', () {
      final reviews = List.generate(
        20,
        (i) => _createReview(1, i % 4, responseTime: 8000),
      );

      final weakPoints = detector.detectWeakPoints(vocabulary, reviews);

      if (weakPoints.isNotEmpty) {
        expect(weakPoints.first.severity, greaterThan(0.0));
        expect(weakPoints.first.severity, lessThanOrEqualTo(1.0));
      }
    });

    test('tracks struggling vocabulary IDs', () {
      final reviews = [
        _createReview(1, 1),
        _createReview(1, 0),
        _createReview(2, 2),
        _createReview(2, 1),
        _createReview(3, 3),
        _createReview(3, 4),
      ];

      final weakPoints = detector.detectWeakPoints(vocabulary, reviews);

      if (weakPoints.isNotEmpty) {
        expect(weakPoints.first.strugglingVocabularyIds, isNotEmpty);
        expect(weakPoints.first.strugglingVocabularyIds, contains(1));
        expect(weakPoints.first.strugglingVocabularyIds, contains(2));
      }
    });

    test('sorts weak points by severity', () {
      final reviews = [
        _createReview(1, 0),
        _createReview(1, 0),
        _createReview(1, 0),
        _createReview(1, 1),
        _createReview(2, 2),
        _createReview(2, 2),
        _createReview(2, 2),
        _createReview(3, 1),
        _createReview(3, 2),
        _createReview(3, 2),
      ];

      final weakPoints = detector.detectWeakPoints(vocabulary, reviews);

      if (weakPoints.length > 1) {
        for (int i = 0; i < weakPoints.length - 1; i++) {
          expect(
            weakPoints[i].severity,
            greaterThanOrEqualTo(weakPoints[i + 1].severity),
          );
        }
      }
    });

    test('requires minimum reviews for analysis', () {
      final reviews = [_createReview(1, 0), _createReview(1, 0)];

      final weakPoints = detector.detectWeakPoints(vocabulary, reviews);
      expect(weakPoints, isEmpty);
    });

    test('getPriorityReviewItems returns correct items', () {
      final reviews = [
        _createReview(1, 0),
        _createReview(1, 1),
        _createReview(1, 0),
        _createReview(2, 1),
        _createReview(2, 0),
        _createReview(2, 1),
      ];

      final weakPoints = detector.detectWeakPoints(vocabulary, reviews);
      final priorityItems = detector.getPriorityReviewItems(weakPoints, 5);

      expect(priorityItems, isNotEmpty);
      expect(priorityItems, contains(1));
      expect(priorityItems, contains(2));
    });

    test('getPriorityReviewItems respects maxItems', () {
      final reviews = List.generate(
        30,
        (i) => _createReview((i % 5) + 1, i % 3, responseTime: 3000),
      );

      final weakPoints = detector.detectWeakPoints(vocabulary, reviews);
      final priorityItems = detector.getPriorityReviewItems(weakPoints, 3);

      expect(priorityItems.length, lessThanOrEqualTo(3));
    });

    test('generateInsights returns excellent status for no weak points', () {
      final insights = detector.generateInsights([]);

      expect(insights['overallStatus'], 'excellent');
      expect(insights['weakCategories'], isEmpty);
      expect(insights['recommendations'], isNotEmpty);
    });

    test('generateInsights returns needs_attention for severe weaknesses', () {
      final reviews = List.generate(10, (i) => _createReview(1, 0));

      final weakPoints = detector.detectWeakPoints(vocabulary, reviews);
      final insights = detector.generateInsights(weakPoints);

      expect(
        insights['overallStatus'],
        anyOf(['needs_attention', 'improving']),
      );
      expect(insights['recommendations'], isNotEmpty);
    });

    test('generateInsights identifies weak categories', () {
      final reviews = [
        _createReview(1, 0),
        _createReview(1, 1),
        _createReview(1, 0),
        _createReview(2, 0),
        _createReview(2, 1),
        _createReview(2, 2),
      ];

      final weakPoints = detector.detectWeakPoints(vocabulary, reviews);
      final insights = detector.generateInsights(weakPoints);

      expect(insights['weakCategories'], isNotEmpty);
      if ((insights['weakCategories'] as List).isNotEmpty) {
        expect(insights['weakCategories'], contains('verbs'));
      }
    });

    test('analyzes by both category and JLPT level', () {
      final mixedVocab = [
        VocabularyItem(
          id: 1,
          word: '食べる',
          reading: 'たべる',
          meaning: 'to eat',
          category: 'verbs',
          jlptLevel: 5,
        ),
        VocabularyItem(
          id: 2,
          word: '勉強する',
          reading: 'べんきょうする',
          meaning: 'to study',
          category: 'verbs',
          jlptLevel: 4,
        ),
      ];

      final reviews = [
        _createReview(1, 0),
        _createReview(1, 1),
        _createReview(1, 0),
        _createReview(2, 4),
        _createReview(2, 5),
        _createReview(2, 5),
      ];

      final weakPoints = detector.detectWeakPoints(mixedVocab, reviews);

      if (weakPoints.isNotEmpty) {
        expect(weakPoints.first.jlptLevel, 5);
      }
    });

    test('considers response time in analysis', () {
      final fastReviews = [
        _createReview(1, 2, responseTime: 2000),
        _createReview(1, 2, responseTime: 2500),
        _createReview(1, 2, responseTime: 2200),
      ];

      final slowReviews = [
        _createReview(2, 2, responseTime: 10000),
        _createReview(2, 2, responseTime: 12000),
        _createReview(2, 2, responseTime: 15000),
      ];

      final weakPointsFast = detector.detectWeakPoints([
        vocabulary[0],
      ], fastReviews);
      final weakPointsSlow = detector.detectWeakPoints([
        vocabulary[1],
      ], slowReviews);

      if (weakPointsFast.isNotEmpty && weakPointsSlow.isNotEmpty) {
        expect(
          weakPointsSlow.first.averageResponseTime,
          greaterThan(weakPointsFast.first.averageResponseTime),
        );
      }
    });
  });
}

ReviewRecord _createReview(
  int vocabId,
  int quality, {
  int responseTime = 3000,
}) {
  return ReviewRecord(
    id: 0,
    vocabularyId: vocabId,
    reviewDate: DateTime.now(),
    quality: quality,
    repetitionNumber: 0,
    easinessFactor: 2.5,
    intervalDays: 1,
    nextReviewDate: DateTime.now().add(const Duration(days: 1)),
    responseTimeMs: responseTime,
  );
}
