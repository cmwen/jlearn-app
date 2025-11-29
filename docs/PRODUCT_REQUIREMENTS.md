# JLearn - Offline Japanese Learning App
## Product Requirements Document (PRD)

**Version:** 1.0  
**Date:** 2025-11-29  
**Status:** Initial Design

---

## 1. Executive Summary

**Product Name:** JLearn (Japanese Learning App)

**Vision:** An offline-first, AI-powered Japanese learning application that provides comprehensive language education without requiring constant internet connectivity.

**Target Audience:** 
- Self-learners of Japanese language
- JLPT exam candidates (N5-N1)
- Travelers to Japan
- Business professionals
- Students with limited or unreliable internet access

**Core Value Proposition:**
- 100% offline functionality after initial setup
- Rich, LLM-generated content pre-packaged in the app
- Modular content packs for flexible learning
- Smooth performance on mid-range Android devices (4-8GB RAM)
- Comprehensive learning modules (vocabulary, grammar, listening, reading, conversation)

---

## 2. Technical Constraints & Assumptions

### 2.1 Target Devices
- **Platform:** Android 7.0 (API 24) and above
- **Memory:** 4-8 GB RAM
- **Storage:** Minimum 500MB free space (base app ~100MB + content packs)
- **Processor:** Mid-range ARM or x86 processors
- **No GPU requirements:** No on-device LLM inference

### 2.2 Content Generation Strategy
- **Build-time Generation:** All content generated during development using powerful cloud/desktop LLMs
- **Content Format:** Structured JSON/SQLite + media assets (audio, images)
- **Content Updates:** Via downloadable content packs (not dynamic runtime generation)
- **Quality Control:** Human review of LLM-generated content before packaging

### 2.3 Offline-First Architecture
- **Network Required For:**
  - Initial app download from Play Store
  - Optional content pack downloads
  - Optional content pack updates
- **Network NOT Required For:**
  - All learning activities
  - Progress tracking
  - Content access
  - Quiz/test functionality

---

## 3. User Stories & Use Cases

### 3.1 Primary User Stories

**As a Japanese learner, I want to:**
1. Learn new vocabulary with audio pronunciation and example sentences
2. Study grammar concepts with clear explanations and exercises
3. Practice listening comprehension with native speaker audio
4. Read Japanese text with built-in dictionary lookup
5. Practice conversations through scripted dialogues
6. Track my learning progress and review weak areas
7. Download additional content packs for specific topics (JLPT, travel, business)
8. Study without internet connection (on trains, planes, rural areas)
9. Have spaced repetition remind me to review learned content
10. Earn achievements and maintain daily streaks for motivation

### 3.2 User Journey Map

```
[App Install] → [First Launch Tutorial] → [Base Content Setup]
     ↓
[Home Dashboard]
     ↓
┌────┴────┬────────┬────────┬────────┬────────┐
│ Learn   │ Review │ Listen │ Dialog │ Search │
│ New     │ Weak   │ &      │ Pract. │ &      │
│ Content │ Areas  │ Repeat │        │ Refer. │
└────┬────┴────────┴────────┴────────┴────────┘
     ↓
[Complete Activity] → [XP + Progress Update] → [Dashboard]
     ↓
[Download Content Pack] (optional) → [Continue Learning]
```

### 3.3 Core Use Cases

#### UC-1: Daily Learning Session
**Precondition:** User has completed onboarding  
**Main Flow:**
1. User opens app to Home Dashboard
2. System displays daily recommendations (5 new vocab, 3 reviews, 1 listening)
3. User selects "Learn new vocab"
4. System presents flashcards with audio and examples
5. User completes learning session
6. System updates progress, awards XP, updates streak
7. User returns to dashboard

#### UC-2: Download Content Pack
**Precondition:** User has WiFi/mobile data enabled  
**Main Flow:**
1. User navigates to Content Pack Store
2. System displays available packs with size and description
3. User selects "JLPT N5 Vocabulary Pack" (150MB)
4. System downloads and installs pack
5. System integrates new content into local database
6. User can now access JLPT N5 content offline

#### UC-3: Review Weak Areas
**Precondition:** User has learning history with mistakes  
**Main Flow:**
1. User selects "Review mistakes" from dashboard
2. System analyzes user's error patterns
3. System presents targeted review exercises
4. User completes review
5. System updates weakness analytics
6. User sees improvement metrics

---

## 4. Feature Requirements

### 4.1 Must-Have Features (MVP)

