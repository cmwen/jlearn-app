# Technical Architecture: LLM-Powered Language Learning Shell

**Created**: 2025-12-04  
**Status**: Draft  
**Version**: 1.0  
**Related Docs**: PRODUCT_VISION.md, REQUIREMENTS_LLM_INTEGRATION.md, IMPLEMENTATION_ROADMAP.md

---

## System Overview

JLearn App is architected as a **client-side learning shell** that orchestrates content generation through LLMs while maintaining all learning state and progress locally. The system is designed for offline-first operation with optional cloud sync in future iterations.

## Architecture Principles

1. **Local-First**: All core functionality works offline except LLM interaction
2. **Provider-Agnostic**: No dependency on specific LLM vendor
3. **Data Sovereignty**: User owns all data, nothing sent to our servers
4. **Privacy-Focused**: Minimal permissions, encrypted storage
5. **Extensible**: Plugin architecture for future content types
6. **Testable**: Clear separation of concerns, dependency injection
7. **Serverless**: Zero backend infrastructure, no cloud dependencies
8. **Data Liberation**: Full export/import in open formats
9. **P2P-Ready**: Architecture supports future peer-to-peer synchronization

---

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Onboarding │  │    Home      │  │   Learning   │      │
│  │    Screens   │  │   Dashboard  │  │  Components  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Content    │  │   Progress   │  │   Settings   │      │
│  │   Library    │  │   Analytics  │  │    Screen    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                     Business Logic Layer                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Prompt     │  │     JSON     │  │   Progress   │      │
│  │  Generator   │  │    Parser    │  │   Tracker    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │     SRS      │  │  Validation  │  │Recommendation│      │
│  │   Algorithm  │  │    Engine    │  │    Engine    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                        Data Layer                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Repository  │  │  Repository  │  │  Repository  │      │
│  │    Content   │  │   Progress   │  │    User      │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                     Persistence Layer                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │    SQLite    │  │   Shared     │  │   Secure     │      │
│  │   Database   │  │ Preferences  │  │   Storage    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘

                    External Integration
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                    User's LLM Provider                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   ChatGPT    │  │    Gemini    │  │   Claude     │      │
│  │   (OpenAI)   │  │   (Google)   │  │ (Anthropic)  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
        (via manual copy/paste or API in future)
```

---

## Layer Details

### 1. Presentation Layer

**Responsibility**: User interface and user interaction

**Technologies**:
- Flutter widgets (Material Design 3)
- Provider/Bloc for state management
- Navigation 2.0 for routing

**Key Components**:

#### Onboarding Flow
- Welcome screen with value proposition
- Language selection picker
- Proficiency level assessment
- Learning goals configuration
- LLM setup tutorial

#### Home Dashboard
- Daily recommendation card
- Quick actions (generate content)
- Progress summary widgets
- Recent activity list
- Streak tracker

#### Learning Components
- **FlashcardView**: Flip animation, swipe gestures, SRS integration
- **QuizView**: Question display, option selection, feedback, review
- **ConversationView**: Chat-like interface, translation toggles
- **GrammarView**: Formatted lessons, examples, exercises

#### Content Library
- Grid/list toggle view
- Search and filter controls
- Sort options
- Content preview cards
- Action buttons (replay, delete, share)

#### Progress Analytics
- Charts (line, bar, pie)
- Statistics cards
- Achievement badges
- Goal tracking
- Export functionality

#### Settings
- Profile management
- Appearance customization
- Notification preferences
- Data management (export/delete)
- Help and support links

---

### 2. Business Logic Layer

**Responsibility**: Core application logic and business rules

**Technologies**:
- Dart pure business logic
- Dependency injection (get_it or provider)
- RxDart for reactive streams (optional)

**Key Services**:

#### Prompt Generator Service
```dart
class PromptGeneratorService {
  String generateFlashcardPrompt({
    required Language language,
    required ProficiencyLevel level,
    required Topic topic,
    required int cardCount,
    required UserContext context,
  });
  
