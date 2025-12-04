# Wireframes - JLearn App

**Date**: December 4, 2025  
**Version**: 1.0  
**Status**: Draft - Conceptual Wireframes

## Overview

This document provides text-based wireframes for key screens in the JLearn app. Each wireframe includes:
- Screen layout description
- Component placement
- Interaction notes
- Responsive considerations
- Accessibility annotations

**Note**: These are conceptual wireframes described in text format. They should be translated into visual mockups using design tools like Figma.

---

## Screen Layout Conventions

### Phone Layout (< 600dp)
```
┌─────────────────────┐
│     Status Bar      │
├─────────────────────┤
│      App Bar        │
├─────────────────────┤
│                     │
│                     │
│   Main Content      │
│   (Scrollable)      │
│                     │
│                     │
├─────────────────────┤
│  Bottom Nav Bar     │
└─────────────────────┘
```

### Tablet Layout (600-1200dp)
```
┌────────────────────────────┐
│       Status Bar           │
├────────────────────────────┤
│        App Bar             │
├───┬────────────────────────┤
│ N │                        │
│ a │                        │
│ v │    Main Content        │
│   │    (2-column grid)     │
│ R │                        │
│ a │                        │
│ i │                        │
│ l │                        │
└───┴────────────────────────┘
```

---

## 1. Splash Screen

**Duration**: 1-2 seconds while app initializes

```
┌─────────────────────┐
│                     │
│                     │
│                     │
│    [APP LOGO]       │
│                     │
│     JLearn          │
│                     │
│                     │
│   [Progress Dot]    │
│                     │
│                     │
└─────────────────────┘
```

**Components**:
- App logo (center, large)
- App name below logo
- Loading indicator (minimal, bottom)
- Brand color background

**Accessibility**:
- Logo has semantic label: "JLearn app"
- Loading state announced to screen reader

---

## 2. Welcome Screen

**First-time users only**

```
┌─────────────────────┐
│                     │
│  [Hero Image/       │
│   Animation]        │
│                     │
│  Learn Anything,    │
│   Anytime           │
│                     │
│  Thousands of       │
│  lessons at your    │
│  fingertips         │
│                     │
│  [Get Started Btn]  │
│                     │
│  [Sign In] link     │
│                     │
└─────────────────────┘
```

**Components**:
- Hero image/animation (top 40%)
- Headline (Display Medium)
- Subheadline (Body Large)
- Primary CTA button: "Get Started"
- Secondary link: "Sign In"

**Interactions**:
- "Get Started" → Sign up flow
- "Sign In" → Sign in screen

**Accessibility**:
- Hero image: Decorative, excluded from semantics
- Clear button labels
- Focus on "Get Started" button

---

## 3. Onboarding Screens (3 screens)

### Screen 1 of 3

```
┌─────────────────────┐
│ [Skip]         [1/3]│
├─────────────────────┤
│                     │
│  [Illustration:     │
│   Interactive       │
│   Lessons]          │
│                     │
│  Learn at Your Pace │
│                     │
│  Choose from        │
│  thousands of       │
│  lessons in         │
│  various topics     │
│                     │
│  ●○○                │ Progress dots
│                     │
│      [Next]         │
└─────────────────────┘
```

**Components**:
- Skip button (top right)
- Progress indicator (1/3, top right)
- Illustration (40% of screen)
- Title (Headline Medium)
- Description (Body Large)
- Progress dots (center, bottom third)
- Next button (bottom)

**Interactions**:
- "Skip" → Go to home dashboard
- "Next" → Screen 2
- Swipe left → Screen 2

### Screen 2 of 3

```
┌─────────────────────┐
│ [Skip]         [2/3]│
├─────────────────────┤
│                     │
│  [Illustration:     │
│   Quiz/Practice]    │
│                     │
│  Practice & Improve │
│                     │
│  Test your          │
│  knowledge with     │
│  fun exercises      │
│  and quizzes        │
│                     │
│  ○●○                │
│                     │
│      [Next]         │
└─────────────────────┘
```

### Screen 3 of 3

```
┌─────────────────────┐
│ [Skip]         [3/3]│
├─────────────────────┤
│                     │
│  [Illustration:     │
│   Progress Chart]   │
│                     │
│  Track Progress     │
│                     │
│  See your growth    │
│  and celebrate      │
│  achievements       │
│                     │
│  ○○●                │
│                     │
│  [Get Started]      │
└─────────────────────┘
```

