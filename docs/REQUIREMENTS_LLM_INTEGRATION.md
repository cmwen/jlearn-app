# Functional Requirements: LLM Integration Architecture

**Created**: 2025-12-04  
**Status**: Draft  
**Version**: 1.0  
**Related Docs**: PRODUCT_VISION.md, USER_STORIES_MVP.md  
**Priority**: P0 (Critical for MVP)

---

## Overview

This document defines the functional requirements for integrating Large Language Models (LLMs) into JLearn App as a content generation engine. The app acts as a shell that generates prompts, receives JSON responses, and renders learning content.

## System Architecture Overview

```
┌─────────────────┐
│   User Interface│
│  (Flutter App)  │
└────────┬────────┘
         │
         ↓
┌─────────────────┐       ┌──────────────────┐
│  Prompt Engine  │       │ Progress Tracker │
│  (App Logic)    │←──────│   (Local DB)     │
└────────┬────────┘       └──────────────────┘
         │
         ↓ (Copy/Share)
┌─────────────────┐
│   User's LLM    │
│ (ChatGPT, etc)  │
└────────┬────────┘
         │
         ↓ (Paste JSON)
┌─────────────────┐
│  JSON Parser    │
│  & Validator    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Content Renderer│
│  (Components)   │
└─────────────────┘
```

## FR-1: Prompt Generation System

### FR-1.1: Context-Aware Prompt Builder
**Priority**: P0  
**Description**: App generates structured prompts that include user's learning context, progress, and desired content type.

**Requirements**:
- Prompt includes: target language, user's proficiency level, learning goals, current unit/topic, previous performance metrics
- Prompt format optimized for JSON output from LLMs
- Prompts include clear JSON schema definition
- Support for different learning component types (flashcards, quiz, conversation, grammar)
- Prompt templates stored locally and customizable

**Acceptance Criteria**:
- [ ] Prompt includes all necessary context from user profile
- [ ] Prompt explicitly requests JSON format with schema
- [ ] Prompt adapts based on previous session results
- [ ] Generated prompt is copyable with one tap
- [ ] Prompt length optimized for LLM context windows

### FR-1.2: Prompt Template Library
**Priority**: P1  
**Description**: Pre-built, tested prompt templates for different learning activities.

**Requirements**:
- Flashcard generation template
- Multiple-choice quiz template
- Conversation practice template
- Grammar explanation template
- Vocabulary list template
- Reading comprehension template
- Writing exercise template

**Acceptance Criteria**:
- [ ] At least 5 core templates in MVP
- [ ] Templates produce consistent JSON output
- [ ] Templates tested with ChatGPT, Gemini, Claude
- [ ] Templates include fallback/retry instructions
- [ ] Templates handle different proficiency levels (A1-C2)

### FR-1.3: Progressive Difficulty Adjustment
**Priority**: P1  
**Description**: Prompts automatically adjust difficulty based on user's performance.

**Requirements**:
- Track success rate per topic/exercise type
- Increase difficulty after consistent success (e.g., 80%+ accuracy)
- Decrease difficulty after consistent struggle (e.g., <50% accuracy)
- Include current difficulty level in prompt context
- Support manual difficulty override

**Acceptance Criteria**:
- [ ] Difficulty adjusts based on last 10 exercises
- [ ] Difficulty change is gradual (not sudden jumps)
- [ ] User can see current difficulty level
- [ ] User can manually set difficulty
- [ ] Difficulty resets appropriately for new topics

## FR-2: LLM Integration Methods

### FR-2.1: BYOK (Bring Your Own Key) - Copy/Paste Method
**Priority**: P0 (MVP)  
**Description**: User manually copies prompt, pastes to their LLM, and copies JSON response back.

**Requirements**:
- One-tap copy prompt to clipboard
- Clear instructions for where to paste (ChatGPT, Gemini, etc.)
- Paste area for JSON response in app
- Visual feedback for copy/paste actions
- Error handling for malformed JSON
- Retry mechanism if parsing fails

**Acceptance Criteria**:
- [ ] Copy button with success feedback
- [ ] Multi-line paste field for JSON
- [ ] Auto-detect JSON boundaries in paste
- [ ] Show parsing errors with helpful messages
- [ ] Allow re-paste if first attempt fails
- [ ] Works on Android without permissions issues

### FR-2.2: BYOK - Direct API Integration (Future)
**Priority**: P2 (Post-MVP)  
**Description**: User provides API key, app calls LLM directly.

