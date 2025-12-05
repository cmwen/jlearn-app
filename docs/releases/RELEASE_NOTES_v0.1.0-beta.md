# JLearn v0.1.0-beta Release Notes

**Release Date**: November 30, 2025  
**Release Type**: Beta  
**Download**: [GitHub Release](https://github.com/cmwen/jlearn-app/releases/tag/v0.1.0-beta)

---

## 🎉 What's New

This is the first beta release of **JLearn** - an offline Japanese learning app with intelligent spaced repetition!

### Core Features

#### ✨ Flashcard Review System
- **Smart Spaced Repetition**: Implements SM-2 algorithm for optimal learning
- **4-Level Difficulty Rating**: Again (😟), Hard (😐), Good (🙂), Easy (😄)
- **Adaptive Scheduling**: Cards appear based on your performance
- **Progress Tracking**: Visual progress bar during review sessions

#### 📚 Vocabulary Database
- **60 JLPT N5 Words**: Essential beginner vocabulary
- **Organized Categories**:
  - Greetings & Common Expressions (10 words)
  - Basic Verbs (15 words)
  - Essential Nouns (10 words)
  - Time Words (8 words)
  - Common Adjectives (7 words)
  - And more!
- **Complete Learning Data**: Each word includes:
  - Japanese word (kanji/kana)
  - Romaji reading
  - English meaning
  - Part of speech
  - Example sentence with translation

#### 🏠 Home Screen
- **Time-based Greetings**: おはよう！こんにちは！こんばんは！
- **Progress Stats**: Track due reviews and total vocabulary
- **Quick Start**: One-tap to begin review session
- **Pull to Refresh**: Update stats anytime

#### 💾 Data Persistence
- **SQLite Database**: All progress saved locally
- **Offline-first**: Works completely offline
- **Fast & Efficient**: Optimized database queries with indexes

---

## 📱 Installation

### Android APK (Recommended for Testing)
1. Download `min-android-template-0.1.0-beta+1.apk` (42.34 MB)
2. Enable "Install from Unknown Sources" in Settings
3. Install the APK
4. Launch JLearn!

### Android App Bundle (For Play Store)
- File: `min-android-template-0.1.0-beta+1.aab` (37.59 MB)
- Used for Play Store distribution (not for direct installation)

---

## 🧪 Testing Instructions

### First Launch
1. **Open the app** - Database initializes automatically
2. **Check home screen** - Should show "60 Due Reviews" and "60 Total Words"
3. **Tap "Start Review"** - Begin your first session

### Review Session
1. **View card** - Japanese word with romaji reading
2. **Tap "Show Answer"** - Reveal meaning and example
3. **Rate your knowledge**:
   - **Again**: Didn't remember → Review tomorrow
   - **Hard**: Somewhat difficult → Slightly longer interval
   - **Good**: Standard recall → Normal progression (1→6 days)
   - **Easy**: Very easy → Much longer interval
4. **Complete session** - Get celebration message!

### Progress Tracking
- Return to home screen after review
- Stats update automatically
- Words rated "Easy" won't appear for several days
- Words rated "Again" appear again tomorrow
- Close and reopen app - progress persists!

---

## 📊 What's Included

### Sample Vocabulary (60 words)

**Greetings (10)**
- ありがとう (thank you), すみません (sorry), おはよう (good morning)
- こんにちは (hello), こんばんは (good evening), さようなら (goodbye)
- And more!

**Verbs (15)**
- 食べる (to eat), 飲む (to drink), 見る (to see), 行く (to go)
- 来る (to come), 帰る (to return), 買う (to buy), 話す (to speak)
- And more!

**Nouns (10)**
- 学校 (school), 本 (book), 友達 (friend), 人 (person)
- 水 (water), お茶 (tea), 家 (house), 先生 (teacher)
- And more!

**Time Words (8)**
- 今日 (today), 明日 (tomorrow), 昨日 (yesterday)
- 朝 (morning), 昼 (noon), 夜 (night), 毎日 (every day)
- And more!

**Adjectives (7)**
- 大きい (big), 小さい (small), 新しい (new), 古い (old)
- 良い (good), 悪い (bad), 美味しい (delicious)

---

## 🚧 Known Limitations

This is a **beta release** focused on core functionality. The following features are not yet implemented:

### Not Yet Available
- 🔊 **Audio Playback**: Pronunciation audio
- 🎤 **Speech Recognition**: ML-powered pronunciation practice
- ✍️ **Handwriting Recognition**: Kanji writing practice
- 📖 **Grammar Lessons**: Grammar point explanations
- 🎧 **Listening Exercises**: Audio comprehension practice
- 📦 **Content Packs**: Downloadable content expansion
- 🔍 **Search/Dictionary**: Vocabulary lookup
- 📈 **Advanced Statistics**: Detailed progress analytics
- 🏆 **Achievements**: Streak tracking and badges
- 🌙 **Dark Mode**: Theme customization

---

## 🐛 Bug Reports & Feedback

Please report issues or provide feedback:
- **GitHub Issues**: [Create an issue](https://github.com/cmwen/jlearn-app/issues)
- **Email**: (Add your email)

### What to Report
- Crashes or errors
- UI/UX issues
- Japanese translation errors
- Performance problems
- Feature requests

---

## 🔧 Technical Details

### Architecture
- **Framework**: Flutter 3.10.1+
- **Language**: Dart 3.10.1+
- **Database**: SQLite with sqflite package
- **State Management**: StatefulWidgets
- **Build System**: Java 17, Gradle 8.0+
- **UI**: Material Design 3

### Database Schema
```sql
-- Vocabulary table
CREATE TABLE vocabulary (
  id INTEGER PRIMARY KEY,
  word TEXT NOT NULL,
  reading TEXT NOT NULL,
  meaning TEXT NOT NULL,
  part_of_speech TEXT,
  example_sentence TEXT,
  jlpt_level TEXT
);

-- Review cards with SM-2 algorithm data
CREATE TABLE review_cards (
  id INTEGER PRIMARY KEY,
  vocabulary_id INTEGER,
  repetitions INTEGER,
  ease_factor REAL,
  interval_days INTEGER,
  next_review_date TEXT,
  last_reviewed_at TEXT
);
```

### Build Info
- **Version**: 0.1.0-beta+1
- **Build Number**: 1
- **APK Size**: 42.34 MB
- **AAB Size**: 37.59 MB
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)

---

## 📝 Changelog

### Added
- ✨ Complete flashcard review system with SM-2 spaced repetition
- 📚 60 JLPT N5 vocabulary words across 5 categories
- 🏠 Home screen with progress tracking
- 💾 SQLite database with optimized indexes
- 🎯 4-level difficulty rating system
- 📊 Progress bar during review sessions
- 🌏 Time-based Japanese greetings
- 🔄 Pull-to-refresh on home screen
- 🎉 Completion celebration messages
- ✅ Unit tests for spaced repetition algorithm

### Changed
- 🎨 Updated to Material Design 3
- 🎨 Indigo color scheme
- 📱 Renamed from "min_flutter_template" to "JLearn"

---

## 🚀 Next Steps

Planned for future releases:

### v0.2.0 (Next Beta)
- 🔊 Audio playback with TTS
- 📚 Additional 100+ vocabulary words
- 📖 10 basic grammar lessons
- 🎨 Improved UI/UX

### v0.3.0
- 🎧 Listening comprehension exercises
- 📦 First downloadable content pack (JLPT N5 Complete)
- 🔍 Search and dictionary feature
- 📈 Enhanced statistics

### v1.0.0 (Stable Release)
- 🎤 Speech recognition (ML-powered)
- ✍️ Handwriting recognition
- 🏆 Achievement system
- 🌙 Dark mode
- 📱 Full JLPT N5-N4 content

---

## 🙏 Acknowledgments

- **Spaced Repetition**: Based on the SM-2 algorithm by Piotr Wozniak
- **JLPT**: Vocabulary aligned with Japanese Language Proficiency Test levels
- **Flutter Team**: For the amazing framework
- **Community**: Beta testers and early adopters

---

## 📄 License

MIT License - see LICENSE file

---

**Happy Learning! がんばって！(Ganbatte!)**

*For detailed testing instructions, see [TESTING_INSTRUCTIONS.md](TESTING_INSTRUCTIONS.md)*