  String generateQuizPrompt({...});
  String generateConversationPrompt({...});
  String generateGrammarPrompt({...});
}
```

**Features**:
- Template-based generation
- Context injection (user progress, weak areas)
- Difficulty adjustment
- JSON schema inclusion
- Retry instructions

#### JSON Parser Service
```dart
class JsonParserService {
  Result<Content, ParseError> parseContent(String jsonString);
  FlashcardSet parseFlashcardSet(Map<String, dynamic> json);
  Quiz parseQuiz(Map<String, dynamic> json);
  Conversation parseConversation(Map<String, dynamic> json);
  GrammarLesson parseGrammarLesson(Map<String, dynamic> json);
}
```

**Features**:
- Markdown extraction (strip ```json)
- Schema validation
- Field validation
- Error context generation
- Graceful degradation

#### Progress Tracker Service
```dart
class ProgressTrackerService {
  void recordActivity(Content content, PerformanceData performance);
  double calculateAccuracy(String topic, Duration timeframe);
  List<Topic> getWeakAreas(int threshold);
  List<Content> getDueReviews(DateTime date);
  ProgressMetrics getOverallProgress();
}
```

**Features**:
- Activity logging
- Performance aggregation
- Weak area identification
- Trend analysis
- Goal tracking

#### SRS Algorithm Service
```dart
class SrsAlgorithmService {
  DateTime calculateNextReview(
    Content content,
    ReviewResult result,
    int repetitionCount,
  );
  
  List<Content> getDueItems(DateTime now);
  void adjustSchedule(Content content, ReviewResult result);
}
```

**Algorithm**: Modified SM-2 (SuperMemo)
- Easy: interval × 2.5
- Good: interval × 2.0
- Hard: interval × 1.2
- Again: reset to 1 day

#### Validation Engine
```dart
class ValidationEngine {
  ValidationResult validateContent(Content content);
  List<ValidationIssue> checkFlashcardSet(FlashcardSet set);
  List<ValidationIssue> checkQuiz(Quiz quiz);
  bool isContentComplete(Content content);
  bool isContentAppropriate(Content content);
}
```

**Validations**:
- Required fields present
- Field length limits
- Cross-references (quiz answers in options)
- Placeholder detection
- Profanity filtering (basic)

#### Recommendation Engine
```dart
class RecommendationEngine {
  Recommendation getDailyRecommendation(UserProfile user);
  List<Content> suggestNextActivities(int count);
  ContentType balanceContentTypes(List<HistoryItem> recent);
  Topic selectNextTopic(List<Topic> mastered, List<Topic> weak);
}
```

**Logic**:
- Prioritize due reviews (SRS)
- Focus on weak areas
- Balance content variety
- Consider user goals
- Adapt to learning velocity

#### Clipboard Service
```dart
/// Manages clipboard operations for copy-paste LLM workflow
class ClipboardService {
  /// Copy generated prompt to system clipboard
  Future<void> copyText(String text);
  
  /// Read pasted JSON from clipboard
  Future<String?> pasteText();
  
  /// Show visual feedback after copy operation
  void showCopyFeedback(BuildContext context, String message);
  
  /// Check if clipboard has text content
  Future<bool> hasClipboardContent();
}
```

**Features**:
- System clipboard integration
- Haptic feedback on copy
- Visual confirmation (snackbar/toast)
- Error handling for clipboard access

#### Onboarding Service
```dart
/// Manages first-time user experience and tutorial state
class OnboardingService {
  /// Check if onboarding has been completed
  bool get isComplete;
  
  /// Current step in onboarding flow (0-based)
  int get currentStep;
  
  /// Total number of onboarding steps
  int get totalSteps;
  
  /// Get the user profile being built during onboarding
  Future<UserProfile> getInitialProfile();
  
  /// Update profile during onboarding
  Future<void> updateProfile(UserProfile profile);
  
  /// Mark a step as completed
  Future<void> completeStep(int step);
  
  /// Skip remaining onboarding
  Future<void> skip();
  
  /// Reset onboarding (for testing or re-onboarding)
  Future<void> reset();
  
  /// Check if specific tutorial has been shown
  bool isTutorialShown(String tutorialId);
  
  /// Mark tutorial as shown
  Future<void> markTutorialShown(String tutorialId);
}
```

**Features**:
- Persisted onboarding state
- Step-by-step progress tracking
- Tutorial replay support
- Profile building during onboarding