**Final screen changes**:
- Button text: "Get Started" (instead of "Next")
- Action → Interest selection or Home

---

## 4. Home Dashboard

**Main screen after login**

```
┌─────────────────────┐
│ [≡] JLearn  [🔔][⚙]│ App bar
├─────────────────────┤
│ Welcome back, Alex! │
│                     │
│ ┌─────────────────┐ │ Progress card
│ │ 🔥 5 day streak │ │
│ │ 75% to next lvl │ │
│ │ [Progress Bar]  │ │
│ └─────────────────┘ │
│                     │
│ Continue Learning   │
│ ┌───────┐ ┌───────┐ │ Horizontal scroll
│ │[Img]  │ │[Img]  │ │ lesson cards
│ │Title  │ │Title  │ │
│ │▓▓▓░░  │ │▓▓░░░  │ │ Progress bars
│ └───────┘ └───────┘ │
│                     │
│ Recommended for You │
│ ┌─────────────────┐ │
│ │ [Icon] Lesson 1 │ │ List items
│ │ 30 min · Medium │ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ [Icon] Lesson 2 │ │
│ │ 45 min · Hard   │ │
│ └─────────────────┘ │
│                     │
├─────────────────────┤
│ [🏠][📚][✏][📊][👤]│ Bottom nav
└─────────────────────┘
     ↑
   [➕] FAB "Start Learning"
```

**Components**:

**App Bar**:
- Menu icon (left)
- Title: "JLearn"
- Notification icon (right)
- Settings icon (right)

**Progress Card**:
- Streak counter (fire icon + number)
- Level progress (percentage + bar)
- Background color: Primary Container

**Continue Learning Section**:
- Section header: "Continue Learning"
- Horizontal scrolling cards
- Each card: Thumbnail, title, progress bar
- Card action: Resume lesson

**Recommended Section**:
- Section header: "Recommended for You"
- Vertical list of lesson cards
- Each card: Icon, title, duration, difficulty
- Card action: Open lesson details

**FAB**:
- Icon: Add/Play
- Label: "Start Learning"
- Action: Browse lessons or start recommended

**Bottom Navigation**:
- Home (selected)
- Learn
- Practice
- Progress
- Profile

**Interactions**:
- Continue card tap → Resume lesson
- Recommended card tap → Lesson details
- FAB tap → Browse lessons screen
- Bottom nav tap → Navigate to section

**Accessibility**:
- Greeting announced
- Progress card has semantic label: "Your progress: 5 day streak, 75% to next level"
- Each lesson card has complete description
- FAB has label: "Start new lesson"

---

## 5. Learn Screen (Browse Lessons)

```
┌─────────────────────┐
│ [←] Learn    [🔍]   │ App bar
├─────────────────────┤
│ ┌─────────────────┐ │ Search bar
│ │ 🔍 Search...    │ │
│ └─────────────────┘ │
│                     │
│ [All][Web][Mobile]  │ Category chips
│ [Design][Backend]   │ (scrollable)
│                     │
│ Featured            │
│ ┌─────────────────┐ │ Featured carousel
│ │ [Large Image]   │ │ (swipeable)
│ │ Flutter Basics  │ │
│ └─────────────────┘ │
│ ●○○○                │ Indicators
│                     │
│ Popular Lessons     │
│ ┌────────┐┌────────┐│ Grid layout
│ │[Image] ││[Image] ││ 2 columns
│ │Title   ││Title   ││
│ │⭐4.8   ││⭐4.6   ││ Rating
│ │30 min  ││45 min  ││ Duration
│ └────────┘└────────┘│
│ ┌────────┐┌────────┐│
│ │[Image] ││[Image] ││
│ │Title   ││Title   ││
│ │⭐4.9   ││⭐4.7   ││
│ └────────┘└────────┘│
│                     │
├─────────────────────┤
│ [🏠][📚][✏][📊][👤]│
└─────────────────────┘
```

**Components**:

**App Bar**:
- Back button (if navigated from other screen)
- Title: "Learn"
- Search icon

**Search Bar**:
- Hint text: "Search lessons..."
- Icon: Search (left)
- Filled style

**Category Chips**:
- Horizontal scrolling
- Single select
- Default: "All"
- Options: Web, Mobile, Design, Backend, etc.

