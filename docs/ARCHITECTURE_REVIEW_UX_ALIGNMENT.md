# Technical Architecture Review: UX Workflow Support

**Date:** 2025-12-05  
**Reviewer:** Architecture Agent  
**Reference Documents:** 
- `UX_DESIGN_LLM_SHELL.md`
- `USER_FLOWS_LLM_SHELL.md`
- `ARCHITECTURE_OVERVIEW.md`
- `TECHNICAL_DESIGN.md`
- `REQUIREMENTS_LLM_INTEGRATION.md`

---

## Executive Summary

This review evaluates the existing technical architecture documents against the updated UX design for the LLM-powered shell. The architecture documents (`ARCHITECTURE_OVERVIEW.md` and `TECHNICAL_DESIGN.md`) represent two different product visions and need reconciliation.

### Overall Assessment

| Document | Alignment | Status |
|----------|-----------|--------|
| `ARCHITECTURE_OVERVIEW.md` | ✅ **Aligned** | Designed for LLM shell architecture |
| `TECHNICAL_DESIGN.md` | ⚠️ **Partially Outdated** | Designed for content pack model |
| `REQUIREMENTS_LLM_INTEGRATION.md` | ✅ **Aligned** | Specifies LLM integration requirements |

---

## UX Workflow → Architecture Mapping

### 1. Content Generation Flow

**UX Flow:**
```
User taps "Generate" → Configure options → Copy prompt → 
External LLM → Paste JSON → Parse → Preview → Save → Study
```

**Architecture Support:**

| Component | Support Level | Implementation Notes |
|-----------|---------------|---------------------|
| Generate Screen | ✅ Fully Supported | `PromptGeneratorService` defined in `ARCHITECTURE_OVERVIEW.md` |
| Prompt Templates | ✅ Fully Supported | Template library planned in `REQUIREMENTS_LLM_INTEGRATION.md` |
| Clipboard Integration | ⚠️ Needs Addition | Clipboard service not explicitly defined |
| JSON Parser | ✅ Fully Supported | `JsonParserService` with markdown stripping |
| Validation Engine | ✅ Fully Supported | `ValidationEngine` defined |
| Content Storage | ✅ Fully Supported | `content` table in new schema |

**Gap Identified:**
```dart
// MISSING: Explicit Clipboard Service
class ClipboardService {
  Future<void> copyToClipboard(String text);
  Future<String?> readFromClipboard();
  void showCopyFeedback(BuildContext context);
}
```

---

### 2. Flashcard Study Flow

**UX Flow:**
```
Select deck → Load cards → Show front → Tap to flip → 
Rate (Again/Hard/Good/Easy) → Update SRS → Next card → Summary
```

**Architecture Support:**

| Component | Support Level | Implementation Notes |
|-----------|---------------|---------------------|
| Flashcard Model | ✅ Supported | `FlashcardSet` schema in `REQUIREMENTS_LLM_INTEGRATION.md` |
| SRS Algorithm | ✅ Supported | `SrsAlgorithmService` with SM-2 variant |
| Session State | ✅ Supported | `LearningSessionProvider` defined |
| Progress Tracking | ✅ Supported | `ProgressTrackerService` and `activities` table |
| Audio Playback | ✅ Supported | `audioplayers` in dependencies |

**Schema Alignment Check:**

UX expects:
```json
{
  "front": "string",
  "back": "string", 
  "pronunciation": "string (optional)",
  "example": "string (optional)"
}
```

Architecture provides:
```json
{
  "id": "string",
  "front": "string",
  "back": "string",
  "example": "string (optional)",
  "pronunciation": "string (optional)",
  "image_prompt": "string (optional)"
}
```

✅ **Aligned** - Architecture schema matches UX requirements.

---

### 3. Quiz Flow

**UX Flow:**
```
Start quiz → Show question → Select answer → Submit → 
Show feedback + explanation → Next question → Final score → Review
```

**Architecture Support:**

| Component | Support Level | Implementation Notes |
|-----------|---------------|---------------------|
| Quiz Model | ✅ Supported | Quiz schema defined |
| Question Display | ✅ Supported | QuizView component planned |
| Answer Tracking | ✅ Supported | `quiz_sessions` and `quiz_results` tables |
| Score Calculation | ✅ Supported | Business logic layer |
| Review Mode | ⚠️ Implicit | Not explicitly defined but storage supports it |

---

### 4. Data Export Flow

**UX Flow:**
```
Settings → Export → Select format → Generate file → 
Share sheet → User saves/shares → Success message
```

**Architecture Support:**

