import 'package:flutter_test/flutter_test.dart';
import 'package:jlearn/models/srs_card.dart';
import 'package:jlearn/services/ml/sm2_algorithm.dart';

void main() {
  group('SM2Algorithm', () {
    late SM2Algorithm sm2;

    setUp(() {
      sm2 = SM2Algorithm();
    });

    test('initializes with correct default values', () {
      final card = SRSCard(vocabularyId: 1, nextReviewDate: DateTime.now());

      expect(card.repetitionNumber, 0);
      expect(card.easinessFactor, 2.5);
      expect(card.intervalDays, 0);
    });

    test('updates card correctly for quality 5 (perfect recall)', () {
      final card = SRSCard(vocabularyId: 1, nextReviewDate: DateTime.now());

      final updatedCard = sm2.updateCard(card, 5);

      expect(updatedCard.repetitionNumber, 1);
      expect(updatedCard.intervalDays, 1);
      expect(updatedCard.easinessFactor, lessThanOrEqualTo(2.5));
      expect(updatedCard.consecutiveCorrect, 1);
      expect(updatedCard.consecutiveIncorrect, 0);
    });

    test('updates card correctly for quality 0 (total blackout)', () {
      final card = SRSCard(
        vocabularyId: 1,
        nextReviewDate: DateTime.now(),
        repetitionNumber: 3,
        intervalDays: 10,
        easinessFactor: 2.5,
      );

      final updatedCard = sm2.updateCard(card, 0);

      expect(updatedCard.repetitionNumber, 0);
      expect(updatedCard.intervalDays, 1);
      expect(updatedCard.consecutiveCorrect, 0);
      expect(updatedCard.consecutiveIncorrect, 1);
    });

    test('calculates correct intervals for progressive reviews', () {
      var card = SRSCard(vocabularyId: 1, nextReviewDate: DateTime.now());

      card = sm2.updateCard(card, 4);
      expect(card.intervalDays, 1);

      card = sm2.updateCard(card, 4);
      expect(card.intervalDays, 6);

      card = sm2.updateCard(card, 4);
      expect(card.intervalDays, greaterThan(6));
    });

    test('maintains minimum easiness factor of 1.3', () {
      var card = SRSCard(
        vocabularyId: 1,
        nextReviewDate: DateTime.now(),
        easinessFactor: 1.4,
      );

      card = sm2.updateCard(card, 0);
      card = sm2.updateCard(card, 0);
      card = sm2.updateCard(card, 0);

      expect(card.easinessFactor, greaterThanOrEqualTo(1.3));
    });

    test('tracks consecutive correct answers', () {
      var card = SRSCard(vocabularyId: 1, nextReviewDate: DateTime.now());

      card = sm2.updateCard(card, 4);
      expect(card.consecutiveCorrect, 1);

      card = sm2.updateCard(card, 5);
      expect(card.consecutiveCorrect, 2);

      card = sm2.updateCard(card, 3);
      expect(card.consecutiveCorrect, 3);
    });

    test('resets consecutive correct on failure', () {
      var card = SRSCard(
        vocabularyId: 1,
        nextReviewDate: DateTime.now(),
        consecutiveCorrect: 5,
      );

      card = sm2.updateCard(card, 2);
      expect(card.consecutiveCorrect, 0);
      expect(card.consecutiveIncorrect, 1);
    });

    test('calculates average quality correctly', () {
      var card = SRSCard(vocabularyId: 1, nextReviewDate: DateTime.now());

      card = sm2.updateCard(card, 5);
      card = sm2.updateCard(card, 3);
      card = sm2.updateCard(card, 4);

      expect(card.totalReviews, 3);
      expect(card.averageQuality, closeTo(4.0, 0.1));
    });

    test('adjusts interval based on response time', () {
      final card = SRSCard(
        vocabularyId: 1,
        nextReviewDate: DateTime.now(),
        repetitionNumber: 2,
        intervalDays: 10,
      );

      final normalCard = sm2.updateCard(card, 4, responseTimeMs: 3000);
      final slowCard = sm2.updateCard(card, 4, responseTimeMs: 15000);

      expect(slowCard.intervalDays, lessThan(normalCard.intervalDays));
    });

    test('getIntervalPreview returns correct preview', () {
      final card = SRSCard(
        vocabularyId: 1,
        nextReviewDate: DateTime.now(),
        repetitionNumber: 2,
        intervalDays: 6,
      );

      final preview = sm2.getIntervalPreview(card, 4);
      expect(preview, greaterThan(6));
    });

    test('getUpcomingReviewDates generates future dates', () {
      final card = SRSCard(vocabularyId: 1, nextReviewDate: DateTime.now());

      final dates = sm2.getUpcomingReviewDates(card, 5);

      expect(dates.length, 5);
      for (int i = 0; i < dates.length - 1; i++) {
        expect(dates[i].isBefore(dates[i + 1]), true);
      }
    });

    test('calculateRetentionRate works correctly', () {
      expect(sm2.calculateRetentionRate([5, 4, 3, 2, 1]), closeTo(0.6, 0.01));
      expect(sm2.calculateRetentionRate([5, 5, 5]), 1.0);
      expect(sm2.calculateRetentionRate([0, 1, 2]), 0.0);
      expect(sm2.calculateRetentionRate([]), 1.0);
    });
  });
}
