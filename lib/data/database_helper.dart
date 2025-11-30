import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vocabulary.dart';
import '../models/review_card.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('jlearn.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vocabulary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        reading TEXT NOT NULL,
        meaning TEXT NOT NULL,
        part_of_speech TEXT,
        example_sentence TEXT,
        example_reading TEXT,
        example_translation TEXT,
        jlpt_level TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE review_cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vocabulary_id INTEGER NOT NULL,
        repetitions INTEGER NOT NULL DEFAULT 0,
        ease_factor REAL NOT NULL DEFAULT 2.5,
        interval_days INTEGER NOT NULL DEFAULT 1,
        next_review_date TEXT NOT NULL,
        last_reviewed_at TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (vocabulary_id) REFERENCES vocabulary (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_next_review_date ON review_cards(next_review_date)
    ''');

    await db.execute('''
      CREATE INDEX idx_vocabulary_id ON review_cards(vocabulary_id)
    ''');
  }

  Future<int> insertVocabulary(Vocabulary vocab) async {
    final db = await database;
    return await db.insert('vocabulary', vocab.toMap());
  }

  Future<List<Vocabulary>> getAllVocabulary() async {
    final db = await database;
    final maps = await db.query('vocabulary', orderBy: 'id ASC');
    return maps.map((map) => Vocabulary.fromMap(map)).toList();
  }

  Future<Vocabulary?> getVocabularyById(int id) async {
    final db = await database;
    final maps = await db.query(
      'vocabulary',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Vocabulary.fromMap(maps.first);
  }

  Future<int> insertReviewCard(ReviewCard card) async {
    final db = await database;
    return await db.insert('review_cards', card.toMap());
  }

  Future<void> updateReviewCard(ReviewCard card) async {
    final db = await database;
    await db.update(
      'review_cards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<List<ReviewCard>> getDueReviewCards() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final maps = await db.query(
      'review_cards',
      where: 'next_review_date <= ?',
      whereArgs: [now],
      orderBy: 'next_review_date ASC',
    );
    return maps.map((map) => ReviewCard.fromMap(map)).toList();
  }

  Future<ReviewCard?> getReviewCardByVocabId(int vocabularyId) async {
    final db = await database;
    final maps = await db.query(
      'review_cards',
      where: 'vocabulary_id = ?',
      whereArgs: [vocabularyId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return ReviewCard.fromMap(maps.first);
  }

  Future<int> getTotalVocabularyCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM vocabulary',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getDueReviewCount() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM review_cards WHERE next_review_date <= ?',
      [now],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