| Component | Support Level | Implementation Notes |
|-----------|---------------|---------------------|
| Export Service | ✅ Defined | `ExportService` in Future Architecture section |
| JSON Export | ✅ Planned | All data exportable |
| CSV Export | ✅ Planned | Progress summary exportable |
| Share Integration | ⚠️ Needs Addition | Platform share sheet not explicitly covered |
| Import Service | ✅ Defined | `ImportService` for future use |

**Gap Identified:**
```dart
// MISSING: Platform Share Service
class ShareService {
  Future<void> shareFile(String path, String mimeType);
  Future<String> getExportDirectory();
}
```

---

### 5. Onboarding Flow

**UX Flow:**
```
Welcome → Select language → Select level → Select goals → 
LLM tutorial → First generate → First import → First study → Dashboard
```

**Architecture Support:**

| Component | Support Level | Implementation Notes |
|-----------|---------------|---------------------|
| User Profile | ✅ Supported | `user_profile` table in schema |
| Onboarding State | ⚠️ Needs Addition | No onboarding completion tracking |
| Tutorial State | ⚠️ Needs Addition | No tutorial replay tracking |
| Language Selection | ✅ Supported | Profile stores languages |
| Goals Storage | ✅ Supported | Profile stores goals |

**Gap Identified:**
```dart
// MISSING: Onboarding State Management
class OnboardingService {
  bool get isOnboardingComplete;
  int get currentOnboardingStep;
  Future<void> completeStep(OnboardingStep step);
  Future<void> skipOnboarding();
  Future<void> resetOnboarding();
}
```

---

### 6. Error Handling Flow

**UX Flow:**
```
Paste malformed JSON → Show error → Display suggestions → 
Edit JSON → Retry parse → Success or show different error
```

**Architecture Support:**

| Component | Support Level | Implementation Notes |
|-----------|---------------|---------------------|
| Error Detection | ✅ Supported | `JsonParserService` returns `ParseError` |
| Error Messages | ✅ Supported | Specific error types defined |
| Suggestions | ⚠️ Partial | Line numbers yes, suggestions implicit |
| JSON Editor | ⚠️ Needs Addition | In-app JSON editor not defined |
| Retry Logic | ✅ Supported | Result pattern allows retry |

**Gap Identified:**
```dart
// MISSING: JSON Editor Widget
class JsonEditorWidget extends StatefulWidget {
  final String initialJson;
  final Function(String) onJsonChanged;
  final List<ParseError>? errors;
  final bool highlightErrors;
  // Syntax highlighting, line numbers, error markers
}
```

---

## Database Schema Reconciliation

### Current State: Two Conflicting Schemas

**`TECHNICAL_DESIGN.md` Schema (Content Pack Model):**
- Tables: `vocabulary`, `grammar_points`, `listening_content`, `reading_passages`, `dialogues`, `content_packs`
- Designed for pre-packaged content downloaded from server

**`ARCHITECTURE_OVERVIEW.md` Schema (LLM Shell Model):**
- Tables: `content`, `activities`, `reviews`, `user_profile`
- Designed for user-generated content from LLM

### Recommended Unified Schema

