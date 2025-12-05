# JLearn - Technical Design Document
## Architecture & Implementation Specifications

**Version:** 1.0  
**Date:** 2025-11-29  
**Status:** ⚠️ PARTIALLY SUPERSEDED - See ARCHITECTURE_OVERVIEW.md

---

> ⚠️ **IMPORTANT: This document is partially outdated**
> 
> This technical design document was created for the original **offline-first app with pre-packaged content packs**. The product has pivoted to an **LLM-powered learning shell** architecture.
> 
> **What's outdated:**
> - Content Pack system (Section 2-3 database tables)
> - Build-time LLM content generation pipeline
> - Content download/sync flows
> 
> **What's still relevant:**
> - Technology stack (Flutter, SQLite, Provider)
> - Audio playback architecture
> - Spaced Repetition algorithm concepts
> - Performance optimization patterns
> 
> **Please refer to:**
> - [ARCHITECTURE_OVERVIEW.md](./ARCHITECTURE_OVERVIEW.md) - Current LLM shell architecture
> - [REQUIREMENTS_LLM_INTEGRATION.md](./REQUIREMENTS_LLM_INTEGRATION.md) - LLM integration specs
> - [ARCHITECTURE_REVIEW_UX_ALIGNMENT.md](./ARCHITECTURE_REVIEW_UX_ALIGNMENT.md) - Architecture review

---

## 1. System Architecture Overview

### 1.1 High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐  │
│  │   Home   │  Learn   │  Review  │  Search  │  Profile │  │
│  │Dashboard │  Modules │  System  │  &Dict   │ & Settings│  │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘  │
│                   (Flutter Widgets / Compose)                │
└─────────────────────────────────────────────────────────────┘
                              ▲ ▼
┌─────────────────────────────────────────────────────────────┐
│                     APPLICATION LAYER                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              State Management (Provider)              │  │
│  ├────────────┬──────────────┬──────────────────────────┤  │
│  │  Learning  │  Progress    │  Content Pack Manager    │  │
│  │  Controller│  Controller  │  (Download/Install)      │  │
│  └────────────┴──────────────┴──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ▲ ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌────────────┬──────────────┬──────────────────────────┐  │
│  │  Models    │  Repositories │  Services                │  │
│  │  (Entities)│  (Data Access)│  (Business Logic)        │  │
│  └────────────┴──────────────┴──────────────────────────┘  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Spaced Repetition │ Analytics │ Audio Player       │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              ▲ ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌──────────────┬──────────────┬──────────────────────┐    │
│  │   SQLite DB  │  File System │   SharedPreferences  │    │
│  │  (Content &  │  (Audio/     │   (User Settings)    │    │
│  │   Progress)  │   Images)    │                      │    │
│  └──────────────┴──────────────┴──────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                              ▲ ▼
┌─────────────────────────────────────────────────────────────┐
│                   BUILD-TIME PIPELINE                        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  LLM Content Generation → JSON/DB Export → Bundling │   │
│  │  (Cloud/Desktop - Not part of shipped app)          │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Technology Stack

### 2.1 Core Technologies

| Component | Technology | Version | Rationale |
|-----------|-----------|---------|-----------|
| **Framework** | Flutter | 3.10.1+ | Cross-platform, native performance, rich widgets |
| **Language** | Dart | 3.10.1+ | Type-safe, optimized for Flutter |
| **Database** | SQLite (sqflite) | 2.3.0+ | Lightweight, offline, battle-tested |
| **Audio** | audioplayers | 5.2.0+ | Simple audio playback, good performance |
| **State Mgmt** | Provider | 6.1.0+ | Simple, official, well-documented |
| **DI** | get_it | 7.6.0+ | Service locator pattern |
| **JSON** | json_serializable | 6.7.0+ | Type-safe JSON parsing |
| **Network** | dio | 5.4.0+ | HTTP client for content pack downloads |

### 2.2 Key Dependencies (pubspec.yaml additions)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Database
  sqflite: ^2.3.0
  path: ^1.8.3
  
  # State Management
  provider: ^6.1.0
  
  # Dependency Injection
  get_it: ^7.6.0
  
  # Audio
  audioplayers: ^5.2.0
  
  # JSON
  json_annotation: ^4.8.1
  
  # File Management
  path_provider: ^2.1.0
  
  # Networking (for content packs)
  dio: ^5.4.0
  
  # Utility
  intl: ^0.18.1  # Date/number formatting
  uuid: ^4.2.0   # Unique IDs
  
  # UI Enhancements
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0  # For content pack images
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  
  # Code Generation
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
  
  # Testing
  mockito: ^5.4.0
  integration_test:
    sdk: flutter