#### Share/Export Service
```dart
/// Handles data export and platform sharing
class ShareExportService {
  /// Export all user data to a file
  Future<ExportResult> exportAllData({
    required ExportFormat format,  // json, csv
    bool includeContent = true,
    bool includeProgress = true,
    bool includeSettings = true,
  });
  
  /// Export specific content items
  Future<ExportResult> exportContent({
    required List<String> contentIds,
    required ExportFormat format,
  });
  
  /// Get metadata about what will be exported
  Future<ExportMetadata> getExportMetadata();
  
  /// Share a file using platform share sheet
  Future<void> shareFile({
    required String filePath,
    required String mimeType,
    String? subject,
    String? text,
  });
  
  /// Get appropriate export directory path
  Future<String> getExportPath(String filename);
  
  /// Import data from exported file (future)
  Future<ImportResult> importData(String filePath);
  
  /// Validate import file before importing
  Future<ValidationResult> validateImportFile(String filePath);
}

class ExportResult {
  final bool success;
  final String? filePath;
  final int itemsExported;
  final int fileSizeBytes;
  final String? errorMessage;
}

class ExportMetadata {
  final int contentCount;
  final int activityCount;
  final int estimatedSizeBytes;
  final DateTime exportDate;
  final String schemaVersion;
}
```

**Features**:
- Multiple export formats (JSON, CSV)
- Selective export (content, progress, settings)
- Platform share sheet integration
- Schema versioning for future compatibility
- Import validation

#### Navigation Service
```dart
/// Centralized navigation for consistent UX flows
class NavigationService {
  /// Navigate to specific content for viewing
  Future<void> navigateToContent(Content content);
  
  /// Start a study session for content
  Future<void> navigateToStudySession(Content content);
  
  /// Open the JSON import screen
  Future<void> navigateToImport({String? prefilledJson});
  
  /// Open content generator for specific type
  Future<void> navigateToGenerator(ContentType type);
  
  /// Show progress/analytics screen
  Future<void> navigateToProgress();
  
  /// Show settings screen
  Future<void> navigateToSettings();
  
  /// Show a snackbar message
  void showSnackBar(String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  });
  
  /// Show confirmation dialog
  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  });
  
  /// Show error dialog with optional retry
  Future<bool?> showErrorDialog({
    required String title,
    required String message,
    String? retryText,
  });
}
```

**Features**:
- Type-safe navigation
- Consistent snackbar/dialog patterns
- Deep linking support (future)
- Analytics integration (local)

---

### 3. Data Layer

**Responsibility**: Data access abstraction and caching

**Technologies**:
- Repository pattern
- Abstract interfaces
- Future/Stream APIs

**Repositories**:

#### Content Repository
```dart
abstract class ContentRepository {
  Future<void> saveContent(Content content);
  Future<Content?> getContentById(String id);
  Future<List<Content>> getAllContent({ContentFilter? filter});
  Future<List<Content>> searchContent(String query);
  Future<void> deleteContent(String id);
  Future<void> updateContent(Content content);
  Stream<List<Content>> watchContent();
}
```

#### Progress Repository
```dart
abstract class ProgressRepository {
  Future<void> recordActivity(Activity activity);
  Future<List<Activity>> getActivities({DateRange? range});
  Future<ProgressMetrics> getMetrics({DateRange? range});
  Future<List<Review>> getReviewsDue(DateTime date);
  Future<void> updateReviewSchedule(String contentId, DateTime nextReview);
}
```

#### User Repository
```dart
abstract class UserRepository {
  Future<UserProfile> getUserProfile();
  Future<void> updateProfile(UserProfile profile);
  Future<UserSettings> getSettings();
  Future<void> updateSettings(UserSettings settings);
  
  // Data ownership & export
  Future<ExportResult> exportAllData(String path, ExportFormat format);
  Future<ImportResult> importData(String path);
  Future<Map<String, dynamic>> getExportMetadata();
}
```

---

### 4. Persistence Layer

**Responsibility**: Physical data storage

**Technologies**:
- sqflite for SQLite database
- shared_preferences for simple key-value
- flutter_secure_storage for sensitive data

#### Database Schema

