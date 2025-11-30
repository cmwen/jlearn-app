import 'package:flutter_test/flutter_test.dart';
import 'package:jlearn/services/spaced_repetition_service.dart';
import 'package:jlearn/models/review_card.dart';

void main() {
  group('Spaced Repetition Service', () {
    late SpacedRepetitionService srs;

    setUp(() {
      srs = SpacedRepetitionService();
    });

    test('calculates next review for quality 0 (again)', () {
      final card = ReviewCard(
        vocabularyId: 1,
        repetitions: 5,
        easeFactor: 2.5,
        intervalDays: 10,
      );

      final result = srs.calculateNextReview(card, 0);

      expect(result.repetitions, 0);
      expect(result.intervalDays, 1);
    });

    test('calculates next review for quality 3 (good)', () {
      final card = ReviewCard(
        vocabularyId: 1,
        repetitions: 0,
        easeFactor: 2.5,
        intervalDays: 1,
      );

      final result = srs.calculateNextReview(card, 3);

      expect(result.repetitions, 1);
      expect(result.intervalDays, 1);
    });

    test('calculates next review for quality 4 (easy)', () {
      final card = ReviewCard(
        vocabularyId: 1,
        repetitions: 1,
        easeFactor: 2.5,
        intervalDays: 1,
      );

      final result = srs.calculateNextReview(card, 4);

      expect(result.repetitions, 2);
      expect(result.intervalDays, 6);
    });

    test('throws error for invalid quality', () {
      final card = ReviewCard(vocabularyId: 1);

      expect(() => srs.calculateNextReview(card, 5), throwsArgumentError);
      expect(() => srs.calculateNextReview(card, -1), throwsArgumentError);
    });
  });
}
