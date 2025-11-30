import '../../models/srs_card.dart';

class SM2Algorithm {
  static const double minEasinessFactor = 1.3;
  static const double maxEasinessFactor = 2.5;

  SRSCard updateCard(SRSCard card, int quality, {int responseTimeMs = 0}) {
    if (quality < 0 || quality > 5) {
      throw ArgumentError('Quality must be between 0 and 5');
    }

    final newCard = SRSCard(
      vocabularyId: card.vocabularyId,
      repetitionNumber: card.repetitionNumber,
      easinessFactor: card.easinessFactor,
      intervalDays: card.intervalDays,
      nextReviewDate: card.nextReviewDate,
      consecutiveCorrect: card.consecutiveCorrect,
      consecutiveIncorrect: card.consecutiveIncorrect,
      averageQuality: card.averageQuality,
      totalReviews: card.totalReviews,
    );

    newCard.totalReviews++;
    newCard.averageQuality =
        ((card.averageQuality * card.totalReviews) + quality) /
        newCard.totalReviews;

    if (quality >= 3) {
      newCard.consecutiveCorrect++;
      newCard.consecutiveIncorrect = 0;
    } else {
      newCard.consecutiveIncorrect++;
      newCard.consecutiveCorrect = 0;
    }

    final newEF =
        card.easinessFactor +
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));

    newCard.easinessFactor = newEF.clamp(minEasinessFactor, maxEasinessFactor);

    if (quality < 3) {
      newCard.repetitionNumber = 0;
      newCard.intervalDays = 1;
    } else {
      if (card.repetitionNumber == 0) {
        newCard.intervalDays = 1;
      } else if (card.repetitionNumber == 1) {
        newCard.intervalDays = 6;
      } else {
        newCard.intervalDays = (card.intervalDays * newCard.easinessFactor)
            .round();
      }
      newCard.repetitionNumber++;
    }

    if (responseTimeMs > 0 && quality >= 3) {
      final avgResponseForLevel = 5000;
      if (responseTimeMs > avgResponseForLevel * 2) {
        newCard.intervalDays = (newCard.intervalDays * 0.8).round();
      }
    }

    newCard.nextReviewDate = DateTime.now().add(
      Duration(days: newCard.intervalDays),
    );

    return newCard;
  }

  int getIntervalPreview(SRSCard card, int quality) {
    final tempCard = updateCard(card, quality);
    return tempCard.intervalDays;
  }

  List<DateTime> getUpcomingReviewDates(SRSCard card, int numberOfReviews) {
    final dates = <DateTime>[];
    var currentCard = card;

    for (var i = 0; i < numberOfReviews; i++) {
      currentCard = updateCard(currentCard, 4);
      dates.add(currentCard.nextReviewDate);
    }

    return dates;
  }

  double calculateRetentionRate(List<int> recentQualities) {
    if (recentQualities.isEmpty) return 1.0;

    final correctCount = recentQualities.where((q) => q >= 3).length;
    return correctCount / recentQualities.length;
  }
}