| Feature ID | Feature | Priority | Complexity |
|------------|---------|----------|------------|
| F-001 | Home Dashboard with progress summary | P0 | Medium |
| F-002 | Vocabulary learning module (flashcards) | P0 | High |
| F-003 | Spaced repetition algorithm | P0 | High |
| F-004 | Offline dictionary/search | P0 | Medium |
| F-005 | Local SQLite database for content | P0 | Medium |
| F-006 | Audio playback for pronunciations | P0 | Low |
| F-007 | Progress tracking & persistence | P0 | Medium |
| F-008 | Grammar module with explanations | P0 | High |
| F-009 | Quiz/test functionality | P0 | Medium |
| F-010 | User settings & preferences | P0 | Low |

### 4.2 Should-Have Features (Phase 2)

| Feature ID | Feature | Priority | Complexity |
|------------|---------|----------|------------|
| F-011 | Listening comprehension module | P1 | High |
| F-012 | Reading passages with lookup | P1 | High |
| F-013 | Dialog/conversation practice | P1 | High |
| F-014 | Content pack download system | P1 | High |
| F-015 | Gamification (XP, levels, badges) | P1 | Medium |
| F-016 | Daily streak tracking | P1 | Low |
| F-017 | Weakness analytics dashboard | P1 | Medium |
| F-018 | Bookmark/favorites system | P1 | Low |

### 4.3 Nice-to-Have Features (Future)

| Feature ID | Feature | Priority | Complexity |
|------------|---------|----------|------------|
| F-019 | Speech recording & playback | P2 | High |
| F-020 | Handwriting practice (kanji) | P2 | Very High |
| F-021 | Social features (leaderboards) | P2 | High |
| F-022 | Export progress to other devices | P2 | Medium |
| F-023 | Dark mode theme | P2 | Low |
| F-024 | Widget for quick review | P2 | Medium |
| F-025 | Notification reminders | P2 | Low |

---

## 5. Content Requirements

### 5.1 Base Content Pack (Shipped with App)

**Estimated Size:** 80-100MB

- **Vocabulary:** 1,000 common words (JLPT N5-N4 level)
  - Word in hiragana/katakana
  - Kanji form (if applicable)
  - Romaji
  - English translation
  - Part of speech
  - Audio pronunciation (MP3)
  - 2-3 example sentences per word
  
- **Grammar:** 50 essential grammar points (JLPT N5 level)
  - Grammar structure
  - Explanation in English
  - Usage rules
  - 3-5 example sentences
  - Common mistakes
  
- **Listening:** 20 audio snippets (30-60 seconds each)
  - Native speaker recordings
  - Transcripts
  - Comprehension questions
  
- **Reading:** 10 short passages (100-200 characters)
  - Beginner-level stories
  - Cultural notes
  - Vocabulary highlights

### 5.2 Optional Content Packs

| Pack Name | Size | Description | Content |
|-----------|------|-------------|---------|
| JLPT N5 Complete | 150MB | Full N5 curriculum | 1,500 vocab, 80 grammar, 50 listening, 30 reading |
| JLPT N4 Complete | 200MB | Full N4 curriculum | 2,000 vocab, 100 grammar, 60 listening, 40 reading |
| Travel Japanese | 80MB | Essential travel phrases | 500 vocab, 30 dialogs, 20 listening |
| Business Japanese | 120MB | Workplace communication | 800 vocab, 40 grammar, 25 dialogs |
| Kanji Master N5-N4 | 100MB | Kanji learning | 300 kanji with stroke order, mnemonics |

### 5.3 Content Schema (Database Structure)

**See TECHNICAL_DESIGN.md for detailed schema**

---

## 6. User Experience Requirements

### 6.1 Performance Targets

- **App Launch:** < 2 seconds (cold start)
- **Screen Navigation:** < 300ms
- **Content Load:** < 500ms
- **Audio Playback Start:** < 200ms
- **Search Results:** < 1 second
- **Quiz Loading:** < 500ms
- **Content Pack Download:** Progress indicator with pause/resume

### 6.2 Usability Requirements

- **Accessibility:** Support for screen readers, text scaling, color contrast
- **Localization:** English UI (future: add Japanese UI)
- **Intuitive Navigation:** Maximum 3 taps to reach any feature
- **Error Handling:** Clear error messages with recovery suggestions
- **Onboarding:** Interactive tutorial on first launch (< 2 minutes)

### 6.3 Visual Design Principles