```sql
-- Core content table (supports all content types)
CREATE TABLE content (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,  -- 'flashcard', 'quiz', 'conversation', 'grammar'
  language TEXT NOT NULL,
  level TEXT NOT NULL,
  title TEXT NOT NULL,
  topic TEXT,
  json_data TEXT NOT NULL,  -- Full content as JSON
  item_count INTEGER,  -- Number of cards/questions
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  completed_at INTEGER,  -- When fully studied
  is_favorite INTEGER DEFAULT 0,
  is_archived INTEGER DEFAULT 0,
  metadata TEXT  -- Additional JSON metadata
);

-- Individual items within content (for SRS tracking)
CREATE TABLE content_items (
  id TEXT PRIMARY KEY,
  content_id TEXT NOT NULL,
  item_index INTEGER NOT NULL,
  item_type TEXT NOT NULL,  -- 'card', 'question', 'message'
  item_data TEXT NOT NULL,  -- JSON for this specific item
  FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE
);

-- SRS review scheduling
CREATE TABLE reviews (
  id TEXT PRIMARY KEY,
  content_id TEXT NOT NULL,
  item_id TEXT NOT NULL,
  next_review INTEGER NOT NULL,
  interval_days INTEGER NOT NULL,
  ease_factor REAL NOT NULL DEFAULT 2.5,
  repetition_count INTEGER NOT NULL DEFAULT 0,
  last_result TEXT,  -- 'again', 'hard', 'good', 'easy'
  last_reviewed INTEGER,
  FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE,
  FOREIGN KEY (item_id) REFERENCES content_items(id) ON DELETE CASCADE
);

-- Study activities log
CREATE TABLE activities (
  id TEXT PRIMARY KEY,
  content_id TEXT NOT NULL,
  activity_type TEXT NOT NULL,  -- 'study', 'quiz', 'review'
  started_at INTEGER NOT NULL,
  completed_at INTEGER,
  duration_seconds INTEGER,
  items_total INTEGER,
  items_completed INTEGER,
  score REAL,  -- For quizzes: percentage correct
  accuracy REAL,  -- For flashcards: known percentage
  data TEXT,  -- Additional JSON data
  FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE
);

-- User profile
CREATE TABLE user_profile (
  id TEXT PRIMARY KEY DEFAULT 'default',
  display_name TEXT,
  languages TEXT NOT NULL,  -- JSON array
  proficiency_levels TEXT NOT NULL,  -- JSON object {lang: level}
  goals TEXT,  -- JSON array
  onboarding_complete INTEGER DEFAULT 0,
  onboarding_step INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  last_active INTEGER NOT NULL
);

-- User settings (key-value store)
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at INTEGER NOT NULL
);

-- Import/export history
CREATE TABLE data_transfers (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,  -- 'export', 'import'
  format TEXT NOT NULL,  -- 'json', 'csv'
  file_name TEXT,
  file_size INTEGER,
  items_count INTEGER,
  status TEXT NOT NULL,  -- 'pending', 'complete', 'failed'
  error_message TEXT,
  created_at INTEGER NOT NULL,
  completed_at INTEGER
);

-- Indexes
CREATE INDEX idx_content_type ON content(type);
CREATE INDEX idx_content_language ON content(language);
CREATE INDEX idx_content_created ON content(created_at DESC);
CREATE INDEX idx_content_favorite ON content(is_favorite);
CREATE INDEX idx_content_items_content ON content_items(content_id);
CREATE INDEX idx_reviews_next ON reviews(next_review);
CREATE INDEX idx_reviews_content ON reviews(content_id);
CREATE INDEX idx_activities_content ON activities(content_id);
CREATE INDEX idx_activities_date ON activities(started_at DESC);
```

---

## Missing Services for UX Support

Based on the UX workflows, these services need to be added or clarified:

### 1. Clipboard Service
```dart
abstract class ClipboardService {
  Future<void> copyText(String text);
  Future<String?> pasteText();
  Future<void> showCopyFeedback(String message);
}
```

### 2. Share/Export Service
```dart
abstract class ShareService {
  Future<void> shareFile({
    required String filePath,
    required String mimeType,
    String? subject,
  });
  
  Future<String> getExportPath(String filename);
  
  Future<ExportResult> exportUserData({
    required ExportFormat format,
    bool includeContent = true,
    bool includeProgress = true,
    bool includeSettings = true,
  });
}
```

### 3. Onboarding Service
```dart
abstract class OnboardingService {
  bool get isComplete;
  int get currentStep;
  int get totalSteps;
  
  Future<UserProfile> getInitialProfile();
  Future<void> updateProfile(UserProfile profile);
  Future<void> completeStep(int step);
  Future<void> skip();
  Future<void> reset();
}
```

### 4. Navigation Service
```dart
abstract class NavigationService {
  Future<void> navigateToContent(Content content);
  Future<void> navigateToStudySession(Content content);
  Future<void> navigateToImport();
  Future<void> navigateToGenerator(ContentType type);
  Future<void> navigateToProgress();
  void showSnackBar(String message, {SnackBarAction? action});
  Future<bool?> showConfirmDialog(String title, String message);
}
```

---

## Provider/State Management Review

### Current Architecture Providers

| Provider | UX Screens Served | Status |
|----------|------------------|--------|
| `UserProvider` | Onboarding, Settings, Profile | ✅ Defined |
| `ContentProvider` | Library, Generator | ✅ Defined |
| `ProgressProvider` | Dashboard, Progress | ✅ Defined |
| `LearningSessionProvider` | Flashcard, Quiz, Conversation | ✅ Defined |

### Additional Providers Needed