```

---

## 3. Database Schema

### 3.1 SQLite Database Design

**Database Name:** `jlearn.db`  
**Location:** `app_documents_directory/databases/`

#### Table: vocabulary

```sql
CREATE TABLE vocabulary (
    id TEXT PRIMARY KEY,
    word_kana TEXT NOT NULL,
    word_kanji TEXT,
    romaji TEXT,
    translation TEXT NOT NULL,
    part_of_speech TEXT,
    jlpt_level INTEGER,  -- 5=N5, 4=N4, etc.
    frequency_rank INTEGER,
    audio_file_path TEXT,
    content_pack_id TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (content_pack_id) REFERENCES content_packs(id)
);

CREATE INDEX idx_vocab_jlpt ON vocabulary(jlpt_level);
CREATE INDEX idx_vocab_pack ON vocabulary(content_pack_id);
CREATE INDEX idx_vocab_kana ON vocabulary(word_kana);
```

#### Table: example_sentences

```sql
CREATE TABLE example_sentences (
    id TEXT PRIMARY KEY,
    vocabulary_id TEXT NOT NULL,
    sentence_japanese TEXT NOT NULL,
    sentence_romaji TEXT,
    sentence_english TEXT NOT NULL,
    audio_file_path TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (vocabulary_id) REFERENCES vocabulary(id) ON DELETE CASCADE
);

CREATE INDEX idx_example_vocab ON example_sentences(vocabulary_id);
```

#### Table: grammar_points

```sql
CREATE TABLE grammar_points (
    id TEXT PRIMARY KEY,
    grammar_pattern TEXT NOT NULL,
    grammar_meaning TEXT NOT NULL,
    explanation TEXT NOT NULL,
    jlpt_level INTEGER,
    usage_notes TEXT,
    common_mistakes TEXT,
    content_pack_id TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (content_pack_id) REFERENCES content_packs(id)
);

CREATE INDEX idx_grammar_jlpt ON grammar_points(jlpt_level);
```

#### Table: grammar_examples

```sql
CREATE TABLE grammar_examples (
    id TEXT PRIMARY KEY,
    grammar_id TEXT NOT NULL,
    example_japanese TEXT NOT NULL,
    example_romaji TEXT,
    example_english TEXT NOT NULL,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (grammar_id) REFERENCES grammar_points(id) ON DELETE CASCADE
);

CREATE INDEX idx_grammar_ex ON grammar_examples(grammar_id);
```

#### Table: listening_content

```sql
CREATE TABLE listening_content (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    audio_file_path TEXT NOT NULL,
    transcript_japanese TEXT,
    transcript_romaji TEXT,
    transcript_english TEXT,
    duration_seconds INTEGER,
    difficulty_level INTEGER,  -- 1-5
    jlpt_level INTEGER,
    content_pack_id TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (content_pack_id) REFERENCES content_packs(id)
);
```

#### Table: listening_questions

```sql
CREATE TABLE listening_questions (
    id TEXT PRIMARY KEY,
    listening_id TEXT NOT NULL,
    question_text TEXT NOT NULL,
    correct_answer TEXT NOT NULL,
    option_a TEXT,
    option_b TEXT,
    option_c TEXT,
    option_d TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (listening_id) REFERENCES listening_content(id) ON DELETE CASCADE
);
```

#### Table: reading_passages

```sql
CREATE TABLE reading_passages (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    content_japanese TEXT NOT NULL,
    content_romaji TEXT,
    content_english TEXT,
    difficulty_level INTEGER,
    jlpt_level INTEGER,
    word_count INTEGER,
    content_pack_id TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (content_pack_id) REFERENCES content_packs(id)
);
```

#### Table: dialogues

```sql
CREATE TABLE dialogues (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    difficulty_level INTEGER,
    content_pack_id TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (content_pack_id) REFERENCES content_packs(id)
);
```

#### Table: dialogue_lines

```sql
CREATE TABLE dialogue_lines (
    id TEXT PRIMARY KEY,
    dialogue_id TEXT NOT NULL,
    line_number INTEGER NOT NULL,
    speaker TEXT NOT NULL,
    text_japanese TEXT NOT NULL,
    text_romaji TEXT,
    text_english TEXT NOT NULL,
    audio_file_path TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (dialogue_id) REFERENCES dialogues(id) ON DELETE CASCADE
);