- **Material Design 3:** Follow Android design guidelines
- **Consistent Typography:** Noto Sans for English, Noto Sans JP for Japanese
- **Color Scheme:** 
  - Primary: Blue (#2196F3) - Trust, learning
  - Secondary: Orange (#FF9800) - Energy, motivation
  - Accent: Green (#4CAF50) - Success, progress
- **Iconography:** Material Icons + custom Japanese-themed icons
- **Spacing:** 8dp grid system

---

## 7. Success Metrics (KPIs)

### 7.1 Engagement Metrics
- **Daily Active Users (DAU)**
- **Weekly Active Users (WAU)**
- **Average session duration:** Target > 10 minutes
- **Sessions per user per week:** Target > 4
- **7-day retention rate:** Target > 40%
- **30-day retention rate:** Target > 20%

### 7.2 Learning Metrics
- **Words learned per user:** Target > 100 in first month
- **Lessons completed per user:** Target > 20 in first month
- **Quiz pass rate:** Target > 70%
- **Review completion rate:** Target > 60%
- **Daily streak duration:** Average > 5 days

### 7.3 Technical Metrics
- **Crash-free rate:** > 99.5%
- **App size:** < 100MB (base app)
- **Average memory usage:** < 200MB
- **Battery consumption:** < 5% per hour of active use

### 7.4 Content Metrics
- **Content pack download rate:** > 30% of users download at least 1 pack
- **Most popular content packs**
- **Content completion rate by pack**

---

## 8. Risks & Mitigations

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Content quality issues from LLM | Medium | High | Human review, user feedback, iterative updates |
| Storage limitations on devices | Medium | Medium | Aggressive content compression, optional packs, allow deletion |
| Audio file size bloat | High | Medium | Use compressed formats (MP3 128kbps), on-demand download |
| Spaced repetition algorithm complexity | Medium | Medium | Use proven open-source algorithms (SM-2, FSRS) |
| User boredom with static content | Medium | High | Gamification, variety in exercises, regular content updates |
| Compatibility issues across Android versions | Low | High | Thorough testing on multiple devices/versions |
| Difficulty generating high-quality Japanese content | Medium | High | Partner with native speakers, use advanced LLMs (GPT-4) |

---

## 9. Dependencies & Assumptions

### 9.1 External Dependencies
- **LLM Content Generation:** GPT-4 or Claude for content creation (build-time)
- **TTS Service:** Google Cloud TTS or ElevenLabs for audio generation
- **Content Hosting:** GitHub Releases or CDN for content pack distribution
- **Analytics:** Firebase Analytics (optional, requires network)

### 9.2 Assumptions
- Users have at least 500MB free storage
- Users will download base app over WiFi (due to size)
- Most users have Android 7.0 or higher (covers 95%+ of market)
- Users are motivated self-learners (not forced learning)
- LLM-generated content with human review is acceptable quality

---

## 10. Timeline & Milestones

### Phase 1: MVP Development (3-4 months)
- **Month 1:** Core architecture, database, vocabulary module
- **Month 2:** Grammar module, quiz system, spaced repetition
- **Month 3:** UI polish, testing, content generation
- **Month 4:** Beta testing, bug fixes, Play Store submission

### Phase 2: Enhanced Features (2-3 months)
- **Month 5:** Listening module, reading module, dialog practice
- **Month 6:** Content pack system, gamification, analytics
- **Month 7:** Polish, performance optimization, content expansion

### Phase 3: Growth & Optimization (Ongoing)
- New content packs (monthly)
- User feedback implementation
- Performance improvements
- Marketing & user acquisition

---

## 11. Open Questions

1. **Monetization Strategy:** Free with ads? Freemium with paid content packs? One-time purchase?
2. **Content Update Frequency:** How often to release new content packs?
3. **Native Speaker Validation:** Budget and process for content review?
4. **Analytics:** Which metrics require network? Privacy implications?
5. **Social Features:** Should we add community features in future?
6. **Multi-language UI:** When to add Japanese UI option?
7. **iOS Version:** Timeline and priority for iOS port?

---

## 12. Stakeholders & Approvals

| Role | Name | Responsibility | Approval |
|------|------|----------------|----------|
| Product Owner | TBD | Overall product vision | ☐ |
| Tech Lead | TBD | Technical feasibility | ☐ |
| UX Designer | TBD | User experience design | ☐ |
| Content Lead | TBD | Japanese content quality | ☐ |
| QA Lead | TBD | Testing strategy | ☐ |

---

**Document Status:** Draft - Ready for Review  
**Next Steps:** Create Technical Design Document and Implementation Plan