**Featured Section**:
- Large image cards
- Horizontal scrolling/swipeable
- Progress indicators (dots)
- Title overlay on image

**Grid Section**:
- Section headers (Popular, New, etc.)
- 2-column grid on phone
- 3-4 columns on tablet
- Each card: Image, title, rating, duration
- Card elevation: 1

**Interactions**:
- Search icon → Focus search field
- Category chip → Filter lessons
- Featured card swipe → View next featured
- Lesson card tap → Lesson details

**Tablet Layout** (600dp+):
```
┌────────────────────────────┐
│ [≡] Learn        [🔍][Filter]│
├───┬────────────────────────┤
│ C │ [All][Web][Mobile]...  │ Chips
│ a │                        │
│ t │ Featured (Larger)      │
│ e │ ┌────────────────────┐ │
│ g │ │ [Large Hero Image] │ │
│ o │ └────────────────────┘ │
│ r │                        │
│ i │ Popular Lessons        │
│ e │ ┌───┐┌───┐┌───┐┌───┐  │ 4 columns
│ s │ │   ││   ││   ││   │  │
│   │ └───┘└───┘└───┘└───┘  │
│ L │ ┌───┐┌───┐┌───┐┌───┐  │
│ i │ │   ││   ││   ││   │  │
│ s │ └───┘└───┘└───┘└───┘  │
│ t │                        │
└───┴────────────────────────┘
```

---

## 6. Lesson Detail Screen

```
┌─────────────────────┐
│ [←]          [♡][⋮] │ App bar
├─────────────────────┤
│ [Hero Image/        │
│  Thumbnail]         │
│                     │
│ Introduction to     │ Title (Headline Large)
│ Flutter             │
│                     │
│ [Beginner] 30 min   │ Badges
│                     │
│ ⭐ 4.8 (1.2k)       │ Rating
│                     │
│ Master the basics   │ Description
│ of Flutter and      │ (Body Large)
│ create beautiful    │
│ cross-platform apps │
│                     │
│ What You'll Learn   │ Section
│ ✓ Flutter widgets   │ Checklist
│ ✓ State management  │
│ ✓ Navigation        │
│ ✓ Build your app    │
│                     │
│ Lesson Outline ▼    │ Expandable section
│                     │
│ Prerequisites ▼     │ Expandable section
│                     │
│ Reviews (1.2k) ▼    │ Expandable section
│                     │
├─────────────────────┤
│   [Start Lesson]    │ Fixed bottom
└─────────────────────┘
```

**Components**:

**App Bar**:
- Back button (left)
- Favorite icon (right, toggle)
- More options menu (right)

**Hero Section**:
- Large image/thumbnail (16:9 ratio)
- Optional: Play icon overlay if video

**Title Section**:
- Lesson title (Headline Large)
- Difficulty badge + Duration chip
- Star rating + review count

**Description**:
- 2-3 paragraph summary
- Body Large text

**What You'll Learn**:
- Bullet list with checkmarks
- 4-6 key learning objectives
- Body Medium text

**Expandable Sections**:
- Lesson Outline: List of modules/chapters
- Prerequisites: Required knowledge
- Reviews: User ratings and comments

**Fixed Bottom Button**:
- Full-width primary button
- Text: "Start Lesson" or "Continue" (if in progress)
- Shows progress percentage if started

**Interactions**:
- Back → Return to browse
- Favorite → Toggle saved status
- More menu → Share, Report, etc.
- Start button → Open lesson content
- Expandable sections → Toggle expand/collapse

**Accessibility**:
- Hero image has descriptive alt text
- All sections have semantic headers
- Button has clear action label
- Rating announced as "Rated 4.8 stars out of 5, 1,200 reviews"

---

## 7. Lesson Content Screen

**Full-screen immersive view**

```
┌─────────────────────┐
│ [×]       [5/12] [⋮]│ Minimal header
├─────────────────────┤
│ ▓▓▓▓▓▓▓░░░░░░░░░░   │ Progress bar
├─────────────────────┤
│                     │
│                     │
│   [Content Area]    │
│                     │
│   • Text            │
│   • Images          │
│   • Video           │
│   • Interactive     │
│     elements        │
│                     │
│                     │
│                     │
│                     │
├─────────────────────┤
│ [← Previous] [Next →]│ Navigation
└─────────────────────┘
```