CREATE INDEX idx_dialog_line ON dialogue_lines(dialogue_id, line_number);
```

#### Table: content_packs

```sql
CREATE TABLE content_packs (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    version TEXT NOT NULL,
    size_bytes INTEGER,
    is_installed INTEGER DEFAULT 0,  -- 0=not installed, 1=installed
    is_base_pack INTEGER DEFAULT 0,  -- 1=shipped with app
    download_url TEXT,
    installed_at INTEGER,
    created_at INTEGER NOT NULL
);
```

#### Table: user_progress

```sql
CREATE TABLE user_progress (
    id TEXT PRIMARY KEY,
    user_id TEXT DEFAULT 'default',  -- For future multi-user support
    content_type TEXT NOT NULL,  -- 'vocabulary', 'grammar', 'listening', etc.
    content_id TEXT NOT NULL,
    status TEXT NOT NULL,  -- 'new', 'learning', 'reviewing', 'mastered'
    familiarity_level INTEGER DEFAULT 0,  -- 0-5 scale
    times_reviewed INTEGER DEFAULT 0,
    times_correct INTEGER DEFAULT 0,
    times_incorrect INTEGER DEFAULT 0,
    last_reviewed_at INTEGER,
    next_review_at INTEGER,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL,
    UNIQUE(user_id, content_type, content_id)
);

CREATE INDEX idx_progress_next_review ON user_progress(next_review_at);
CREATE INDEX idx_progress_status ON user_progress(status);
```

#### Table: quiz_sessions

```sql
CREATE TABLE quiz_sessions (
    id TEXT PRIMARY KEY,
    quiz_type TEXT NOT NULL,  -- 'vocabulary', 'grammar', 'mixed', etc.
    total_questions INTEGER NOT NULL,
    correct_answers INTEGER NOT NULL,
    score_percentage REAL NOT NULL,
    duration_seconds INTEGER,
    completed_at INTEGER NOT NULL,
    created_at INTEGER NOT NULL
);
```

#### Table: quiz_results

```sql
CREATE TABLE quiz_results (
    id TEXT PRIMARY KEY,
    session_id TEXT NOT NULL,
    content_type TEXT NOT NULL,
    content_id TEXT NOT NULL,
    user_answer TEXT,
    correct_answer TEXT NOT NULL,
    is_correct INTEGER NOT NULL,  -- 0 or 1
    created_at INTEGER NOT NULL,
    FOREIGN KEY (session_id) REFERENCES quiz_sessions(id) ON DELETE CASCADE
);

CREATE INDEX idx_quiz_result_session ON quiz_results(session_id);
```

#### Table: user_settings

```sql
CREATE TABLE user_settings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    updated_at INTEGER NOT NULL
);
```

#### Table: user_stats

```sql
CREATE TABLE user_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    stat_date INTEGER NOT NULL,  -- Unix timestamp (day start)
    total_xp INTEGER DEFAULT 0,
    words_learned INTEGER DEFAULT 0,
    lessons_completed INTEGER DEFAULT 0,
    quiz_score_average REAL DEFAULT 0.0,
    study_time_seconds INTEGER DEFAULT 0,
    created_at INTEGER NOT NULL,
    UNIQUE(stat_date)
);

CREATE INDEX idx_stats_date ON user_stats(stat_date);
```

### 3.2 Database Migrations Strategy

```dart
// lib/data/database_helper.dart

class DatabaseHelper {
  static const String _databaseName = "jlearn.db";
  static const int _databaseVersion = 1;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    // Execute all CREATE TABLE statements
    await db.execute('''CREATE TABLE vocabulary (...)''');
    await db.execute('''CREATE TABLE example_sentences (...)''');
    // ... etc
  }
  
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations
    if (oldVersion < 2) {
      // Migration v1 -> v2
    }
  }
}
```

---

## 4. Core Domain Models

### 4.1 Vocabulary Model

```dart
// lib/models/vocabulary.dart

import 'package:json_annotation/json_annotation.dart';

part 'vocabulary.g.dart';

