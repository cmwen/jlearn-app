import 'package:sqflite/sqflite.dart';
import '../../models/vocabulary_item.dart';
import '../../models/review_record.dart';
import '../../models/srs_card.dart';
import '../database/app_database.dart';

class LearningRepository {
  final AppDatabase _database;

  LearningRepository(this._database);

  Future<List<VocabularyItem>> getAllVocabulary() async {
    final db = await _database.database;
    final maps = await db.query('vocabulary');
    return maps.map((map) => VocabularyItem.fromMap(map)).toList();
  }

  Future<VocabularyItem?> getVocabularyById(int id) async {
    final db = await _database.database;
    final maps = await db.query(
      'vocabulary',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return VocabularyItem.fromMap(maps.first);
  }

  Future<List<VocabularyItem>> getVocabularyByCategory(String category) async {
    final db = await _database.database;
    final maps = await db.query(
      'vocabulary',
      where: 'category = ?',
      whereArgs: [category],
    );
    return maps.map((map) => VocabularyItem.fromMap(map)).toList();
  }

  Future<SRSCard?> getSRSCard(int vocabularyId) async {
    final db = await _database.database;
    final maps = await db.query(
      'srs_cards',
      where: 'vocabulary_id = ?',
      whereArgs: [vocabularyId],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return SRSCard.fromMap(maps.first);
  }

  Future<SRSCard> getOrCreateSRSCard(int vocabularyId) async {
    var card = await getSRSCard(vocabularyId);

    if (card == null) {
      card = SRSCard(
        vocabularyId: vocabularyId,
        nextReviewDate: DateTime.now(),
      );
      await saveSRSCard(card);
    }

    return card;
  }

  Future<void> saveSRSCard(SRSCard card) async {
    final db = await _database.database;
    await db.insert(
      'srs_cards',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SRSCard>> getDueCards() async {
    final db = await _database.database;
    final now = DateTime.now().toIso8601String();

    final maps = await db.query(
      'srs_cards',
      where: 'next_review_date <= ?',
      whereArgs: [now],
      orderBy: 'next_review_date ASC',
    );

    return maps.map((map) => SRSCard.fromMap(map)).toList();
  }

  Future<int> saveReviewRecord(ReviewRecord record) async {
    final db = await _database.database;
    return await db.insert('review_records', record.toMap());
  }

  Future<List<ReviewRecord>> getReviewRecords({
    int? vocabularyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _database.database;

    String? where;
    List<dynamic>? whereArgs;

    if (vocabularyId != null || startDate != null || endDate != null) {
      final conditions = <String>[];
      whereArgs = [];

      if (vocabularyId != null) {
        conditions.add('vocabulary_id = ?');
        whereArgs.add(vocabularyId);
      }

      if (startDate != null) {
        conditions.add('review_date >= ?');
        whereArgs.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        conditions.add('review_date <= ?');
        whereArgs.add(endDate.toIso8601String());
      }

      where = conditions.join(' AND ');
    }

    final maps = await db.query(
      'review_records',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'review_date DESC',
    );

    return maps.map((map) => ReviewRecord.fromMap(map)).toList();
  }

  Future<List<ReviewRecord>> getRecentReviews(int limit) async {
    final db = await _database.database;
    final maps = await db.query(
      'review_records',
      orderBy: 'review_date DESC',
      limit: limit,
    );

    return maps.map((map) => ReviewRecord.fromMap(map)).toList();
  }

  Future<Map<String, int>> getStatistics() async {
    final db = await _database.database;

    final totalVocab =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM vocabulary'),
        ) ??
        0;

    final totalReviews =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM review_records'),
        ) ??
        0;

    final dueCards =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM srs_cards WHERE next_review_date <= ?',
            [DateTime.now().toIso8601String()],
          ),
        ) ??
        0;

    final masteredCards =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM srs_cards WHERE repetition_number >= 5 AND consecutive_correct >= 3',
          ),
        ) ??
        0;

    return {
      'totalVocabulary': totalVocab,
      'totalReviews': totalReviews,
      'dueCards': dueCards,
      'masteredCards': masteredCards,
    };
  }
}
