# 📚 JLearn - LLM-Powered Language Learning Shell

An **LLM-powered language learning framework** that generates personalized content through any Large Language Model while maintaining complete data ownership and offline-first operation.

---

## 🎯 Vision

JLearn is not a traditional language learning app with static content. Instead, it's an **intelligent shell** that:
- Generates smart prompts based on your learning progress
- Works with **any LLM** (ChatGPT, Claude, Gemini, Copilot, etc.)
- Parses responses into interactive learning components
- Tracks your progress locally with spaced repetition
- Keeps 100% of your data on your device

**Key Innovation**: You bring your own LLM; the app provides structure, progress tracking, and adaptive learning.

---

## ✨ Key Features

- 🤖 **LLM-Agnostic**: Works with ChatGPT, Claude, Gemini, or any LLM
- 🔒 **Privacy-First**: No servers, no accounts, all data stays local
- 📱 **Offline Learning**: Study content works without internet
- 🔄 **Spaced Repetition**: SM-2 algorithm for optimal review scheduling
- 📊 **Progress Tracking**: Analytics and weakness identification
- 💾 **Data Export**: Full JSON/CSV export anytime

---

## 📖 Documentation

All detailed documentation is in the [`docs/`](./docs/README.md) folder:

| Document | Description |
|----------|-------------|
| [Product Vision](./docs/PRODUCT_VISION.md) | Strategic vision and value proposition |
| [Architecture](./docs/ARCHITECTURE_OVERVIEW.md) | Technical system design |
| [Implementation Roadmap](./docs/IMPLEMENTATION_ROADMAP.md) | Phased development plan |
| [JSON Schemas](./docs/JSON_SCHEMAS.md) | Content format specifications |
| [User Stories](./docs/USER_STORIES_MVP.md) | MVP requirements and acceptance criteria |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         Presentation Layer               │
│  (Flutter Widgets - Material Design 3)  │
└─────────────────────────────────────────┘
                    ↕
┌─────────────────────────────────────────┐
│       Business Logic Layer               │
│  (Prompt Generator, JSON Parser, SRS)    │
└─────────────────────────────────────────┘
                    ↕
┌─────────────────────────────────────────┐
│          Data Layer                      │
│  (SQLite, Repositories, Local Storage)   │
└─────────────────────────────────────────┘
                    ↕
┌─────────────────────────────────────────┐
│       External (User's LLM)              │
│  (ChatGPT, Claude, Gemini, etc.)         │
└─────────────────────────────────────────┘
```

### Technology Stack

- **Framework**: Flutter 3.10.1+
- **Language**: Dart 3.10.1+
- **Database**: SQLite (sqflite)
- **State Management**: Provider
- **Platform**: Android (iOS planned)

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.10.1+
- Java 17+ (for Android builds)
- Android Studio or VS Code

```bash
# Verify setup
flutter doctor -v && java -version
```

### Run the App

```bash
# Get dependencies
flutter pub get

# Run
flutter run
```

---

## 📊 Development Status

**Current Phase**: MVP Implementation

### Completed
- ✅ Product vision and architecture
- ✅ JSON schemas for content types
- ✅ User stories and acceptance criteria
- ✅ Basic flashcard review system (v0.2.0-beta)

### In Progress
- [ ] LLM prompt generation system
- [ ] JSON parsing engine
- [ ] Content library management
- [ ] Adaptive progress tracking

See [IMPLEMENTATION_ROADMAP.md](./docs/IMPLEMENTATION_ROADMAP.md) for full details.

---

## 🤖 AI-Powered Development

This repo includes specialized AI agents for VS Code:

| Agent | Purpose |
|-------|---------|
| **@product-owner** | Define features & requirements |
| **@architect** | Plan technical architecture |
| **@flutter-developer** | Implement features & tests |
| **@doc-writer** | Write documentation |

See [AGENTS.md](./AGENTS.md) for details.

---

## 📄 License

MIT License - See [LICENSE](./LICENSE)

---

## 📁 Project Structure

```
jlearn-app/
├── lib/                 # Dart source code
│   ├── data/            # Database & repositories
│   ├── models/          # Domain models
│   ├── screens/         # UI screens
│   ├── services/        # Business logic
│   └── widgets/         # Reusable components
├── docs/                # Product documentation
├── test/                # Unit & widget tests
├── android/             # Android platform files
└── assets/              # Images, icons
```