@JsonSerializable()
class Vocabulary {
  final String id;
  final String wordKana;
  final String? wordKanji;
  final String? romaji;
  final String translation;
  final String? partOfSpeech;
  final int? jlptLevel;
  final int? frequencyRank;
  final String? audioFilePath;
  final String? contentPackId;
  final DateTime createdAt;
  
  // Not stored in DB, loaded separately
  List<ExampleSentence>? examples;

  Vocabulary({
    required this.id,
    required this.wordKana,
    this.wordKanji,
    this.romaji,
    required this.translation,
    this.partOfSpeech,
    this.jlptLevel,
    this.frequencyRank,
    this.audioFilePath,
    this.contentPackId,
    required this.createdAt,
    this.examples,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) => 
      _$VocabularyFromJson(json);
  
  Map<String, dynamic> toJson() => _$VocabularyToJson(this);
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word_kana': wordKana,
      'word_kanji': wordKanji,
      'romaji': romaji,
      'translation': translation,
      'part_of_speech': partOfSpeech,
      'jlpt_level': jlptLevel,
      'frequency_rank': frequencyRank,
      'audio_file_path': audioFilePath,
      'content_pack_id': contentPackId,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
  
  factory Vocabulary.fromMap(Map<String, dynamic> map) {
    return Vocabulary(
      id: map['id'],
      wordKana: map['word_kana'],
      wordKanji: map['word_kanji'],
      romaji: map['romaji'],
      translation: map['translation'],
      partOfSpeech: map['part_of_speech'],
      jlptLevel: map['jlpt_level'],
      frequencyRank: map['frequency_rank'],
      audioFilePath: map['audio_file_path'],
      contentPackId: map['content_pack_id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}
```

### 4.2 User Progress Model

```dart
// lib/models/user_progress.dart

enum ProgressStatus {
  newItem,
  learning,
  reviewing,
  mastered,
}

class UserProgress {
  final String id;
  final String userId;
  final String contentType;
  final String contentId;
  final ProgressStatus status;
  final int familiarityLevel;  // 0-5
  final int timesReviewed;
  final int timesCorrect;
  final int timesIncorrect;
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProgress({
    required this.id,
    required this.userId,
    required this.contentType,
    required this.contentId,
    required this.status,
    required this.familiarityLevel,
    required this.timesReviewed,
    required this.timesCorrect,
    required this.timesIncorrect,
    this.lastReviewedAt,
    this.nextReviewAt,
    required this.createdAt,
    required this.updatedAt,
  });

  double get accuracy {
    if (timesReviewed == 0) return 0.0;
    return timesCorrect / timesReviewed;
  }
  
  bool get isDueForReview {
    if (nextReviewAt == null) return true;
    return DateTime.now().isAfter(nextReviewAt!);
  }

  // Map conversion methods...
}
```

---

## 5. Repository Pattern

### 5.1 Base Repository Interface

```dart
// lib/data/repositories/base_repository.dart

abstract class BaseRepository<T> {
  Future<T?> getById(String id);
  Future<List<T>> getAll();
  Future<String> insert(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
}
```

### 5.2 Vocabulary Repository

```dart
// lib/data/repositories/vocabulary_repository.dart

class VocabularyRepository implements BaseRepository<Vocabulary> {
  final DatabaseHelper _dbHelper;

  VocabularyRepository(this._dbHelper);

  @override
  Future<Vocabulary?> getById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'vocabulary',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    
    final vocab = Vocabulary.fromMap(maps.first);
    vocab.examples = await _getExamples(id);
    return vocab;
  }

  Future<List<Vocabulary>> getByJlptLevel(int level) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'vocabulary',
      where: 'jlpt_level = ?',
      whereArgs: [level],
      orderBy: 'frequency_rank ASC',
    );
    
    return maps.map((map) => Vocabulary.fromMap(map)).toList();
  }

  Future<List<Vocabulary>> searchByWord(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'vocabulary',
      where: 'word_kana LIKE ? OR word_kanji LIKE ? OR translation LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      limit: 50,
    );
    
    return maps.map((map) => Vocabulary.fromMap(map)).toList();
  }

  Future<List<ExampleSentence>> _getExamples(String vocabId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'example_sentences',
      where: 'vocabulary_id = ?',
      whereArgs: [vocabId],
    );
    
    return maps.map((map) => ExampleSentence.fromMap(map)).toList();
  }

  // Insert, update, delete methods...
}
```

---

## 6. Spaced Repetition Algorithm

### 6.1 SM-2 Algorithm Implementation

```dart
// lib/services/spaced_repetition_service.dart

class SpacedRepetitionService {
  /// SM-2 algorithm for calculating next review interval
  /// 
  /// Parameters:
  /// - quality: 0-5 (0=complete blackout, 5=perfect response)
  /// - easeFactor: Difficulty multiplier (default 2.5)
  /// - interval: Days since last review
  /// - repetitions: Number of correct reviews in a row
  /// 
  /// Returns: NextReviewData with new interval and ease factor
  NextReviewData calculateNextReview({
    required int quality,
    required double easeFactor,
    required int interval,
    required int repetitions,
  }) {
    assert(quality >= 0 && quality <= 5);
    
    double newEaseFactor = easeFactor;
    int newInterval = interval;
    int newRepetitions = repetitions;

    if (quality < 3) {
      // Incorrect answer - reset
      newRepetitions = 0;
      newInterval = 1;
    } else {
      // Correct answer
      newRepetitions = repetitions + 1;
      
      if (repetitions == 0) {
        newInterval = 1;
      } else if (repetitions == 1) {
        newInterval = 6;
      } else {
        newInterval = (interval * easeFactor).round();
      }
      
      // Update ease factor
      newEaseFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
      if (newEaseFactor < 1.3) {
        newEaseFactor = 1.3;
      }
    }

    final nextReviewDate = DateTime.now().add(Duration(days: newInterval));

    return NextReviewData(
      interval: newInterval,
      easeFactor: newEaseFactor,
      repetitions: newRepetitions,
      nextReviewDate: nextReviewDate,
    );
  }