**content** table:
```sql
CREATE TABLE content (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  language TEXT NOT NULL,
  level TEXT NOT NULL,
  title TEXT NOT NULL,
  json_data TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  tags TEXT,  -- JSON array
  is_favorite INTEGER DEFAULT 0,
  is_archived INTEGER DEFAULT 0
);
```

**activities** table:
```sql
CREATE TABLE activities (
  id TEXT PRIMARY KEY,
  content_id TEXT NOT NULL,
  activity_type TEXT NOT NULL,
  started_at INTEGER NOT NULL,
  completed_at INTEGER NOT NULL,
  duration INTEGER NOT NULL,
  score REAL,
  accuracy REAL,
  data TEXT,  -- JSON additional data
  FOREIGN KEY (content_id) REFERENCES content(id)
);
```

**reviews** table (for SRS):
```sql
CREATE TABLE reviews (
  id TEXT PRIMARY KEY,
  content_id TEXT NOT NULL,
  item_id TEXT NOT NULL,  -- e.g., specific flashcard ID
  next_review INTEGER NOT NULL,
  interval INTEGER NOT NULL,  -- days
  ease_factor REAL NOT NULL,
  repetition_count INTEGER NOT NULL,
  FOREIGN KEY (content_id) REFERENCES content(id)
);
```

**user_profile** table:
```sql
CREATE TABLE user_profile (
  id TEXT PRIMARY KEY,
  languages TEXT NOT NULL,  -- JSON array
  proficiency_level TEXT NOT NULL,
  goals TEXT,  -- JSON array
  created_at INTEGER NOT NULL,
  last_active INTEGER NOT NULL
);
```

**Indexes**:
```sql
CREATE INDEX idx_content_type ON content(type);
CREATE INDEX idx_content_language ON content(language);
CREATE INDEX idx_content_created ON content(created_at DESC);
CREATE INDEX idx_activities_content ON activities(content_id);
CREATE INDEX idx_activities_completed ON activities(completed_at DESC);
CREATE INDEX idx_reviews_next ON reviews(next_review);
```

#### SharedPreferences Usage
- App settings (theme, notifications)
- Onboarding completion status
- Feature flags
- Last sync timestamp (future)

#### Secure Storage Usage
- API keys (when BYOK API integration added)
- User tokens (future cloud sync)
- Encryption keys

---

## Data Flow Patterns

### Content Generation Flow

```
User Action: Tap "Generate Flashcards"
     ↓
1. UI collects parameters (topic, count, difficulty)
     ↓
2. PromptGeneratorService builds context-aware prompt
     ↓
3. Prompt includes: user level, recent topics, weak areas, JSON schema
     ↓
4. Prompt copied to clipboard
     ↓
5. User pastes to LLM (ChatGPT/Gemini/etc.)
     ↓
6. User copies JSON response
     ↓
7. User pastes into app
     ↓
8. JsonParserService extracts and validates JSON
     ↓
9. ValidationEngine checks content quality
     ↓
10. ContentRepository saves to database
     ↓
11. UI navigates to content view
```

### Learning Activity Flow

```
User Action: Start flashcard review
     ↓
1. ContentRepository loads flashcard set
     ↓
2. SrsAlgorithmService determines due cards
     ↓
3. UI displays cards one by one
     ↓
4. User marks each as Know/Review
     ↓
5. SrsAlgorithmService calculates next review dates
     ↓
6. ProgressTrackerService records performance
     ↓
7. ProgressRepository saves activity
     ↓
8. ReviewRepository updates schedules
     ↓
9. UI shows completion summary
     ↓
10. RecommendationEngine updates suggestions
```

### Progress Tracking Flow

```
User Action: View progress dashboard
     ↓
1. ProgressRepository queries activities
     ↓
2. ProgressTrackerService calculates metrics:
   - Total items learned
   - Average accuracy
   - Current streak
   - Time studied
     ↓
3. RecommendationEngine generates suggestions
     ↓
4. UI renders charts and statistics
     ↓
5. User can filter by date range
     ↓
6. User can export progress report
```

---

## State Management Strategy

### Approach: Provider with ChangeNotifier

**Rationale**:
- Simple and Flutter-native
- Good for MVP complexity
- Easy testing
- Can migrate to Bloc/Riverpod later if needed

### Key Providers

