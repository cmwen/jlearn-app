# User Flows - JLearn App

**Date**: December 4, 2025  
**Version**: 1.0  
**Status**: Draft - Pending Product Owner Review

## Overview

This document defines the primary user flows for the JLearn app. Each flow includes:
- User goal and context
- Step-by-step actions
- Decision points
- Success criteria
- Error handling

## Primary User Personas

### Persona 1: Active Learner (Alex)
- **Age**: 25-35
- **Goal**: Improve skills for career advancement
- **Tech Proficiency**: High
- **Usage Pattern**: Daily, 20-30 minutes
- **Motivation**: Achievement, progress tracking

### Persona 2: Casual Learner (Sam)
- **Age**: 16-24
- **Goal**: Learn new topics out of curiosity
- **Tech Proficiency**: Medium
- **Usage Pattern**: 2-3 times per week, 10-15 minutes
- **Motivation**: Entertainment, gamification

### Persona 3: Returning User (Riley)
- **Age**: 35-50
- **Goal**: Continue learning after break
- **Tech Proficiency**: Medium
- **Usage Pattern**: Irregular, after long gaps
- **Motivation**: Habit formation, gentle reminders

---

## Flow 1: First-Time User Onboarding

### Goal
Help new users understand the app value and get started quickly.

### Entry Point
App launch (fresh install)

### Flow Steps

```
1. Splash Screen
   ↓
2. Welcome Screen
   • Hero image/animation
   • Value proposition
   • "Get Started" CTA
   • "Sign In" link
   ↓
3. Sign Up / Sign In
   • Email/password
   • Social login options (Google, Apple)
   • "Continue as Guest" option
   ↓
4. Onboarding Tutorial (3 screens)
   
   Screen 1: "Learn at Your Pace"
   • Visual: Interactive lessons
   • Message: "Choose from thousands of lessons"
   • Progress indicator: 1/3
   
   Screen 2: "Practice & Improve"
   • Visual: Quiz interface
   • Message: "Test your knowledge with fun exercises"
   • Progress indicator: 2/3
   
   Screen 3: "Track Progress"
   • Visual: Progress dashboard
   • Message: "See your growth and celebrate achievements"
   • Progress indicator: 3/3
   
   • "Skip" option on all screens
   • "Next" button
   • "Get Started" on final screen
   ↓
5. Interest Selection (Optional)
   • Grid of topic categories
   • Multi-select
   • Minimum 1, maximum 5
   • "Continue" button
   ↓
6. Skill Assessment (Optional, Skippable)
   • "Quick 5-question assessment to personalize your experience"
   • Progress: X/5
   • "Skip Assessment" option
   ↓
7. Home Dashboard
   • "Welcome [Name]!" greeting
   • Recommended lessons
   • "Start Learning" FAB
   • Bottom navigation visible
```

### Decision Points

| Point | Question | Outcomes |
|-------|----------|----------|
| Screen 2 | Continue as guest? | Yes → Limited features, No → Full access |
| Screen 4 | Skip tutorial? | Yes → Jump to Screen 5, No → Continue |
| Screen 5 | Select interests? | Skip → Generic recommendations, Select → Personalized |
| Screen 6 | Take assessment? | Skip → Beginner level, Complete → Personalized level |

### Success Criteria
- User reaches home dashboard
- User understands core app value
- User has personalized experience (if chosen)
- Time to completion: < 2 minutes

### Error Handling
- **Network error during sign-up**: Show offline message, allow guest mode
- **No interests selected**: Proceed with generic recommendations
- **Assessment incomplete**: Save partial progress, allow resume later

---

## Flow 2: Discover and Start Lesson

### Goal
User finds and begins a relevant lesson.

### Entry Point
Home Dashboard or Learn tab

### Flow Steps