  /// Get items due for review
  Future<List<UserProgress>> getDueReviews({int limit = 20}) async {
    final progressRepo = getIt<UserProgressRepository>();
    final now = DateTime.now();
    
    return await progressRepo.getItemsDueForReview(
      before: now,
      limit: limit,
    );
  }

  /// Update progress after review
  Future<void> recordReview({
    required UserProgress progress,
    required bool wasCorrect,
    required int quality,
  }) async {
    final progressRepo = getIt<UserProgressRepository>();
    
    final nextReview = calculateNextReview(
      quality: quality,
      easeFactor: progress.familiarityLevel / 2.0,  // Convert 0-5 to SM-2 ease
      interval: progress.lastReviewedAt != null
          ? DateTime.now().difference(progress.lastReviewedAt!).inDays
          : 0,
      repetitions: progress.timesCorrect,
    );

    final updatedProgress = UserProgress(
      id: progress.id,
      userId: progress.userId,
      contentType: progress.contentType,
      contentId: progress.contentId,
      status: _calculateStatus(nextReview.repetitions),
      familiarityLevel: (nextReview.easeFactor * 2).clamp(0, 5).toInt(),
      timesReviewed: progress.timesReviewed + 1,
      timesCorrect: wasCorrect ? progress.timesCorrect + 1 : progress.timesCorrect,
      timesIncorrect: wasCorrect ? progress.timesIncorrect : progress.timesIncorrect + 1,
      lastReviewedAt: DateTime.now(),
      nextReviewAt: nextReview.nextReviewDate,
      createdAt: progress.createdAt,
      updatedAt: DateTime.now(),
    );

    await progressRepo.update(updatedProgress);
  }

  ProgressStatus _calculateStatus(int repetitions) {
    if (repetitions == 0) return ProgressStatus.learning;
    if (repetitions < 3) return ProgressStatus.reviewing;
    return ProgressStatus.mastered;
  }
}

class NextReviewData {
  final int interval;
  final double easeFactor;
  final int repetitions;
  final DateTime nextReviewDate;

  NextReviewData({
    required this.interval,
    required this.easeFactor,
    required this.repetitions,
    required this.nextReviewDate,
  });
}
```

---

## 7. Content Pack System

### 7.1 Content Pack Structure

```
content_pack/
├── manifest.json           # Pack metadata
├── content/
│   ├── vocabulary.json     # Vocabulary items
│   ├── grammar.json        # Grammar points
│   ├── listening.json      # Listening content metadata
│   └── reading.json        # Reading passages
└── assets/
    ├── audio/
    │   ├── vocab/
    │   ├── listening/
    │   └── dialogues/
    └── images/
```

### 7.2 Manifest Schema

```json
{
  "id": "jlpt-n5-complete",
  "name": "JLPT N5 Complete Pack",
  "description": "Full curriculum for JLPT N5 preparation",
  "version": "1.0.0",
  "size_bytes": 157286400,
  "content_types": ["vocabulary", "grammar", "listening", "reading"],
  "content_counts": {
    "vocabulary": 1500,
    "grammar": 80,
    "listening": 50,
    "reading": 30
  },
  "dependencies": [],
  "created_at": "2025-11-29T00:00:00Z",
  "checksum": "sha256:abc123..."
}
```

### 7.3 Content Pack Manager

```dart
// lib/services/content_pack_manager.dart

class ContentPackManager {
  final DatabaseHelper _dbHelper;
  final Dio _dio;

