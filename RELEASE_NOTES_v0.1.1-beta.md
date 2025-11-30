# JLearn v0.1.1-beta Release Notes

**Release Date**: November 30, 2025  
**Release Type**: Beta (Bug Fix)  
**Download**: [GitHub Release](https://github.com/cmwen/jlearn-app/releases/tag/v0.1.1-beta)

---

## 🐛 Bug Fixes

This release fixes a critical bug that prevented the app from installing on Android devices.

### Fixed
- ✅ **Android Package Name Issue**: Corrected package from `com.cmwen.min_flutter_template` to `com.jlearn.app`
- ✅ **MainActivity Path**: Moved `MainActivity.kt` to correct package directory structure
- ✅ **Installation Problem**: App now installs and runs correctly on all Android devices
- ✅ **Removed Old Package**: Cleaned up obsolete package directory structure

---

## 📱 Installation

### Android APK (Recommended)
1. Download `min-android-template-0.1.1-beta+2.apk` (42.65 MB)
2. Enable "Install from Unknown Sources" if needed
3. Install the APK
4. Launch JLearn and enjoy! 🎉

### Android App Bundle
- File: `min-android-template-0.1.1-beta+2.aab` (38.30 MB)
- For Play Store distribution

---

## ✨ What's Included

All features from v0.1.0-beta plus the package fix:

- 📚 **60 JLPT N5 Vocabulary Words**
- 🧠 **SM-2 Spaced Repetition Algorithm**
- 🎴 **Interactive Flashcard Review System**
- 📊 **Progress Tracking & Statistics**
- 💾 **SQLite Database** with offline support
- 🎨 **Material Design 3 UI**
- 🌏 **Time-based Japanese Greetings**

See [v0.1.0-beta Release Notes](RELEASE_NOTES_v0.1.0-beta.md) for complete feature list.

---

## 🧪 Testing Instructions

### Verify the Fix
1. **Uninstall** any previous version of JLearn
2. **Install** v0.1.1-beta APK
3. **Launch** the app - should open without issues
4. **Check** home screen shows "60 Due Reviews"
5. **Start** a review session to verify functionality

### Test on Emulator
The app has been tested on:
- Android Emulator (API 36 / Android 16)
- Physical Android devices

---

## 📝 Changelog

### v0.1.1-beta (2025-11-30)

#### Fixed
- 🐛 Fixed Android package name preventing app installation
- 🔧 Corrected MainActivity.kt package path to `com.jlearn.app`
- 🧹 Removed old package structure `com.cmwen.min_flutter_template`
- ✅ Verified app installs and runs on Android emulator

#### Technical
- Updated package structure in `android/app/src/main/kotlin/`
- All tests passing (4/4)
- Build verified on Android emulator
- CI/CD workflows completed successfully

---

## 🔧 Technical Details

### Build Info
- **Version**: 0.1.1-beta+2
- **Build Number**: 2
- **APK Size**: 42.65 MB
- **AAB Size**: 38.30 MB
- **Package**: com.jlearn.app
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)

### What Changed
```kotlin
// Before (WRONG - causing installation failure)
package com.cmwen.min_flutter_template

// After (CORRECT)
package com.jlearn.app
```

---

## 📊 Comparison with v0.1.0-beta

| Aspect | v0.1.0-beta | v0.1.1-beta |
|--------|-------------|-------------|
| Package Name | ❌ Incorrect | ✅ Correct |
| Installation | ❌ Fails | ✅ Works |
| Functionality | ✅ Good | ✅ Good |
| APK Size | 42.34 MB | 42.65 MB |
| Build Number | 1 | 2 |

---

## 🚀 Next Steps

### For Users
1. Download and install v0.1.1-beta
2. Start learning Japanese with 60 vocabulary words
3. Report any issues on GitHub

### For Developers
Next release (v0.2.0) will include:
- 🔊 Audio playback with TTS
- 📚 Additional 100+ vocabulary words
- 📖 Basic grammar lessons
- 🎨 UI/UX improvements

---

## 🐛 Known Issues

None! This release specifically fixes the installation issue.

If you encounter any problems, please report them:
- **GitHub Issues**: [Create an issue](https://github.com/cmwen/jlearn-app/issues)
- Include: Android version, device model, error messages

---

## 🙏 Thank You

Thanks to early testers who reported the installation issue! This quick fix ensures everyone can now use JLearn.

---

**Happy Learning! がんばって！(Ganbatte!)**

**Previous Release**: [v0.1.0-beta Release Notes](RELEASE_NOTES_v0.1.0-beta.md)  
**Download**: https://github.com/cmwen/jlearn-app/releases/tag/v0.1.1-beta
