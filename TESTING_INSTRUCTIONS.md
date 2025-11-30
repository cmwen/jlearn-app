# JLearn MVP - Testing Instructions

## What's Been Implemented

This is a working MVP (Minimum Viable Product) of JLearn - a Japanese learning app with the following features:

### ✅ Implemented Features

1. **Home Screen**
   - Welcome message with Japanese greetings (changes based on time of day)
   - Progress stats showing due reviews and total vocabulary words
   - Start Review button (when reviews are due)
   - Learn New Words button (placeholder)

2. **Vocabulary Database**
   - SQLite database with proper schema
   - 60 sample Japanese words (JLPT N5 level)
   - Includes: word, reading, meaning, part of speech, example sentences
   - Categories: Greetings (10), Verbs (15), Nouns (10), Time words (8), Adjectives (7), and more
   - All essential beginner vocabulary for daily conversation

3. **Spaced Repetition System (SM-2 Algorithm)**
   - Tracks review progress for each vocabulary word
   - Calculates next review dates based on performance
   - 4 difficulty ratings: Again (😟), Hard (😐), Good (🙂), Easy (😄)
   - Adapts interval based on user performance

4. **Flashcard Review System**
   - Shows Japanese word and reading
   - Tap to reveal meaning
   - Display example sentences with translations
   - Rate your knowledge (Again/Hard/Good/Easy)
   - Progress bar showing review completion
   - Celebration message when done

### 🚧 Not Yet Implemented (Future Features)

- ML-powered features (speech recognition, handwriting)
- Audio playback for pronunciation
- Grammar lessons
- Listening exercises
- Content packs
- Search/Dictionary
- Advanced statistics
- Achievements and streaks
- Dark mode

## How to Test

### Prerequisites

- Android device or emulator
- OR use the debug APK at `build/app/outputs/flutter-apk/app-debug.apk`

### Testing Flow

1. **Install and Launch**
   ```bash
   # Option 1: Run directly
   flutter run
   
   # Option 2: Install debug APK
   adb install build/app/outputs/flutter-apk/app-debug.apk
   ```

2. **First Launch**
   - App automatically creates database
   - Loads 60 sample vocabulary words
   - All words are marked as "due for review"

3. **Home Screen**
   - Check the greeting message (changes with time of day)
   - Verify stats show "60 Due Reviews" and "60 Total Words"
   - Tap "Start Review" button

4. **Review Session**
   - You'll see a flashcard with Japanese text and reading
   - Tap "Show Answer" button
   - Review the meaning and example sentence
   - Rate your knowledge:
     - **Again (😟)**: Resets progress, reviews again tomorrow
     - **Hard (😐)**: Increases interval slightly
     - **Good (🙂)**: Standard progression (1 day → 6 days → etc.)
     - **Easy (😄)**: Longer interval, marks as well-known
   - Progress bar updates as you complete cards
   - After reviewing all cards, you'll see a success message

5. **Test Spaced Repetition**
   - Complete a review session
   - Return to home screen
   - Check that "Due Reviews" count decreased
   - Words rated as "Easy" won't appear for several days
   - Words rated as "Again" will appear again tomorrow

6. **Test Data Persistence**
   - Close the app completely
   - Reopen the app
   - Verify your progress is saved
   - Check that reviewed cards don't reappear immediately

## Architecture Overview

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── vocabulary.dart                # Vocabulary word model
│   └── review_card.dart               # Review progress model (SM-2)
├── data/
│   └── database_helper.dart           # SQLite database operations
├── services/
│   ├── spaced_repetition_service.dart # SM-2 algorithm implementation
│   └── sample_data_service.dart       # Sample vocabulary data
└── screens/
    ├── home_screen.dart               # Main screen with stats
    └── review_screen.dart             # Flashcard review interface
```

## Testing Checklist

- [ ] App launches without crashes
- [ ] Sample data loads on first launch
- [ ] Home screen displays correct stats
- [ ] Can start a review session
- [ ] Flashcards display correctly with Japanese text
- [ ] "Show Answer" reveals meaning and examples
- [ ] All 4 rating buttons work
- [ ] Progress bar updates correctly
- [ ] Completion message appears after last card
- [ ] Stats update after review session
- [ ] Data persists after app restart
- [ ] Different cards appear based on ratings
- [ ] Greeting message changes with time of day

## Known Limitations

1. **No Audio**: Audio playback not implemented yet
2. **Sample Data Only**: 60 words included for testing (more can be added)
3. **No New Content**: "Learn New Words" button is placeholder
4. **Basic UI**: Minimal Material Design 3 styling
5. **No Offline Sync**: Single device only

## Development Commands

```bash
# Run app
flutter run

# Build debug APK
flutter build apk --debug

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/
```

## Database Location (for debugging)

Android: `/data/data/com.jlearn.app/databases/jlearn.db`

To inspect:
```bash
adb shell
cd /data/data/com.jlearn.app/databases
sqlite3 jlearn.db
.tables
SELECT * FROM vocabulary LIMIT 5;
SELECT * FROM review_cards LIMIT 5;
```

## Next Steps for Full Implementation

1. Add audio playback with TTS or pre-recorded audio
2. Implement grammar lessons module
3. Add listening comprehension exercises
4. Create content pack download system
5. Build search/dictionary feature
6. Add advanced statistics and progress tracking
7. Implement achievements and streak tracking
8. Add dark mode theme
9. Create onboarding tutorial
10. Implement cloud sync (optional)

## Feedback

Please test all features and provide feedback on:
- UI/UX improvements
- Bugs or crashes
- Performance issues
- Feature suggestions
- Content accuracy (Japanese translations)

---

**Status**: ✅ Working MVP Ready for Testing
**Last Updated**: 2025-11-30
