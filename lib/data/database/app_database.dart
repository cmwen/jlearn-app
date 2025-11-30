import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'jlearn.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vocabulary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        reading TEXT NOT NULL,
        meaning TEXT NOT NULL,
        category TEXT NOT NULL,
        jlpt_level INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE review_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vocabulary_id INTEGER NOT NULL,
        review_date TEXT NOT NULL,
        quality INTEGER NOT NULL,
        repetition_number INTEGER NOT NULL,
        easiness_factor REAL NOT NULL,
        interval_days INTEGER NOT NULL,
        next_review_date TEXT,
        response_time_ms INTEGER NOT NULL,
        FOREIGN KEY (vocabulary_id) REFERENCES vocabulary (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE srs_cards (
        vocabulary_id INTEGER PRIMARY KEY,
        repetition_number INTEGER NOT NULL DEFAULT 0,
        easiness_factor REAL NOT NULL DEFAULT 2.5,
        interval_days INTEGER NOT NULL DEFAULT 0,
        next_review_date TEXT NOT NULL,
        consecutive_correct INTEGER NOT NULL DEFAULT 0,
        consecutive_incorrect INTEGER NOT NULL DEFAULT 0,
        average_quality REAL NOT NULL DEFAULT 0.0,
        total_reviews INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (vocabulary_id) REFERENCES vocabulary (id)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_review_records_vocab_id 
      ON review_records(vocabulary_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_review_records_date 
      ON review_records(review_date)
    ''');

    await db.execute('''
      CREATE INDEX idx_srs_cards_next_review 
      ON srs_cards(next_review_date)
    ''');

    await _seedSampleData(db);
  }

  Future<void> _seedSampleData(Database db) async {
    final sampleVocabulary = [
      {
        'word': '食べる',
        'reading': 'たべる',
        'meaning': 'to eat',
        'category': 'verbs',
        'jlpt_level': 5,
      },
      {
        'word': '飲む',
        'reading': 'のむ',
        'meaning': 'to drink',
        'category': 'verbs',
        'jlpt_level': 5,
      },
      {
        'word': '見る',
        'reading': 'みる',
        'meaning': 'to see',
        'category': 'verbs',
        'jlpt_level': 5,
      },
      {
        'word': '聞く',
        'reading': 'きく',
        'meaning': 'to hear/listen',
        'category': 'verbs',
        'jlpt_level': 5,
      },
      {
        'word': '話す',
        'reading': 'はなす',
        'meaning': 'to speak',
        'category': 'verbs',
        'jlpt_level': 5,
      },
      {
        'word': '猫',
        'reading': 'ねこ',
        'meaning': 'cat',
        'category': 'nouns',
        'jlpt_level': 5,
      },
      {
        'word': '犬',
        'reading': 'いぬ',
        'meaning': 'dog',
        'category': 'nouns',
        'jlpt_level': 5,
      },
      {
        'word': '本',
        'reading': 'ほん',
        'meaning': 'book',
        'category': 'nouns',
        'jlpt_level': 5,
      },
      {
        'word': '水',
        'reading': 'みず',
        'meaning': 'water',
        'category': 'nouns',
        'jlpt_level': 5,
      },
      {
        'word': '学校',
        'reading': 'がっこう',
        'meaning': 'school',
        'category': 'nouns',
        'jlpt_level': 5,
      },
      {
        'word': '大きい',
        'reading': 'おおきい',
        'meaning': 'big',
        'category': 'adjectives',
        'jlpt_level': 5,
      },
      {
        'word': '小さい',
        'reading': 'ちいさい',
        'meaning': 'small',
        'category': 'adjectives',
        'jlpt_level': 5,
      },
      {
        'word': '新しい',
        'reading': 'あたらしい',
        'meaning': 'new',
        'category': 'adjectives',
        'jlpt_level': 5,
      },
      {
        'word': '古い',
        'reading': 'ふるい',
        'meaning': 'old',
        'category': 'adjectives',
        'jlpt_level': 5,
      },
      {
        'word': '良い',
        'reading': 'よい',
        'meaning': 'good',
        'category': 'adjectives',
        'jlpt_level': 5,
      },
    ];

    for (final vocab in sampleVocabulary) {
      await db.insert('vocabulary', vocab);
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'jlearn.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
