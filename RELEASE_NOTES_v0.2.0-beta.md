# JLearn v0.2.0-beta Release Notes

**Release Date**: November 30, 2025  
**Release Type**: Beta (Feature Release)  
**Download**: [GitHub Release](https://github.com/cmwen/jlearn-app/releases/tag/v0.2.0-beta)

---

## 🎉 New Features

### 🔊 Text-to-Speech (TTS) Integration

This release introduces **AI-powered Text-to-Speech** for Japanese pronunciation!

**What's New**:
- ✨ **Audio Playback**: Tap speaker icons to hear Japanese pronunciation
- 🗣️ **Native Japanese Voice**: Uses device TTS with Japanese (ja-JP) language
- 📖 **Word & Example Audio**: Play audio for both vocabulary and example sentences
- 🎛️ **Configurable Settings**: Adjustable speech rate, volume, and pitch
- 💫 **Visual Feedback**: Speaker icon changes when audio is playing
- 🔄 **Smart Lifecycle**: Proper TTS cleanup on screen exit

---

## 📱 Installation

### Android APK (Recommended)
1. Download `jlearn-0.2.0-beta+4.apk` (42.69 MB)
2. Install on Android device (5.0+)
3. Launch and enjoy audio features! 🎧

### Android App Bundle
- File: `jlearn-0.2.0-beta+4.aab` (38.34 MiB)
- For Play Store distribution

---

## ✨ Complete Feature List

All previous features plus TTS:

- 📚 **60 JLPT N5 Vocabulary Words**
- 🧠 **SM-2 Spaced Repetition Algorithm**
- 🎴 **Interactive Flashcard Review System**
- 🔊 **NEW: Text-to-Speech for Pronunciation**
- 📊 **Progress Tracking & Statistics**
- 💾 **SQLite Database** (offline)
- 🎨 **Material Design 3 UI**
- 🌏 **Time-based Japanese Greetings**

---

## 🎧 How to Use TTS

### In Review Screen

**Play Vocabulary Word**:
1. View flashcard with Japanese word
2. Tap the 🔊 speaker icon next to the word
3. Listen to correct pronunciation
4. Icon changes to indicate audio is playing

**Play Example Sentence**:
1. Reveal answer to see example
2. Tap 🔊 icon next to the example
3. Hear the complete sentence
4. Practice pronunciation along with audio

**Tips**:
- Headphones recommended for best audio quality
- Ensure device volume is turned up
- TTS works offline after initial setup
- Audio automatically stops when changing cards

---

## 🔧 Technical Details

### Text-to-Speech Implementation

**Package**: `flutter_tts 4.2.3`
**Features**:
- Singleton service pattern for TTS management
- Japanese language (ja-JP) configuration
- Speech rate: 0.4 (slower for learning)
- Full volume (1.0) and normal pitch (1.0)
- Async/await for proper audio playback
- Error handling for missing TTS engines

**Architecture**:
```dart
TtsService (Singleton)
  ├── initialize() - Setup Japanese TTS
  ├── speak(text) - Play audio
  ├── stop() - Stop current audio
  └── setLanguage/Rate - Configuration
```

### Build Info
- **Version**: 0.2.0-beta+4
- **Build Number**: 4
- **APK Size**: 42.69 MB (+40 KB vs v0.1.2)
- **AAB Size**: 38.34 MB
- **Package**: com.jlearn.app
- **New Dependencies**: flutter_tts
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)

---

## 📝 Changelog

### v0.2.0-beta (2025-11-30)

#### Added
- 🔊 Text-to-Speech integration with flutter_tts
- 🎤 Japanese pronunciation audio for vocabulary words
- 📢 Audio playback for example sentences
- 🔘 Speaker icon buttons on flashcards
- 💫 Visual feedback during audio playback
- ⚙️ TtsService singleton for TTS management
- 🔄 Proper TTS lifecycle and cleanup

#### Improved
- 📖 Enhanced review experience with audio
- 🎯 Better learning through pronunciation
- 🧠 Multi-modal learning (visual + audio)

#### Technical
- Integrated flutter_tts 4.2.3 package
- Japanese language TTS (ja-JP) support
- Singleton pattern for TTS service
- Async audio playback with proper error handling
- All tests passing (4/4)
- Zero analyzer warnings

---

## 📊 Version Comparison

| Feature | v0.1.2-beta | v0.2.0-beta |
|---------|-------------|-------------|
| Vocabulary Words | 60 | 60 |
| Spaced Repetition | ✅ | ✅ |
| Flashcards | ✅ | ✅ |
| **Audio/TTS** | ❌ | ✅ **NEW** |
| **Pronunciation** | ❌ | ✅ **NEW** |
| APK Size | 42.65 MB | 42.69 MB |
| Build Number | 3 | 4 |

---

## 🧪 Testing Instructions

### Verify TTS Functionality

**Test 1: Basic Audio Playback**
1. Install v0.2.0-beta APK
2. Start a review session
3. Tap speaker icon next to Japanese word
4. Verify audio plays
5. Check icon changes during playback

**Test 2: Example Sentence Audio**
1. Reveal answer on flashcard
2. Scroll to example section
3. Tap speaker icon next to example
4. Verify complete sentence plays
5. Check audio quality

**Test 3: Multiple Cards**
1. Play audio for first card
2. Rate and move to next card
3. Play audio for next card
4. Verify no audio overlap
5. Check smooth transitions

**Test 4: TTS Availability**
1. Check device has Japanese TTS installed
2. If missing, app should gracefully handle
3. Settings → Language & Input → TTS
4. Install Japanese voice data if needed

---

## 🚀 What's Next

### Planned for v0.3.0
- 📚 Additional 100+ vocabulary words
- 📖 Basic grammar lessons (10 lessons)
- 🎨 Improved UI/UX with animations
- 📈 Enhanced statistics and progress charts
- ⚙️ TTS settings (speed, volume adjustment)

### Future Features
- 🎤 Speech recognition for pronunciation practice
- ✍️ Handwriting recognition for kanji
- 📦 Downloadable content packs
- 🔍 Search and dictionary feature
- 🏆 Achievement system

---

## 🐛 Known Issues

**TTS Language Requirement**:
- Requires Japanese TTS voice installed on device
- Most Android devices have this by default
- If missing: Settings → Language & Input → Text-to-speech → Install Japanese

**Audio Playback**:
- Some devices may have slower TTS initialization
- First audio playback might have slight delay
- Subsequent playback is instant

---

## 🙏 Acknowledgments

- **flutter_tts team**: Excellent cross-platform TTS package
- **Japanese learners**: Feedback on pronunciation needs
- **Beta testers**: Early testing and bug reports

---

## 📥 Download

**GitHub Release**: https://github.com/cmwen/jlearn-app/releases/tag/v0.2.0-beta

**Direct Download**:
- APK: `jlearn-0.2.0-beta+4.apk` (42.69 MB)
- AAB: `jlearn-0.2.0-beta+4.aab` (38.34 MB)

---

**Happy Learning with Audio! 聞いて練習しよう！(Listen and practice!)**

**Previous Releases**:
- [v0.1.2-beta](RELEASE_NOTES_v0.1.2-beta.md) - Package naming fixes
- [v0.1.0-beta](RELEASE_NOTES_v0.1.0-beta.md) - Initial MVP release