  Future<void> downloadContentPack(String packId, {
    Function(double)? onProgress,
  }) async {
    // 1. Get pack info from server/GitHub
    final packInfo = await _fetchPackInfo(packId);
    
    // 2. Download pack ZIP
    final tempDir = await getTemporaryDirectory();
    final savePath = '${tempDir.path}/$packId.zip';
    
    await _dio.download(
      packInfo.downloadUrl,
      savePath,
      onReceiveProgress: (received, total) {
        if (onProgress != null && total != -1) {
          onProgress(received / total);
        }
      },
    );
    
    // 3. Extract ZIP
    await _extractPack(savePath, packId);
    
    // 4. Import content to database
    await _importPackContent(packId);
    
    // 5. Mark as installed
    await _markPackInstalled(packId);
    
    // 6. Clean up temp files
    await File(savePath).delete();
  }

  Future<void> _importPackContent(String packId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final packDir = Directory('${appDir.path}/content_packs/$packId');
    
    // Import vocabulary
    final vocabFile = File('${packDir.path}/content/vocabulary.json');
    if (await vocabFile.exists()) {
      final vocabJson = jsonDecode(await vocabFile.readAsString());
      await _importVocabulary(vocabJson, packId);
    }
    
    // Import grammar
    final grammarFile = File('${packDir.path}/content/grammar.json');
    if (await grammarFile.exists()) {
      final grammarJson = jsonDecode(await grammarFile.readAsString());
      await _importGrammar(grammarJson, packId);
    }
    
    // ... similar for other content types
  }

  Future<void> removeContentPack(String packId) async {
    // 1. Delete from database
    await _deletePackContent(packId);
    
    // 2. Delete files
    final appDir = await getApplicationDocumentsDirectory();
    final packDir = Directory('${appDir.path}/content_packs/$packId');
    if (await packDir.exists()) {
      await packDir.delete(recursive: true);
    }
    
    // 3. Update pack status
    await _markPackUninstalled(packId);
  }
}
```

---

## 8. State Management Architecture

### 8.1 Provider Setup

```dart
// lib/main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await setupDependencies();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<LearningController>()),
        ChangeNotifierProvider(create: (_) => getIt<ProgressController>()),
        ChangeNotifierProvider(create: (_) => getIt<ContentPackController>()),
        ChangeNotifierProvider(create: (_) => getIt<SettingsController>()),
      ],
      child: const JLearnApp(),
    ),
  );
}
```

### 8.2 Learning Controller

```dart
// lib/controllers/learning_controller.dart

class LearningController extends ChangeNotifier {
  final VocabularyRepository _vocabRepo;
  final UserProgressRepository _progressRepo;
  final SpacedRepetitionService _srService;

  LearningState _state = LearningState.idle;
  List<Vocabulary> _currentSession = [];
  int _currentIndex = 0;
  
  LearningController(this._vocabRepo, this._progressRepo, this._srService);

  Future<void> startVocabularySession({
    int count = 10,
    int? jlptLevel,
  }) async {
    _state = LearningState.loading;
    notifyListeners();
    
    try {
      // Get new vocabulary items
      final allVocab = jlptLevel != null
          ? await _vocabRepo.getByJlptLevel(jlptLevel)
          : await _vocabRepo.getAll();
      
      // Filter out already mastered items
      final newVocab = await _filterNewItems(allVocab);
      
      // Select random items
      newVocab.shuffle();
      _currentSession = newVocab.take(count).toList();
      _currentIndex = 0;
      
      _state = LearningState.learning;
      notifyListeners();
    } catch (e) {
      _state = LearningState.error;
      notifyListeners();
    }
  }