```dart
// User profile and settings
class UserProvider extends ChangeNotifier {
  UserProfile? _profile;
  UserSettings _settings;
  
  Future<void> loadProfile();
  Future<void> updateProfile(UserProfile profile);
  Future<void> updateSettings(UserSettings settings);
}

// Content library
class ContentProvider extends ChangeNotifier {
  List<Content> _allContent = [];
  ContentFilter? _filter;
  
  Future<void> loadContent();
  Future<void> addContent(Content content);
  Future<void> deleteContent(String id);
  void setFilter(ContentFilter filter);
  List<Content> get filteredContent;
}

// Progress and analytics
class ProgressProvider extends ChangeNotifier {
  ProgressMetrics? _metrics;
  List<Activity> _recentActivities = [];
  
  Future<void> loadProgress();
  Future<void> recordActivity(Activity activity);
  ProgressMetrics get metrics;
  List<Review> get dueReviews;
}

// Current learning session
class LearningSessionProvider extends ChangeNotifier {
  Content? _currentContent;
  int _currentIndex = 0;
  List<ReviewResult> _results = [];
  
  void startSession(Content content);
  void recordResult(ReviewResult result);
  void nextItem();
  bool get isComplete;
  SessionSummary get summary;
}
```

### Additional Providers for LLM Workflow

```dart
/// Manages prompt generation flow state
class PromptProvider extends ChangeNotifier {
  ContentType _selectedType = ContentType.flashcard;
  Map<String, dynamic> _options = {};
  String? _generatedPrompt;
  bool _isCopied = false;
  PromptStatus _status = PromptStatus.idle;
  
  ContentType get selectedType => _selectedType;
  String? get generatedPrompt => _generatedPrompt;
  bool get isCopied => _isCopied;
  PromptStatus get status => _status;
  
  /// Configure prompt generation options
  void configure({
    required ContentType type,
    required String topic,
    required String level,
    required int itemCount,
    Map<String, dynamic>? additionalOptions,
  });
  
  /// Generate prompt based on current configuration
  Future<void> generatePrompt();
  
  /// Mark prompt as copied to clipboard
  void markCopied();
  
  /// Reset for new generation
  void reset();
}

enum PromptStatus { idle, generating, ready, copied }

/// Manages JSON import/parse flow state
class ImportProvider extends ChangeNotifier {
  String? _rawJson;
  ParseResult? _parseResult;
  ValidationResult? _validationResult;
  Content? _parsedContent;
  ImportStatus _status = ImportStatus.idle;
  List<String> _errorSuggestions = [];
  
  String? get rawJson => _rawJson;
  Content? get parsedContent => _parsedContent;
  ImportStatus get status => _status;
  List<String> get errorSuggestions => _errorSuggestions;
  bool get hasErrors => _parseResult?.isError ?? false;
  String? get errorMessage => _parseResult?.errorMessage;
  int? get errorLine => _parseResult?.errorLine;
  
  /// Set JSON text from clipboard or text input
  void setJson(String json);
  
  /// Parse the JSON and validate
  Future<void> parseAndValidate();
  
  /// Edit JSON and re-parse
  void editJson(String newJson);
  
  /// Save validated content to database
  Future<void> saveContent();
  
  /// Reset for new import
  void reset();
}

enum ImportStatus { idle, parsing, validating, valid, invalid, saving, saved }

/// Manages onboarding flow state
class OnboardingProvider extends ChangeNotifier {
  int _currentStep = 0;
  final int _totalSteps = 6;
  UserProfile _profile = UserProfile.empty();
  bool _isComplete = false;
  
  int get currentStep => _currentStep;
  int get totalSteps => _totalSteps;
  UserProfile get profile => _profile;
  bool get isComplete => _isComplete;
  double get progress => _currentStep / _totalSteps;
  
  /// Move to next onboarding step
  void nextStep();
  
  /// Go back to previous step
  void previousStep();
  
  /// Update profile data during onboarding
  void updateLanguage(String language);
  void updateLevel(String level);
  void updateGoals(List<String> goals);
  
  /// Complete onboarding and save profile
  Future<void> complete();
  
  /// Skip remaining onboarding
  Future<void> skip();
  
  /// Reset onboarding (for testing)
  Future<void> reset();
}

/// Manages data export flow state
class ExportProvider extends ChangeNotifier {
  ExportFormat _format = ExportFormat.json;
  ExportOptions _options = ExportOptions.all();
  ExportStatus _status = ExportStatus.idle;
  ExportMetadata? _metadata;
  String? _exportPath;
  String? _errorMessage;
  
  ExportFormat get format => _format;
  ExportStatus get status => _status;
  ExportMetadata? get metadata => _metadata;
  String? get exportPath => _exportPath;
  
  /// Set export format
  void setFormat(ExportFormat format);
  
  /// Set what to include in export
  void setOptions(ExportOptions options);
  
  /// Load metadata (file size estimate, item counts)
  Future<void> loadMetadata();
  
  /// Execute export
  Future<void> export();
  
  /// Share the exported file
  Future<void> shareExport();
  
  /// Reset for new export
  void reset();
}

enum ExportFormat { json, csv }
enum ExportStatus { idle, preparing, exporting, complete, error }

class ExportOptions {
  final bool includeContent;
  final bool includeProgress;
  final bool includeSettings;
  
  ExportOptions({
    this.includeContent = true,
    this.includeProgress = true,
    this.includeSettings = true,
  });
  
  factory ExportOptions.all() => ExportOptions();
  factory ExportOptions.contentOnly() => ExportOptions(
    includeProgress: false,
    includeSettings: false,
  );
}
```