**Components**:

**Minimal Header**:
- Close button (left)
- Page indicator: "5/12"
- More options (right)

**Progress Bar**:
- Linear indicator
- Thin, prominent color
- Shows overall lesson progress

**Content Area**:
- Full scrollable area
- Dynamic content based on lesson type:
  - Text content (Body Large)
  - Images (full-width or inline)
  - Videos (16:9 with controls)
  - Interactive widgets (quizzes, drag-drop)
- Padding: 16dp horizontal

**Navigation**:
- Previous button (left)
- Next button (right)
- Disabled state if at start/end

**Interactions**:
- Close (×) → Confirm exit dialog
- Swipe left/right → Navigate pages
- Previous/Next buttons → Navigate
- More menu → Settings, help
- Content interactions → Based on content type

**Variations**:

### Video Content
```
┌─────────────────────┐
│ [×]       [5/12] [⋮]│
├─────────────────────┤
│ ▓▓▓▓▓▓▓░░░░░░░░░░   │
├─────────────────────┤
│ ┌─────────────────┐ │
│ │                 │ │ Video player
│ │   ▶ [Video]    │ │ 16:9 ratio
│ │                 │ │
│ └─────────────────┘ │
│ [◀◀] [▶/⏸] [▶▶]   │ Controls
│ [═════●══════]     │ Scrubber
│ 02:34 / 05:00      │ Time
│ [CC] [Settings]    │ Options
│                     │
│ Video Transcript ▼  │ Expandable
│                     │
├─────────────────────┤
│ [← Previous] [Next →]│
└─────────────────────┘
```

### Interactive Content
```
┌─────────────────────┐
│ [×]       [8/12] [⋮]│
├─────────────────────┤
│ ▓▓▓▓▓▓▓▓▓▓▓░░░░░░   │
├─────────────────────┤
│ What is a Widget?   │
│                     │
│ ○ A visual element  │ Multiple choice
│ ○ A layout tool     │ question
│ ○ Both of the above │
│ ○ None of the above │
│                     │
│     [Submit]        │ Action button
│                     │
├─────────────────────┤
│ [← Previous] [Next →]│
└─────────────────────┘
```

---

## 8. Practice/Exercise Screen

```
┌─────────────────────┐
│ [×] Quiz  [⏱ 01:23]│ Header with timer
├─────────────────────┤
│ Question 3 of 10    │ Progress indicator
│ ▓▓▓░░░░░░░░░░░░░░   │ Progress bar
├─────────────────────┤
│                     │
│ Which widget is     │ Question
│ used for layout in  │ (Title Large)
│ Flutter?            │
│                     │
│ ┌─────────────────┐ │
│ │ A) Container    │ │ Option A
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ B) Column       │ │ Option B
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ C) Both         │ │ Option C
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ D) Neither      │ │ Option D
│ └─────────────────┘ │
│                     │
│   [Need a hint?]    │ Help link
│                     │
│                     │
│     [Submit]        │ Primary button
│                     │
└─────────────────────┘
```

**After Answer Submission** (Correct):

```
┌─────────────────────┐
│ [×] Quiz  [⏱ 01:28]│
├─────────────────────┤
│ Question 3 of 10    │
│ ▓▓▓░░░░░░░░░░░░░░   │
├─────────────────────┤
│                     │
│ Which widget is     │
│ used for layout in  │
│ Flutter?            │
│                     │
│ ┌─────────────────┐ │
│ │ A) Container    │ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │✓B) Column       │ │ Correct (green)
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ C) Both         │ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ D) Neither      │ │
│ └─────────────────┘ │
│                     │
│ ┌─────────────────┐ │
│ │ ✅ Correct!     │ │ Feedback card
│ │ Column is used  │ │ (green background)
│ │ for vertical    │ │
│ │ layouts.        │ │
│ │                 │ │
│ │ +10 XP          │ │ Points earned
│ └─────────────────┘ │
│                     │
│   [Next Question]   │ Action button
│                     │
└─────────────────────┘
```

**After Answer Submission** (Incorrect):

