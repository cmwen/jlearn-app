import 'dart:math';
import '../models/review_card.dart';

class SpacedRepetitionService {
  ReviewCard calculateNextReview(ReviewCard card, int quality) {
    if (quality < 0 || quality > 4) {
      throw ArgumentError('Quality must be between 0 and 4');
    }

    int newRepetitions = card.repetitions;
    double newEaseFactor = card.easeFactor;
    int newInterval = card.intervalDays;

    if (quality < 3) {
      newRepetitions = 0;
      newInterval = 1;
    } else {
      newRepetitions = card.repetitions + 1;

      newEaseFactor =
          card.easeFactor +
          (0.1 - (4 - quality) * (0.08 + (4 - quality) * 0.02));
      newEaseFactor = max(1.3, newEaseFactor);

      if (newRepetitions == 1) {
        newInterval = 1;
      } else if (newRepetitions == 2) {
        newInterval = 6;
      } else {
        newInterval = (card.intervalDays * newEaseFactor).round();
      }
    }

    final nextReviewDate = DateTime.now().add(Duration(days: newInterval));

    return card.copyWith(
      repetitions: newRepetitions,
      easeFactor: newEaseFactor,
      intervalDays: newInterval,
      nextReviewDate: nextReviewDate,
      lastReviewedAt: DateTime.now(),
    );
  }
}