```
1. Home Dashboard / Learn Tab
   ↓
2. Browse Lessons
   • Featured lessons (carousel)
   • Categories (chips/filters)
   • Recommended for you
   • Continue learning (if in progress)
   • Search bar
   ↓
3. Apply Filters (Optional)
   • Difficulty level
   • Topic/category
   • Duration
   • Format (video, text, interactive)
   ↓
4. View Lesson Card
   • Lesson title
   • Brief description
   • Duration estimate
   • Difficulty badge
   • Progress indicator (if started)
   • Rating (optional)
   • "Start" or "Continue" button
   ↓
5. Tap Lesson Card
   ↓
6. Lesson Detail Screen
   • Hero image/thumbnail
   • Full description
   • Learning objectives (bullet list)
   • Prerequisites (if any)
   • What you'll learn
   • Lesson outline (expandable)
   • Reviews/ratings (optional)
   • "Start Lesson" FAB
   • "Add to Favorites" icon
   • "Share" icon
   ↓
7. Start Lesson
   ↓
8. Lesson Content Screen
   • Progress bar (top)
   • Content area (text, image, video)
   • "Previous" button
   • "Next" button
   • "Exit" (X) icon
   • Page indicator (e.g., "5/12")
   ↓
9. Navigate Through Lesson
   • Swipe left/right (optional)
   • Button navigation
   • Auto-save progress
   ↓
10. Complete Lesson
    ↓
11. Completion Screen
    • "Congratulations!" message
    • XP/points earned
    • Achievement unlocked (if applicable)
    • "Practice Now" button
    • "Next Lesson" button
    • "Back to Dashboard" button
```

### Decision Points

| Point | Question | Outcomes |
|-------|----------|----------|
| Screen 3 | Apply filters? | Yes → Filtered results, No → All lessons |
| Screen 6 | Preview or start? | Preview → Detail screen, Start → Jump to Screen 8 |
| Screen 8 | Exit mid-lesson? | Confirm → Save progress, Cancel → Stay |

### Success Criteria
- User finds relevant lesson quickly (< 30 seconds)
- User completes or makes progress in lesson
- Progress is saved automatically
- User feels accomplished

### Error Handling
- **Lesson fails to load**: Show error, "Try Again" button, suggest similar lessons
- **Progress save fails**: Queue for later sync, show offline indicator
- **User exits mid-lesson**: Show "Save and exit?" dialog

---

## Flow 3: Complete Practice Exercise

### Goal
User reinforces learning through practice questions/exercises.

### Entry Point
After lesson completion or Practice tab

### Flow Steps

```
1. Entry Point
   • After lesson completion, OR
   • Practice tab → Select topic
   ↓
2. Exercise Selection
   • Topic-based exercises
   • Mixed review
   • Weak areas focus
   • Daily challenge
   ↓
3. Exercise Preview
   • Exercise type (multiple choice, fill-in-blank, etc.)
   • Number of questions
   • Estimated time
   • "Start Exercise" button
   ↓
4. Exercise Interface
   • Question counter (1/10)
   • Timer (if timed, optional)
   • Question text
   • Answer options/input
   • "Submit" button
   • "Hint" button (optional, costs points)
   • "Skip" button (optional)
   ↓
5. Submit Answer
   ↓
6. Immediate Feedback
   • Correct: ✓ Green, encouraging message
   • Incorrect: ✗ Red, show correct answer, explanation
   • Points/XP earned (for correct)
   • "Next Question" button
   ↓
7. Repeat Steps 4-6
   ↓
8. Exercise Complete
   ↓
9. Summary Screen
   • Score: X/10 correct
   • Time taken
   • Accuracy percentage
   • XP earned
   • Areas to improve
   • "Review Incorrect" button
   • "Practice Again" button
   • "Continue Learning" button
   ↓
10. Update Progress Dashboard
```

### Decision Points

| Point | Question | Outcomes |
|-------|----------|----------|
| Screen 4 | Use hint? | Yes → Show hint, deduct points, No → Continue |
| Screen 4 | Skip question? | Yes → Mark as skipped, move to next, No → Continue |
| Screen 9 | Review incorrect? | Yes → Show detailed review, No → Return to dashboard |

### Success Criteria
- User completes exercise
- User receives immediate feedback
- User understands mistakes
- User feels progress

### Error Handling
- **Connection lost during exercise**: Save answers locally, sync when back online
- **Exercise crashes**: Restore to last answered question
- **Timer expires**: Auto-submit current answers, show results

---

## Flow 4: Check Progress

### Goal
User views learning progress, achievements, and statistics.

### Entry Point
Progress tab or achievement notification

### Flow Steps