---

## Security Considerations

### Data Protection
- **Local Encryption**: SQLite database encrypted using sqlcipher
- **Secure Storage**: API keys in platform keystore (Android KeyStore)
- **Memory Protection**: Clear sensitive data from memory after use
- **No Plaintext Secrets**: Never log API keys or user data

### API Key Management (Future)
```dart
class SecureKeyManager {
  Future<void> storeApiKey(Provider provider, String key);
  Future<String?> getApiKey(Provider provider);
  Future<void> deleteApiKey(Provider provider);
  // Keys encrypted with device hardware-backed key
}
```

### Privacy
- **No Telemetry by Default**: Only with explicit user consent
- **Local Processing**: All learning logic client-side
- **No User Tracking**: No analytics that identify individuals
- **Data Ownership**: User can export and delete all data
- **No Servers**: Zero backend infrastructure, no data leaves device
- **Complete Transparency**: Open export format, user owns 100% of data

### Permissions
**Minimum Required**:
- INTERNET (for future API calls, not MVP)
- WRITE_EXTERNAL_STORAGE (for export, scoped storage)

**Not Required**:
- Location, Camera, Microphone, Contacts, etc.

**Future P2P Permissions** (optional, user-enabled):
- ACCESS_WIFI_STATE (for local network sync)
- BLUETOOTH (for Bluetooth sync)
- NEARBY_WIFI_DEVICES (Android 13+ for P2P discovery)

---

## Performance Optimization

### Database Optimization
- **Indexes**: On frequently queried columns (type, date, content_id)
- **Pagination**: Load content in batches (50-100 items)
- **Lazy Loading**: Load JSON data only when viewing content
- **Query Optimization**: Use EXPLAIN to optimize slow queries
- **Connection Pooling**: Reuse database connections

### Memory Management
- **Image Caching**: Use cached_network_image (future for images)
- **List Virtualization**: ListView.builder for large lists
- **Dispose Properly**: Clean up controllers and streams
- **Weak References**: For cached data that can be reloaded

### UI Performance
- **const Widgets**: Use const constructors where possible
- **RepaintBoundary**: Isolate expensive widgets
- **Debouncing**: For search and filter operations
- **Lazy Rendering**: Only build visible widgets
- **Animation Optimization**: Use Transform instead of margin/padding

### App Size
- **Code Shrinking**: Enable R8 in release builds
- **Asset Optimization**: Compress images, use vector graphics
- **Tree Shaking**: Remove unused dependencies
- **Split APKs**: Per-ABI splits to reduce download size

---

## Testing Strategy

### Unit Tests (Target: 80% coverage)
- All business logic services
- All model classes (JSON parsing)
- Repository implementations
- SRS algorithm
- Validation engine
- Recommendation engine

### Widget Tests
- All custom widgets
- Learning components
- Form validation
- Navigation flows
- Error states

### Integration Tests
- End-to-end user flows
- Database operations
- Content generation flow
- Learning session flow
- Progress tracking flow

