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
  Future<void> exportData(String path);
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

### Permissions
**Minimum Required**:
- INTERNET (for future API calls, not MVP)
- WRITE_EXTERNAL_STORAGE (for export, scoped storage)

**Not Required**:
- Location, Camera, Microphone, Contacts, etc.

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

### Phase 3: Cloud Sync
```dart
abstract class SyncService {
  Future<void> syncUp();
  Future<void> syncDown();
  Stream<SyncStatus> watchStatus();
}
```

### Phase 4: Multi-Platform
- iOS app (same codebase)
- Web app (Flutter web)
- Desktop apps (Flutter desktop)
- Shared data layer with platform-specific UI

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