```
1. Progress Tab
   ↓
2. Progress Dashboard
   • Overall progress (circular chart)
   • Current streak (days)
   • Total XP/points
   • Level/rank
   • "This Week" summary
   ↓
3. Detailed Views (Tabs/Sections)
   
   Tab 1: Overview
   • Daily activity calendar (heatmap)
   • Weekly goal progress
   • Time spent learning
   • Lessons completed
   
   Tab 2: Achievements
   • Unlocked badges (grid)
   • Locked badges (grayed out with unlock requirements)
   • Recent achievements
   • Progress toward next achievement
   
   Tab 3: Statistics
   • Total lessons completed
   • Total practice questions
   • Average accuracy
   • Favorite topics
   • Learning pace (lessons per week)
   • Streak history
   
   Tab 4: History
   • Recently completed lessons (list)
   • Date completed
   • Score/performance
   • "Review" button per item
   ↓
4. Tap Achievement Badge
   ↓
5. Achievement Detail
   • Badge image (large)
   • Badge name and description
   • Date earned
   • Share button
   • Related achievements
   ↓
6. Share Achievement (Optional)
   • Native share sheet
   • Social media options
   • "Copy Link" option
```

### Decision Points

| Point | Question | Outcomes |
|-------|----------|----------|
| Screen 5 | Share achievement? | Yes → Open share sheet, No → Return |
| Screen 3 | Dive into detailed stats? | Yes → View specific metric, No → Stay on overview |

### Success Criteria
- User sees clear progress visualization
- User feels motivated to continue
- User understands achievements
- User can share accomplishments

### Error Handling
- **Stats fail to load**: Show cached data, "Last updated X time ago"
- **Sync pending**: Show "Syncing..." indicator
- **Share fails**: Show error toast, "Try again"

---

## Flow 5: Update Settings

### Goal
User customizes app experience and manages account.

### Entry Point
Profile tab → Settings icon

### Flow Steps

```
1. Profile Tab
   ↓
2. Settings Screen
   
   Account Section:
   • Profile photo
   • Name
   • Email
   • Change password
   • Linked accounts
   
   Preferences Section:
   • Language
   • Notifications
   • Learning goals (daily target)
   • Difficulty preference
   • Content preferences
   
   Display Section:
   • Theme (Light/Dark/System)
   • Text size
   • Reduce animations
   
   Data & Privacy Section:
   • Download content for offline
   • Clear cache
   • Data usage
   • Privacy policy
   • Terms of service
   
   About Section:
   • App version
   • Rate app
   • Send feedback
   • Help & support
   • Log out
   ↓
3. Edit Specific Setting
   ↓
4. Confirmation/Save
   • Auto-save for most settings
   • Confirmation dialog for critical changes (logout, delete)
   ↓
5. Return to Settings / Profile
```

### Decision Points

| Point | Question | Outcomes |
|-------|----------|----------|
| Screen 3 | Save changes? | Yes → Apply immediately, No → Discard |
| Logout | Confirm logout? | Yes → Sign out, clear local data, No → Cancel |
| Delete account | Confirm deletion? | Yes → Delete account, No → Cancel |

### Success Criteria
- Settings are intuitive and organized
- Changes apply immediately (or with clear feedback)
- User can easily revert changes
- Critical actions require confirmation

### Error Handling
- **Save fails**: Show error, keep form filled, "Retry" button
- **Network required**: Show "Connect to internet to save"
- **Invalid input**: Inline validation with helpful message

---

## Flow 6: Recover from Interruption

### Goal
User seamlessly resumes after interruption (call, notification, app closed).

### Entry Point
Any screen → Interruption → Return to app

### Flow Steps

```
1. User is on [Any Screen]
   ↓
2. Interruption Occurs
   • Phone call
   • Notification
   • App sent to background
   • Device locked
   • Low battery/crash
   ↓
3. App Paused
   • Auto-save current state
   • Pause timers (if any)
   • Save form inputs
   ↓
4. User Returns to App
   ↓
5. Restore Previous State
   
   If on Lesson:
   • Resume at exact page
   • Show "Welcome back!" toast
   • Progress saved
   
   If on Exercise:
   • Resume at current question
   • Pause timer (resume on user action)
   • Show "Continue where you left off?"
   
   If on Form/Input:
   • Restore form data
   • Keep unsaved changes
   
   Other Screens:
   • Restore to exact screen
   • Refresh content if stale (> 5 min)
   ↓
6. User Continues
```

### Decision Points

| Point | Question | Outcomes |
|-------|----------|----------|
| Screen 5 | Resume or restart? | Resume → Restore state, Restart → Go to beginning |
| Screen 5 | Content is stale? | Yes → Refresh data, No → Show cached |

### Success Criteria
- User doesn't lose progress
- Resume is seamless (< 1 second)
- User feels app is reliable
- No data loss

### Error Handling
- **State can't be restored**: Return to safe screen (dashboard), show apologetic message
- **Data corrupted**: Clear corrupted data, log error, show recovery options