### Test Utilities
```dart
// Mock data generators
class TestData {
  static FlashcardSet createFlashcardSet({...});
  static Quiz createQuiz({...});
  static UserProfile createUserProfile({...});
}

// Repository mocks
class MockContentRepository implements ContentRepository {...}
class MockProgressRepository implements ProgressRepository {...}
```

---

## Build & Deployment

### Build Configurations

**Development**:
```
flutter run --debug
- Debug mode enabled
- Hot reload active
- Verbose logging
- Development database
```

**Staging**:
```
flutter build apk --release --flavor staging
- Release optimizations
- Staging backend URLs (future)
- Test API keys
- Analytics disabled
```

**Production**:
```
flutter build appbundle --release
- Full optimizations
- Production configuration
- Signed release
- Analytics enabled (with consent)
```

### CI/CD Pipeline
1. **Build**: Compile and build APK/AAB
2. **Test**: Run all unit and widget tests
3. **Lint**: flutter analyze and dart format
4. **Security**: Check for vulnerabilities
5. **Deploy**: Upload to Play Store (internal → beta → production)

---

## Monitoring & Analytics

### Error Tracking
- **Sentry/Firebase Crashlytics**: Crash reporting
- **Custom Error Boundary**: Catch and log widget errors
- **Network Errors**: Log API failures (future)
- **Parsing Errors**: Track JSON parsing issues

### Performance Monitoring
- **App Startup Time**: Measure and optimize
- **Screen Render Time**: Track FPS
- **Database Query Time**: Log slow queries
- **Memory Usage**: Monitor and prevent leaks

### Analytics (Opt-in)
- **User Engagement**: Session duration, frequency
- **Feature Usage**: Which content types most popular
- **Conversion Funnels**: Onboarding completion, content generation success
- **Error Rates**: Parsing failures, validation issues

---

## Future Architecture Enhancements

### Phase 2: API Integration
```dart
abstract class LlmApiClient {
  Future<String> generateContent(String prompt);
}

class OpenAiClient implements LlmApiClient {...}
class GeminiClient implements LlmApiClient {...}
class ClaudeClient implements LlmApiClient {...}
```

### Phase 3: Data Export/Import System
```dart
class ExportService {
  Future<ExportResult> exportAllData({
    required String path,
    required ExportFormat format, // JSON, CSV
    bool includeMedia = true,
  });
  
  Future<ExportMetadata> getExportMetadata();
}

class ImportService {
  Future<ImportResult> importData(String path);
  Future<bool> validateImport(String path);
  Future<List<ImportConflict>> detectConflicts(String path);
}
```

### Phase 4: P2P Synchronization (Serverless)
```dart
abstract class P2PSyncService {
  // Local network discovery
  Stream<DiscoveredDevice> discoverDevices();
  
  // Peer-to-peer sync (no central server)
  Future<void> syncWithDevice(Device device);
  
  // Conflict resolution using CRDTs
  Future<void> resolveSyncConflicts(List<Conflict> conflicts);
  
  // End-to-end encryption
  Future<void> establishSecureChannel(Device device);
  
  Stream<SyncStatus> watchSyncStatus();
}

// Optional self-hosted sync server (user-controlled)
abstract class SelfHostedSyncService {
  Future<void> configureSyncServer(String url, Credentials creds);
  Future<void> syncWithServer();
  // User maintains their own server, no central infrastructure
}
```

### Phase 5: Multi-Platform
- iOS app (same codebase)
- Web app (Flutter web)
- Desktop apps (Flutter desktop)
- Shared data layer with platform-specific UI
- P2P sync across all platforms

---

## Developer Guidelines

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter analyze` and `dart format`
- Prefer composition over inheritance
- Write self-documenting code

### Documentation
- Document all public APIs
- Add inline comments for complex logic
- Maintain architecture decision records (ADRs)
- Update docs with code changes

### Version Control
- Feature branches from develop
- Conventional commits (feat, fix, docs, refactor)
- PR reviews required
- Squash merge to main

---

**Document Status**: Ready for development kickoff  
**Next Steps**: Begin implementation following roadmap  
**Owner**: Engineering Team  
**Last Updated**: 2025-12-04