  Future<void> answerCurrent({
    required bool wasCorrect,
    required int quality,
  }) async {
    final current = _currentSession[_currentIndex];
    
    // Record progress
    final progress = await _progressRepo.getOrCreate(
      contentType: 'vocabulary',
      contentId: current.id,
    );
    
    await _srService.recordReview(
      progress: progress,
      wasCorrect: wasCorrect,
      quality: quality,
    );
    
    // Move to next
    if (_currentIndex < _currentSession.length - 1) {
      _currentIndex++;
    } else {
      _state = LearningState.completed;
    }
    
    notifyListeners();
  }

  // Getters
  Vocabulary? get currentItem => _currentSession.isNotEmpty 
      ? _currentSession[_currentIndex] 
      : null;
  int get progress => _currentIndex;
  int get total => _currentSession.length;
  double get progressPercentage => total > 0 ? progress / total : 0.0;
}

enum LearningState {
  idle,
  loading,
  learning,
  completed,
  error,
}
```

---

## 9. Audio System

### 9.1 Audio Service

```dart
// lib/services/audio_service.dart

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  
  Future<void> playVocabularyAudio(String audioFilePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fullPath = '${appDir.path}/$audioFilePath';
    
    if (await File(fullPath).exists()) {
      await _player.play(DeviceFileSource(fullPath));
    } else {
      throw AudioFileNotFoundException(audioFilePath);
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  void dispose() {
    _player.dispose();
  }
}
```

---

## 10. Build-Time Content Generation Pipeline

### 10.1 Content Generation Scripts

```python
# scripts/content_generation/generate_vocabulary.py

import openai
import json
from typing import List, Dict

def generate_vocabulary_batch(
    count: int,
    jlpt_level: int,
    theme: str = None
) -> List[Dict]:
    """Generate vocabulary using GPT-4"""
    
    prompt = f"""
    Generate {count} Japanese vocabulary words suitable for JLPT N{jlpt_level}.
    {f'Theme: {theme}' if theme else ''}
    
    For each word, provide:
    1. Hiragana/Katakana reading
    2. Kanji (if applicable)
    3. Romaji
    4. English translation
    5. Part of speech
    6. 3 example sentences (Japanese + English)
    
    Return as JSON array.
    """
    
    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7,
    )
    
    vocabulary = json.loads(response.choices[0].message.content)
    
    # Add metadata
    for vocab in vocabulary:
        vocab['jlpt_level'] = jlpt_level
        vocab['id'] = generate_uuid()
        vocab['created_at'] = int(time.time() * 1000)
    
    return vocabulary

def generate_audio_for_vocabulary(vocabulary: List[Dict]):
    """Generate TTS audio for vocabulary using Google Cloud TTS"""
    from google.cloud import texttospeech
    
    client = texttospeech.TextToSpeechClient()
    
    for vocab in vocabulary:
        text = vocab['word_kana']
        
        synthesis_input = texttospeech.SynthesisInput(text=text)
        voice = texttospeech.VoiceSelectionParams(
            language_code="ja-JP",
            name="ja-JP-Neural2-B"  # Male voice
        )
        audio_config = texttospeech.AudioConfig(
            audio_encoding=texttospeech.AudioEncoding.MP3,
            speaking_rate=0.9,
        )
        
        response = client.synthesize_speech(
            input=synthesis_input,
            voice=voice,
            audio_config=audio_config
        )
        
        # Save audio file
        audio_path = f"assets/audio/vocab/{vocab['id']}.mp3"
        with open(audio_path, "wb") as out:
            out.write(response.audio_content)
        
        vocab['audio_file_path'] = f"audio/vocab/{vocab['id']}.mp3"

if __name__ == "__main__":
    # Generate N5 vocabulary
    vocab = generate_vocabulary_batch(count=1000, jlpt_level=5)
    generate_audio_for_vocabulary(vocab)
    
    # Save to JSON
    with open("content/vocabulary_n5.json", "w", encoding="utf-8") as f:
        json.dump(vocab, f, ensure_ascii=False, indent=2)
```

### 10.2 Content Pack Builder

```bash
#!/bin/bash
# scripts/build_content_pack.sh

PACK_ID=$1
PACK_VERSION=$2

echo "Building content pack: $PACK_ID v$PACK_VERSION"

# 1. Create pack directory structure
mkdir -p "build/packs/$PACK_ID/content"
mkdir -p "build/packs/$PACK_ID/assets/audio"
mkdir -p "build/packs/$PACK_ID/assets/images"