```
│ ┌─────────────────┐ │
│ │ A) Container    │ │ User's answer (red)
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │✓B) Column       │ │ Correct answer (green)
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ C) Both         │ │
│ └─────────────────┘ │
│                     │
│ ┌─────────────────┐ │
│ │ ❌ Not quite    │ │ Feedback card
│ │                 │ │ (red background)
│ │ Column is the   │ │ Explanation
│ │ correct widget  │ │
│ │ for vertical    │ │
│ │ layout. A       │ │
│ │ Container can   │ │
│ │ hold only one   │ │
│ │ child.          │ │
│ └─────────────────┘ │
│                     │
│   [Next Question]   │
│                     │
```

---

## 9. Exercise Summary Screen

**After completing all questions**

```
┌─────────────────────┐
│ [×] Results         │
├─────────────────────┤
│                     │
│      🎉             │ Celebration icon
│                     │
│ Great Job!          │ Title
│                     │
│ ┌─────────────────┐ │
│ │  Score          │ │ Score card
│ │                 │ │
│ │      8/10       │ │ Large numbers
│ │                 │ │
│ │   80% Correct   │ │ Percentage
│ └─────────────────┘ │
│                     │
│ ⏱ Time: 05:23      │ Metrics
│ ⭐ XP Earned: 80    │
│ 🔥 Streak: 6 days   │
│                     │
│ ┌─────────────────┐ │
│ │ Accuracy        │ │ Stats breakdown
│ │ ▓▓▓▓▓▓▓▓░░░░   │ │ Visual bar
│ │                 │ │
│ │ Speed           │ │
│ │ ▓▓▓▓▓▓░░░░░░   │ │
│ │                 │ │
│ │ Difficulty      │ │
│ │ ▓▓▓▓▓▓▓▓▓░░░   │ │
│ └─────────────────┘ │
│                     │
│ Areas to Improve:   │
│ • State management  │ Suggestions
│ • Navigation        │
│                     │
│ [Review Answers]    │ Secondary action
│ [Practice Again]    │ Secondary action
│ [Continue Learning] │ Primary action
│                     │
└─────────────────────┘
```

**Components**:
- Celebration visual (emoji or animation)
- Congratulatory title
- Large score display
- Metrics (time, XP, streak)
- Performance breakdown (visual bars)
- Improvement suggestions
- Action buttons

**Interactions**:
- Review Answers → See all questions with feedback
- Practice Again → Restart same exercise
- Continue Learning → Return to dashboard

---

## 10. Progress Screen

```
┌─────────────────────┐
│ [≡] Progress [Filter]│
├─────────────────────┤
│ [Overview][Stats]   │ Tabs
│ [Achievements]      │
├─────────────────────┤
│                     │
│ ┌─────────────────┐ │
│ │   ⭕ 75%        │ │ Circular progress
│ │   Level 8       │ │ Large, centered
│ │   2,450 XP      │ │
│ └─────────────────┘ │
│                     │
│ 🔥 Current Streak   │
│ ┌─────────────────┐ │
│ │    6 Days       │ │ Streak counter
│ │  [Fire emoji]   │ │
│ │  Keep it up!    │ │
│ └─────────────────┘ │
│                     │
│ This Week           │
│ ┌─────────────────┐ │
│ │ M T W T F S S   │ │ Weekly calendar
│ │ ✓ ✓ ✓ ✓ • • •   │ │
│ └─────────────────┘ │
│                     │
│ Recent Activity     │
│ ┌─────────────────┐ │
│ │ ✓ Completed     │ │ Activity list
│ │   Lesson 5      │ │
│ │   2 hours ago   │ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ ⭐ Earned Badge │ │
│ │   Fast Learner  │ │
│ │   1 day ago     │ │
│ └─────────────────┘ │
│                     │
├─────────────────────┤
│ [🏠][📚][✏][📊][👤]│
└─────────────────────┘
```

### Progress - Stats Tab

