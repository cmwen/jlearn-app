import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vocabulary.dart';
import '../models/review_card.dart';
import '../models/content.dart';
import '../models/flashcard_set.dart';
import '../models/quiz.dart';
import '../models/conversation.dart';
import '../models/grammar_lesson.dart';
import '../models/user_profile.dart';

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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add content table for LLM-generated content
      await _createContentTables(db);
    }
  }

  Future<void> _createContentTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS content (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        language TEXT NOT NULL,
        level TEXT NOT NULL,
        title TEXT NOT NULL,
        json_data TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        tags TEXT,
        is_favorite INTEGER DEFAULT 0,
        is_archived INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_profile (
        id TEXT PRIMARY KEY,
        languages TEXT NOT NULL,
        proficiency_level TEXT NOT NULL,
        goals TEXT,
        created_at INTEGER NOT NULL,
        last_active INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS study_sessions (
        id TEXT PRIMARY KEY,
        content_id TEXT NOT NULL,
        started_at INTEGER NOT NULL,
        completed_at INTEGER,
        score REAL,
        total_items INTEGER NOT NULL,
        correct_items INTEGER DEFAULT 0,
        data TEXT,
        FOREIGN KEY (content_id) REFERENCES content(id)
      )
    ''');

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_content_type ON content(type)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_content_language ON content(language)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_content_created ON content(created_at DESC)',
    );
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

    // Create content tables for LLM-generated content
    await _createContentTables(db);
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

  // ============ Content Methods ============

  /// Save content (flashcard set, quiz, etc.)
  Future<void> saveContent(Content content) async {
    final db = await database;
    await db.insert(
      'content',
      content.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get content by ID
  Future<Content?> getContentById(String id) async {
    final db = await database;
    final maps = await db.query(
      'content',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _mapToContent(maps.first);
  }

  /// Get all content with optional filtering
  Future<List<Content>> getAllContent({
    String? type,
    String? language,
    bool includeArchived = false,
  }) async {
    final db = await database;
    String? where;
    List<dynamic>? whereArgs;

    final conditions = <String>[];
    final args = <dynamic>[];

    if (type != null) {
      conditions.add('type = ?');
      args.add(type);
    }
    if (language != null) {
      conditions.add('language = ?');
      args.add(language);
    }
    if (!includeArchived) {
      conditions.add('is_archived = 0');
    }

    if (conditions.isNotEmpty) {
      where = conditions.join(' AND ');
      whereArgs = args;
    }

    final maps = await db.query(
      'content',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
    );

    return maps.map(_mapToContent).whereType<Content>().toList();
  }

  /// Delete content by ID
  Future<void> deleteContent(String id) async {
    final db = await database;
    await db.delete('content', where: 'id = ?', whereArgs: [id]);
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String id) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE content SET is_favorite = 1 - is_favorite, updated_at = ? WHERE id = ?',
      [DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  /// Archive content
  Future<void> archiveContent(String id) async {
    final db = await database;
    await db.update(
      'content',
      {'is_archived': 1, 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get content count by type
  Future<Map<String, int>> getContentCounts() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT type, COUNT(*) as count FROM content WHERE is_archived = 0 GROUP BY type',
    );

    final counts = <String, int>{};
    for (final row in result) {
      counts[row['type'] as String] = row['count'] as int;
    }
    return counts;
  }

  /// Get counts of content grouped by language (archived excluded by default)
  Future<Map<String, int>> getLanguageCounts({
    bool includeArchived = false,
  }) async {
    final db = await database;

    final result = await db.rawQuery(
      includeArchived
          ? 'SELECT language, COUNT(*) as count FROM content GROUP BY language'
          : 'SELECT language, COUNT(*) as count FROM content WHERE is_archived = 0 GROUP BY language',
    );

    final counts = <String, int>{};
    for (final row in result) {
      counts[row['language'] as String] = row['count'] as int;
    }
    return counts;
  }

  /// Get list of available languages with content (archived excluded by default)
  Future<List<String>> getLanguages({bool includeArchived = false}) async {
    final counts = await getLanguageCounts(includeArchived: includeArchived);
    final languages = counts.keys.toList()..sort((a, b) => a.compareTo(b));
    return languages;
  }

  /// Convert database map to Content object
  Content? _mapToContent(Map<String, dynamic> map) {
    final type = map['type'] as String;
    final jsonData =
        jsonDecode(map['json_data'] as String) as Map<String, dynamic>;

    switch (type) {
      case 'flashcard_set':
        return FlashcardSet.fromJson(jsonData, id: map['id'] as String);
      case 'quiz':
        return Quiz.fromJson(jsonData, id: map['id'] as String);
      case 'conversation':
        return Conversation.fromJson(jsonData, id: map['id'] as String);
      case 'grammar_lesson':
        return GrammarLesson.fromJson(jsonData, id: map['id'] as String);
      default:
        return null;
    }
  }

  // ============ User Profile Methods ============

  /// Get or create user profile
  Future<UserProfile> getUserProfile() async {
    final db = await database;
    final maps = await db.query('user_profile', limit: 1);

    if (maps.isEmpty) {
      final profile = UserProfile.empty();
      await db.insert('user_profile', profile.toMap());
      return profile;
    }

    return UserProfile.fromMap(maps.first);
  }

  /// Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    final db = await database;
    await db.update(
      'user_profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  /// Update last active timestamp
  Future<void> updateLastActive() async {
    final db = await database;
    await db.rawUpdate('UPDATE user_profile SET last_active = ?', [
      DateTime.now().millisecondsSinceEpoch,
    ]);
  }
}