```dart
// For prompt generation flow
class PromptProvider extends ChangeNotifier {
  ContentType _selectedType = ContentType.flashcard;
  Map<String, dynamic> _options = {};
  String? _generatedPrompt;
  bool _isCopied = false;
  
  void configure(ContentType type, Map<String, dynamic> options);
  void generatePrompt();
  void markCopied();
  void reset();
}

// For JSON import flow
class ImportProvider extends ChangeNotifier {
  String? _rawJson;
  ParseResult? _parseResult;
  ValidationResult? _validationResult;
  ImportStatus _status = ImportStatus.idle;
  
  Future<void> parseJson(String json);
  Future<void> validateContent();
  Future<void> saveContent();
  void reset();
}

// For onboarding flow
class OnboardingProvider extends ChangeNotifier {
  int _currentStep = 0;
  UserProfile _profile = UserProfile.empty();
  bool _tutorialShown = false;
  
  void nextStep();
  void previousStep();
  void updateProfile(UserProfile profile);
  Future<void> complete();
}
```

---

## Performance Considerations for UX

### JSON Parsing Performance

**UX Requirement:** Parse JSON in <2 seconds for 1MB payload

**Architecture Support:**
- `JsonParserService` defined but implementation matters
- Consider isolate for large JSON parsing

```dart
// Recommended: Use compute for large JSON
Future<Content> parseContentInBackground(String json) {
  return compute(_parseContent, json);
}

Content _parseContent(String json) {
  // Heavy parsing work in isolate
}
```

### Content Library Performance

**UX Requirement:** Smooth scrolling through 1000+ items

**Architecture Support:**
- Pagination support mentioned
- ListView.builder recommended

**Additional Recommendation:**
```dart
// Add cursor-based pagination
Future<List<Content>> getContentPage({
  String? afterId,
  int limit = 50,
  ContentFilter? filter,
});
```

### Study Session Performance

**UX Requirement:** <100ms response for card flip/rate

**Architecture Support:**
- Local SQLite queries should meet this
- Preload next few cards

```dart
// Recommended: Preload queue
class StudySessionProvider {
  final Queue<ContentItem> _preloadedItems = Queue();
  
  void preloadNextItems(int count) {
    // Load next items while user reviews current
  }
}
```

---

## Security Alignment

### UX Privacy Promises vs Architecture

| UX Promise | Architecture Support |
|------------|---------------------|
| "100% local data" | ✅ SQLite, no cloud calls |
| "No servers required" | ✅ Serverless architecture |
| "Export anytime" | ✅ ExportService defined |
| "You own your data" | ✅ Full JSON export |
| "No tracking" | ⚠️ Analytics opt-in but needs clarity |

### Recommendation: Privacy Documentation

```dart
/// Privacy-conscious analytics logging.
/// Only logs locally unless explicit consent given.
class PrivacyAwareAnalytics {
  bool _consentGiven = false;
  
  void logEvent(String event, Map<String, dynamic> params) {
    // Always log locally for progress features
    _localLog(event, params);
    
    // Only remote log with consent
    if (_consentGiven) {
      _remoteLog(event, params);
    }
  }
}
```

---

## Recommendations Summary

### Immediate Actions (MVP)

1. **Unify Database Schema** - Use `ARCHITECTURE_OVERVIEW.md` schema, deprecate `TECHNICAL_DESIGN.md` tables
2. **Add Clipboard Service** - Essential for copy-paste workflow
3. **Add Onboarding Service** - Track onboarding progress
4. **Add Import Provider** - Manage JSON paste/parse state
5. **Add Share Service** - Support data export to files

### Technical Debt to Address

1. **`TECHNICAL_DESIGN.md`** - Marked as partially outdated, needs full rewrite
2. **Content Pack Tables** - Remove from schema (not in LLM shell model)
3. **Network Service** - Remove or repurpose (no content pack downloads)

### Architecture Enhancements

1. **Isolate-based JSON Parsing** - For large payloads
2. **Content Preloading** - For smooth study sessions
3. **Offline-first Validation** - All validation local
4. **P2P-ready Data Format** - Use CRDTs for future sync

---

## Files Requiring Updates

| File | Action | Priority |
|------|--------|----------|
| `TECHNICAL_DESIGN.md` | Add deprecation notice, reference new architecture | P0 |
| `ARCHITECTURE_OVERVIEW.md` | Add missing services (Clipboard, Share, Onboarding) | P0 |
| Database schema in both docs | Reconcile to single source of truth | P0 |
| `lib/services/` | Implement missing services | P1 |
| `lib/main.dart` | Add Provider setup | P1 |

---

**Review Status:** Complete  
**Architecture Alignment:** ✅ Good with gaps identified  
**Next Steps:** Update `TECHNICAL_DESIGN.md` with deprecation notice, add missing services to `ARCHITECTURE_OVERVIEW.md`