```
┌─────────────────────┐
│ [≡] Progress [Filter]│
├─────────────────────┤
│ [Overview][Stats]   │ Stats selected
│ [Achievements]      │
├─────────────────────┤
│ Time Period ▼       │ Dropdown
│ [This Month]        │
│                     │
│ ┌─────────────────┐ │
│ │ [Line Graph]    │ │ Activity chart
│ │ Daily Activity  │ │
│ │                 │ │
│ └─────────────────┘ │
│                     │
│ Statistics          │
│ ┌────────┐┌────────┐│ Grid 2x2
│ │ 24     ││ 180    ││
│ │Lessons ││Minutes ││
│ └────────┘└────────┘│
│ ┌────────┐┌────────┐│
│ │ 15     ││ 85%    ││
│ │Exercise││Accuracy││
│ └────────┘└────────┘│
│                     │
│ Top Topics          │
│ ┌─────────────────┐ │
│ │ Flutter  ▓▓▓▓▓▓ │ │ Bar chart
│ │ Dart     ▓▓▓▓░░ │ │
│ │ UI/UX    ▓▓▓░░░ │ │
│ └─────────────────┘ │
│                     │
│ Learning Pace       │
│ ▓▓▓▓▓▓▓░░░░░░░░░   │ Progress bar
│ 2.5 lessons/week    │
│ Goal: 3.0/week      │
│                     │
├─────────────────────┤
│ [🏠][📚][✏][📊][👤]│
└─────────────────────┘
```

### Progress - Achievements Tab

```
┌─────────────────────┐
│ [≡] Progress [Filter]│
├─────────────────────┤
│ [Overview][Stats]   │
│ [Achievements]      │ Achievements selected
├─────────────────────┤
│                     │
│ Unlocked (12)       │
│ ┌────────┐┌────────┐│
│ │ [🏆]   ││ [⭐]   ││ Badge grid
│ │First   ││5 Day   ││ 2-3 columns
│ │Lesson  ││Streak  ││
│ └────────┘└────────┘│
│ ┌────────┐┌────────┐│
│ │ [🎯]   ││ [🚀]   ││
│ │10 Quiz ││Fast    ││
│ │Master  ││Learner ││
│ └────────┘└────────┘│
│                     │
│ In Progress (3)     │
│ ┌────────┐┌────────┐│
│ │ [📚50%]││ [🔥75%]││ Progress shown
│ │Century ││30 Day  ││
│ │Scholar ││Streak  ││
│ │50/100  ││23/30   ││
│ └────────┘└────────┘│
│                     │
│ Locked (5)          │
│ ┌────────┐┌────────┐│
│ │ [🔒]   ││ [🔒]   ││ Grayed out
│ │Master  ││Expert  ││
│ │Level   ││Tier    ││
│ └────────┘└────────┘│
│                     │
├─────────────────────┤
│ [🏠][📚][✏][📊][👤]│
└─────────────────────┘
```

**Interactions**:
- Badge tap → Achievement detail modal
- Filter → Filter by category, time period
- Tab switch → Change view

---

## 11. Profile Screen

```
┌─────────────────────┐
│ [≡] Profile  [⚙]   │
├─────────────────────┤
│                     │
│    [Profile Pic]    │ Large, centered
│                     │
│    Alex Johnson     │ Name (Title Large)
│    @alexj           │ Username
│                     │
│ ┌─────────────────┐ │
│ │ Level 8  2450XP │ │ Stats bar
│ └─────────────────┘ │
│                     │
│ [Edit Profile]      │ Button
│                     │
│ ───────────────────  │ Divider
│                     │
│ Account             │ Section
│ ┌─────────────────┐ │
│ │ 👤 Personal Info│ │ List items
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ 🔐 Security     │ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ 🔔 Notifications│ │
│ └─────────────────┘ │
│                     │
│ Preferences         │ Section
│ ┌─────────────────┐ │
│ │ 🌙 Theme        │ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ 🌐 Language     │ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ 🎯 Learning Goal│ │
│ └─────────────────┘ │
│                     │
├─────────────────────┤
│ [🏠][📚][✏][📊][👤]│
└─────────────────────┘
```

**Components**:
- Profile picture (editable)
- Name and username
- Level and XP display
- Edit Profile button
- Settings sections (list)

**Interactions**:
- Profile pic tap → Change photo
- Edit Profile → Edit name, bio, etc.
- Settings icon → Full settings
- List item tap → Detail screen
- Bottom nav → Navigate

---

## 12. Settings Screen