# 2. Copy content files
cp "content_source/$PACK_ID/vocabulary.json" "build/packs/$PACK_ID/content/"
cp "content_source/$PACK_ID/grammar.json" "build/packs/$PACK_ID/content/"

# 3. Copy assets
cp -r "content_source/$PACK_ID/audio/" "build/packs/$PACK_ID/assets/audio/"

# 4. Generate manifest
cat > "build/packs/$PACK_ID/manifest.json" <<EOF
{
  "id": "$PACK_ID",
  "version": "$PACK_VERSION",
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

# 5. Calculate checksums
find "build/packs/$PACK_ID" -type f -exec sha256sum {} \; > "build/packs/$PACK_ID/checksums.txt"

# 6. Create ZIP archive
cd "build/packs"
zip -r "$PACK_ID-v$PACK_VERSION.zip" "$PACK_ID/"

echo "Content pack built: build/packs/$PACK_ID-v$PACK_VERSION.zip"
```

---

## 11. Testing Strategy

### 11.1 Unit Tests

```dart
// test/services/spaced_repetition_service_test.dart

void main() {
  group('SpacedRepetitionService', () {
    late SpacedRepetitionService service;

    setUp(() {
      service = SpacedRepetitionService();
    });

    test('should calculate correct interval for first review', () {
      final result = service.calculateNextReview(
        quality: 4,
        easeFactor: 2.5,
        interval: 0,
        repetitions: 0,
      );

      expect(result.interval, equals(1));
      expect(result.repetitions, equals(1));
    });

    test('should reset interval on incorrect answer', () {
      final result = service.calculateNextReview(
        quality: 2,
        easeFactor: 2.5,
        interval: 10,
        repetitions: 5,
      );

      expect(result.interval, equals(1));
      expect(result.repetitions, equals(0));
    });

    // More tests...
  });
}
```

### 11.2 Widget Tests

```dart
// test/widgets/vocabulary_card_test.dart

void main() {
  testWidgets('VocabularyCard displays word and translation', (tester) async {
    final vocab = Vocabulary(
      id: 'test',
      wordKana: 'ありがとう',
      translation: 'thank you',
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VocabularyCard(vocabulary: vocab),
        ),
      ),
    );

    expect(find.text('ありがとう'), findsOneWidget);
    expect(find.text('thank you'), findsOneWidget);
  });
}
```

### 11.3 Integration Tests

```dart
// integration_test/learning_flow_test.dart

void main() {
  testWidgets('Complete vocabulary learning session', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Navigate to vocabulary learning
    await tester.tap(find.text('Learn Vocabulary'));
    await tester.pumpAndSettle();

    // Answer first question
    await tester.tap(find.byKey(Key('answer_correct')));
    await tester.pumpAndSettle();

    // Verify progress update
    expect(find.textContaining('1/10'), findsOneWidget);
  });
}
```

---

## 12. Performance Optimization

### 12.1 Database Optimization
- Proper indexing on frequently queried columns
- Batch inserts for content import (use transactions)
- Lazy loading of related data (e.g., example sentences)
- Database connection pooling

### 12.2 Memory Management
- Dispose controllers and streams properly
- Use `const` constructors where possible
- Implement pagination for large lists
- Cache frequently accessed data with size limits

### 12.3 Asset Optimization
- Compress audio files (MP3 128kbps)
- Use compressed image formats (WebP)
- Lazy load audio files
- Implement asset caching strategy

---

## 13. Security Considerations

### 13.1 Data Protection
- No sensitive user data collected
- Progress data stored locally only
- Content packs verified with checksums
- Secure HTTPS for content pack downloads

### 13.2 Code Obfuscation
- Enable R8/ProGuard for release builds
- Obfuscate Dart code in release mode
- Protect API keys (if any) with environment variables

---

## 14. Deployment Strategy

### 14.1 Release Checklist
- [ ] Run all tests (unit, widget, integration)
- [ ] Verify content pack integrity
- [ ] Test on multiple devices (various Android versions)
- [ ] Check app size and performance
- [ ] Update version in pubspec.yaml
- [ ] Generate signed APK/AAB
- [ ] Create release notes
- [ ] Upload to Play Store

### 14.2 Content Update Strategy
- Monthly content pack releases
- Version content packs independently from app
- Maintain backward compatibility
- Provide migration path for database schema changes

---

**Next Document:** IMPLEMENTATION_PLAN.md