**Requirements**:
- Secure API key storage (encrypted)
- Support for OpenAI, Google AI, Anthropic APIs
- Cost tracking and usage limits
- Timeout handling
- Rate limit handling
- Error retry logic

**Acceptance Criteria**:
- [ ] API keys encrypted at rest
- [ ] User can add/remove/switch keys
- [ ] Show estimated cost per request
- [ ] Graceful degradation on API errors
- [ ] Works offline for prompt generation
- [ ] Network requests use HTTPS only

### FR-2.3: SDK Integration (Future)
**Priority**: P3 (Post-MVP)  
**Description**: Simplified one-click integration with LLM providers.

**Requirements**:
- OAuth flow for supported providers
- Automatic prompt generation and response parsing
- Cost optimization (caching, batching)
- Fallback to BYOK if SDK unavailable

**Acceptance Criteria**:
- [ ] OAuth implementation secure
- [ ] At least one provider SDK integrated
- [ ] Seamless UX (no copy/paste)
- [ ] Can switch back to BYOK anytime
- [ ] SDK errors don't crash app

## FR-3: JSON Response Handling

### FR-3.1: JSON Schema Definition
**Priority**: P0  
**Description**: Standardized JSON schemas for each learning component type.

**Requirements**:
- **Flashcard Schema**:
  ```json
  {
    "type": "flashcard_set",
    "language": "japanese",
    "level": "A2",
    "cards": [
      {
        "id": "string",
        "front": "string",
        "back": "string",
        "example": "string (optional)",
        "pronunciation": "string (optional)",
        "image_prompt": "string (optional)"
      }
    ]
  }
  ```

- **Quiz Schema**:
  ```json
  {
    "type": "quiz",
    "language": "japanese",
    "level": "A2",
    "questions": [
      {
        "id": "string",
        "question": "string",
        "options": ["string"],
        "correct_answer": "string",
        "explanation": "string"
      }
    ]
  }
  ```

- **Conversation Schema**:
  ```json
  {
    "type": "conversation",
    "language": "japanese",
    "level": "A2",
    "context": "string",
    "messages": [
      {
        "id": "string",
        "speaker": "A or B",
        "text": "string",
        "translation": "string (optional)"
      }
    ],
    "practice_prompts": ["string"]
  }
  ```

**Acceptance Criteria**:
- [ ] Schemas documented in app
- [ ] Schemas included in prompt templates
- [ ] Parser validates against schema
- [ ] Clear error messages for schema violations
- [ ] Schemas support optional fields gracefully

### FR-3.2: JSON Validation & Parsing
**Priority**: P0  
**Description**: Robust parsing and validation of LLM-generated JSON.