---

## Flow 7: Offline Experience

### Goal
User can continue learning without internet connection.

### Entry Point
User opens app without internet OR loses connection during use

### Flow Steps

```
1. App Detects No Connection
   ↓
2. Show Offline Indicator
   • Subtle banner at top: "You're offline"
   • Or icon in app bar
   ↓
3. Available Offline Actions
   
   Can Access:
   • Previously cached lessons
   • Downloaded content
   • Completed progress (cached)
   • Settings (most)
   
   Cannot Access:
   • New content (not cached)
   • Sync progress to server
   • Social features
   • Search (server-based)
   ↓
4. User Attempts Online-Only Action
   ↓
5. Show Friendly Message
   • "This requires internet connection"
   • "Connect to wifi to access"
   • "Your progress will sync when you're back online"
   • "View downloaded content" CTA
   ↓
6. User Completes Offline Lessons
   • Progress saved locally
   • "Will sync when online" indicator
   ↓
7. Connection Restored
   ↓
8. Auto-Sync
   • "Syncing..." indicator
   • Upload local progress
   • Download new content (if auto-download enabled)
   • "All caught up!" message
   ↓
9. Remove Offline Indicator
```

### Decision Points

| Point | Question | Outcomes |
|-------|----------|----------|
| Screen 3 | View downloaded content? | Yes → Show offline lessons, No → Stay on current screen |
| Screen 7 | Auto-sync? | Yes → Sync in background, No → Wait for manual trigger |

### Success Criteria
- User is aware of offline status
- User can continue learning with cached content
- Progress doesn't get lost
- Seamless sync when back online

### Error Handling
- **Sync fails**: Retry automatically (with exponential backoff), show "Sync pending" indicator
- **Conflict detected**: Use last-write-wins or prompt user
- **Storage full**: Prompt to clear old cached content

---

## User Flow Metrics

### Key Performance Indicators (KPIs)

| Flow | Metric | Target | Measurement |
|------|--------|--------|-------------|
| Onboarding | Time to dashboard | < 2 min | Analytics |
| Onboarding | Completion rate | > 80% | Analytics |
| Start Lesson | Time to first lesson | < 30 sec | Analytics |
| Start Lesson | Lesson completion | > 60% | Analytics |
| Practice | Exercise completion | > 70% | Analytics |
| Practice | Average accuracy | > 65% | Analytics |
| Progress | Page views per week | > 2 | Analytics |
| Settings | Changes per month | > 1 | Analytics |
| Offline | Offline usage rate | Track | Analytics |

### User Satisfaction Metrics

- Task completion rate: > 90%
- Error rate: < 5%
- Navigation efficiency: < 3 taps to any feature
- Return rate: > 40% DAU/MAU

---

## Accessibility Considerations

### For All Flows

**Screen Reader Support**:
- All steps announced clearly
- Button actions described
- Progress updates spoken
- Errors explained with remediation

**Keyboard Navigation**:
- Logical tab order
- Visible focus indicators
- Keyboard shortcuts for common actions
- No keyboard traps

**Visual Accessibility**:
- High contrast mode support
- Text scaling (up to 200%)
- No color-only indicators
- Clear visual hierarchy

**Cognitive Accessibility**:
- Clear, simple language
- One task at a time
- Undo capabilities
- Progress saving
- No time pressure (or adjustable)

---

## Future Flow Enhancements

### Planned for Future Versions

1. **Social Learning Flow**
   - Connect with friends
   - Share progress
   - Join study groups
   - Leaderboards

2. **Adaptive Learning Flow**
   - AI-powered recommendations
   - Dynamic difficulty adjustment
   - Personalized learning paths

3. **Gamification Flow**
   - Daily challenges
   - Missions/quests
   - Competitive modes
   - Special events

4. **Content Creation Flow** (if applicable)
   - User-generated content
   - Community lessons
   - Review and rating

---

## Change Log

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-12-04 | 1.0 | Initial user flows created | UX Designer Agent |

---

## Notes

- All flows assume Material Design 3 patterns
- Flows should be validated with user testing
- Timing estimates are preliminary and need validation
- Success criteria should be refined based on analytics
- Accessibility must be tested with actual assistive technologies

**Next Steps**:
1. Review with product owner and stakeholders
2. Create detailed wireframes for each screen
3. Build interactive prototype
4. Conduct usability testing
5. Iterate based on feedback