```
┌─────────────────────┐
│ [←] Settings        │
├─────────────────────┤
│                     │
│ Account             │
│ ┌─────────────────┐ │
│ │ Email           │ │
│ │ alex@email.com  │ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ Password        │ │
│ │ Change          │ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ Linked Accounts │ │
│ │ Google, Apple   │ │
│ └─────────────────┘ │
│                     │
│ Notifications       │
│ ┌─────────────────┐ │
│ │ Push           ☑│ │ Toggle
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ Email          ☑│ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ Reminders      ☐│ │
│ └─────────────────┘ │
│                     │
│ Display             │
│ ┌─────────────────┐ │
│ │ Theme          >│ │ Navigation
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ Text Size      >│ │
│ └─────────────────┘ │
│                     │
│ Data                │
│ ┌─────────────────┐ │
│ │ Download       ☑│ │ Toggle
│ │ for Offline     │ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ Clear Cache    >│ │ Action
│ └─────────────────┘ │
│                     │
│ About               │
│ ┌─────────────────┐ │
│ │ Help & Support >│ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ Privacy Policy >│ │
│ └─────────────────┘ │
│ ┌─────────────────┐ │
│ │ Version 1.0.0   │ │
│ └─────────────────┘ │
│                     │
│  [Log Out]          │ Text button (red)
│                     │
└─────────────────────┘
```

---

## 13. Empty States

### No Lessons Yet

```
┌─────────────────────┐
│ [←] My Lessons      │
├─────────────────────┤
│                     │
│                     │
│      [📚]           │ Large icon
│                     │
│  No lessons yet     │ Headline
│                     │
│  Start learning to  │ Description
│  see your saved     │
│  lessons here       │
│                     │
│  [Browse Lessons]   │ CTA button
│                     │
│                     │
│                     │
│                     │
└─────────────────────┘
```

### No Internet

```
┌─────────────────────┐
│ [←] Lessons         │
├─────────────────────┤
│                     │
│                     │
│      [📡]           │ Large icon
│                     │
│  No Connection      │ Headline
│                     │
│  Connect to the     │ Description
│  internet to access │
│  lessons            │
│                     │
│  [Try Again]        │ CTA button
│                     │
│  [View Offline      │ Secondary action
│   Content]          │
│                     │
│                     │
└─────────────────────┘
```

---

## 14. Dialogs & Modals

### Exit Lesson Confirmation

```
┌─────────────────────┐
│                     │
│  ┌───────────────┐  │
│  │ Exit Lesson?  │  │
│  │               │  │
│  │ Your progress │  │
│  │ will be saved │  │
│  │               │  │
│  │ [Stay]        │  │ Text button
│  │ [Exit]        │  │ Filled button
│  └───────────────┘  │
│                     │
└─────────────────────┘
```

### Achievement Unlocked

```
┌─────────────────────┐
│                     │
│  ┌───────────────┐  │
│  │ [🎉 Trophy]   │  │
│  │               │  │
│  │ Achievement   │  │
│  │  Unlocked!    │  │
│  │               │  │
│  │  5 Day Streak │  │
│  │               │  │
│  │ Keep up the   │  │
│  │ great work!   │  │
│  │               │  │
│  │ [Share]       │  │ Text button
│  │ [Continue]    │  │ Filled button
│  └───────────────┘  │
│                     │
└─────────────────────┘
```

---

## 15. Responsive Breakpoints

### Phone (< 600dp)
- Single column layout
- Bottom navigation
- Stacked content
- Full-width cards

### Tablet (600-1200dp)
- Two-column grid
- Navigation rail (side)
- Wider content cards
- More content visible

### Desktop (> 1200dp)
- Three+ column grid
- Permanent navigation
- Max content width
- Optimized for mouse

---

## Implementation Notes

1. **All wireframes should be translated to high-fidelity mockups** using the design system colors, typography, and components.

2. **Spacing follows 8dp grid** as defined in design system.

3. **Touch targets minimum 48dp** for all interactive elements.

4. **Text should use theme styles** (headlineLarge, bodyMedium, etc.) not fixed sizes.

5. **Icons from Material Icons** set, sized appropriately (24dp default).

6. **Animations should be added** for screen transitions and micro-interactions.

7. **Accessibility annotations** should be implemented in code using Semantics widgets.

8. **Test on multiple devices** to ensure layouts adapt correctly.

---

## Next Steps

1. **Create high-fidelity mockups** in Figma based on these wireframes
2. **Build interactive prototype** to test user flows
3. **Conduct usability testing** with target users
4. **Refine based on feedback** and iterate
5. **Hand off designs to developers** with detailed specifications
6. **Review implementations** to ensure design fidelity

---

## Change Log

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-12-04 | 1.0 | Initial wireframes created | UX Designer Agent |