**Requirements**:
- Validate JSON structure before parsing
- Handle extra whitespace/formatting
- Extract JSON from markdown code blocks (```json)
- Detect and handle partial JSON
- Provide specific error messages
- Support retry with correction hints

**Acceptance Criteria**:
- [ ] Successfully parses well-formed JSON 100%
- [ ] Extracts JSON from markdown blocks
- [ ] Handles Unicode characters correctly
- [ ] Shows line number for JSON errors
- [ ] Suggests fixes for common errors
- [ ] Logs parsing issues for debugging

### FR-3.3: Content Validation
**Priority**: P0  
**Description**: Validate generated content for quality and appropriateness.

**Requirements**:
- Check for empty required fields
- Validate correct answer exists in quiz options
- Check minimum content length
- Detect placeholder text (e.g., "[Your text here]")
- Flag inappropriate content (profanity filter)
- Verify language matches request

**Acceptance Criteria**:
- [ ] Empty fields rejected with clear message
- [ ] Quiz answers validated against options
- [ ] Content meets minimum quality bar
- [ ] Placeholders detected and flagged
- [ ] Basic profanity filtering active
- [ ] Language detection prevents mismatches

## FR-4: Learning Components

### FR-4.1: Flashcard Component
**Priority**: P0  
**Description**: Render and interact with flashcard content from JSON.

**Requirements**:
- Display front/back with flip animation
- Show pronunciation if available
- Display example sentences
- Mark as known/unknown
- Track review performance
- Spaced repetition scheduling
- Export/import flashcard sets

**Acceptance Criteria**:
- [ ] Cards flip smoothly on tap
- [ ] All JSON fields render correctly
- [ ] Performance tracked per card
- [ ] SRS algorithm adjusts review timing
- [ ] Can navigate through card set
- [ ] Progress saved locally

### FR-4.2: Quiz Component
**Priority**: P0  
**Description**: Render interactive quizzes from JSON.

**Requirements**:
- Display question with multiple options
- Highlight selected answer
- Show correct/incorrect feedback
- Display explanation after answer
- Track score and time
- Review incorrect answers
- Retry quiz option

**Acceptance Criteria**:
- [ ] Questions display clearly
- [ ] Options are tappable
- [ ] Immediate feedback on selection
- [ ] Explanation shows after answer
- [ ] Score calculated correctly
- [ ] Can review all questions at end

### FR-4.3: Conversation Component
**Priority**: P1  
**Description**: Display dialogue-based learning content.

**Requirements**:
- Show multi-turn conversations
- Display speaker labels
- Toggle translation visibility
- Audio playback integration (future)
- Practice prompts after dialogue
- Role-play mode (user responds)

**Acceptance Criteria**:
- [ ] Conversations display in sequence
- [ ] Speakers visually distinguished
- [ ] Translation toggleable per message
- [ ] Practice prompts actionable
- [ ] Smooth scrolling through dialogue
- [ ] Export conversation for reference

### FR-4.4: Grammar Explanation Component
**Priority**: P1  
**Description**: Render structured grammar lessons.

**Requirements**:
- Display grammar rule explanation
- Show examples with translations
- Display exception cases
- Include practice exercises
- Link to related grammar topics
- Save for later reference

**Acceptance Criteria**:
- [ ] Explanations formatted readably
- [ ] Examples highlighted appropriately
- [ ] Tables/lists render correctly
- [ ] Can bookmark for review
- [ ] Search within explanations
- [ ] Export to notes

## FR-5: Progress Tracking

### FR-5.1: Learning History
**Priority**: P0  
**Description**: Track all generated content and user performance.

**Requirements**:
- Store generated content locally
- Track completion status
- Record performance metrics (accuracy, time)
- Store timestamp of each activity
- Associate content with learning path
- Calculate streaks and milestones

**Acceptance Criteria**:
- [ ] All activities saved to local DB
- [ ] Performance metrics calculable
- [ ] History viewable by date/type
- [ ] Can replay previous activities
- [ ] Data exportable for backup
- [ ] Storage optimized (not bloated)

### FR-5.2: Adaptive Learning Recommendations
**Priority**: P1  
**Description**: Use progress data to suggest next activities.

**Requirements**:
- Identify weak areas (low accuracy topics)
- Suggest review for items due in SRS
- Recommend new topics when ready
- Balance variety (quiz, flashcard, conversation)
- Track learning velocity
- Set and track goals

**Acceptance Criteria**:
- [ ] Daily recommendation generated
- [ ] Recommendations based on actual data
- [ ] User can see recommendation reasoning
- [ ] Can override recommendations
- [ ] Goals trackable with progress bars
- [ ] Notifications for due reviews (optional)

### FR-5.3: Progress Analytics Dashboard
**Priority**: P2  
**Description**: Visualize learning progress and insights.

**Requirements**:
- Total time studied
- Items learned per day/week
- Accuracy trends over time
- Weak vs strong topics
- Streak tracking
- Goal progress
- Level advancement indicators

**Acceptance Criteria**:
- [ ] Dashboard loads quickly
- [ ] Charts clear and informative
- [ ] Data accurate with activities
- [ ] Can filter by time period
- [ ] Export progress report
- [ ] Share achievements (optional)

## FR-6: Content Management

### FR-6.1: Content Library
**Priority**: P1  
**Description**: Organize and access all generated content.

**Requirements**:
- Browse by content type
- Search within content
- Filter by language/level/date
- Tag content with custom labels
- Archive completed content
- Delete unwanted content
- Share content with others (export)

**Acceptance Criteria**:
- [ ] Library organized and navigable
- [ ] Search finds relevant content
- [ ] Filters work correctly
- [ ] Tags editable by user
- [ ] Archive doesn't delete data
- [ ] Export works reliably

### FR-6.2: Favorites and Bookmarks
**Priority**: P2  
**Description**: Mark important content for quick access.

**Requirements**:
- Favorite any piece of content
- Create custom collections
- Quick access to favorites
- Sort favorites by date/type
- Remove from favorites easily

**Acceptance Criteria**:
- [ ] Favorite button visible on content
- [ ] Favorites list easily accessible
- [ ] Can organize into collections
- [ ] Search within favorites
- [ ] Unfavorite simple to do

## FR-7: User Onboarding

### FR-7.1: First-Time Setup
**Priority**: P0  
**Description**: Guide new users through app setup and first content generation.

**Requirements**:
- Language selection
- Proficiency level self-assessment
- Learning goals definition
- LLM setup explanation (BYOK)
- Tutorial for copy/paste workflow
- Generate first sample content
- Show progress tracking features
- **Explain local-first, serverless architecture**
- **Highlight data ownership and privacy benefits**

**Acceptance Criteria**:
- [ ] Onboarding completable in <5 min
- [ ] Each step clearly explained
- [ ] Can skip to return later
- [ ] Sample content generated successfully
- [ ] User understands basic workflow
- [ ] Settings accessible post-onboarding
- [ ] User informed about data ownership (local-first, no servers)
- [ ] User understands export capabilities

### FR-7.2: In-App Tutorials
**Priority**: P1  
**Description**: Help users understand features through guided tours.

**Requirements**:
- Prompt generation tutorial
- JSON paste tutorial
- Component interaction tutorials
- Progress tracking explanation
- Settings and customization guide
- Data export tutorial

**Acceptance Criteria**:
- [ ] Tutorials accessible from menu
- [ ] Can be replayed anytime
- [ ] Interactive (not just text)
- [ ] Dismissible if already known
- [ ] Context-sensitive help available

## FR-8: Error Handling & User Feedback

### FR-8.1: Error Messages
**Priority**: P0  
**Description**: Clear, actionable error messages for common issues.

**Requirements**:
- JSON parsing errors with suggestions
- Network errors (for API integration)
- Content validation errors
- Storage errors (disk full)
- Recovery options for each error type

**Acceptance Criteria**:
- [ ] No technical jargon in errors
- [ ] Suggest concrete next steps
- [ ] Allow retry for transient errors
- [ ] Don't lose user's work on error
- [ ] Log errors for debugging
- [ ] Show FAQ link for common issues

### FR-8.2: User Feedback Mechanism
**Priority**: P2  
**Description**: Collect feedback on generated content and app experience.

**Requirements**:
- Rate generated content (thumbs up/down)
- Report problematic content
- Suggest improvements
- Bug reporting feature
- Feature request submission

**Acceptance Criteria**:
- [ ] Feedback buttons unobtrusive
- [ ] Feedback submitted successfully
- [ ] User notified of submission
- [ ] Can include screenshots
- [ ] Privacy preserved in feedback

## Non-Functional Requirements

### NFR-1: Performance
- Prompt generation: <1 second
- JSON parsing: <2 seconds for 1MB payload
- Content rendering: <3 seconds
- App launch: <3 seconds cold start
- Local database queries: <100ms

### NFR-2: Reliability
- JSON parsing success rate: >95%
- Content validation accuracy: >90%
- App crash rate: <0.1% of sessions
- Data persistence: 100% (no data loss)

### NFR-3: Usability
- Copy/paste workflow completable in <10 seconds
- Onboarding completable in <5 minutes
- Core features discoverable without manual
- Error recovery without data loss

### NFR-4: Security
- API keys encrypted with platform keystore
- No plaintext secrets in logs
- HTTPS only for network requests
- Local data encrypted on device
- Permissions minimal (clipboard, storage)

### NFR-5: Compatibility
- Android 8.0+ (API level 26+)
- Works on phones and tablets
- Supports all Android screen sizes
- RTL language support
- Dark mode support

### NFR-6: Scalability
- Support 10,000+ content items per user
- Database size <100MB for typical user
- Efficient query performance at scale
- Memory usage <200MB during normal use

---

## Dependencies

- Flutter 3.10.1+
- Dart 3.10.1+
- sqflite (local database)
- shared_preferences (settings)
- clipboard (copy/paste)
- provider/bloc (state management)

## Assumptions

1. Users have access to at least one LLM (ChatGPT, Gemini, etc.)
2. LLMs can generate valid JSON when properly prompted
3. Users understand basic copy/paste operations
4. Internet connectivity available for LLM access (not for app core features)
5. Users willing to manually copy/paste in MVP phase

## Open Questions

1. How to handle very large JSON responses (>1MB)?
2. Should we support image generation prompts for visual learners?
3. How to version JSON schemas as they evolve?
4. Should we support offline content generation (pre-fetched)?
5. How to handle multiple languages simultaneously?

---

**Next Steps**:
- Create user stories for each requirement
- Define JSON schemas in detail
- Design UI mockups for components
- Plan database schema
- Estimate implementation effort
