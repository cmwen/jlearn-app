# Design System - JLearn App

**Date**: December 4, 2025  
**Version**: 1.0  
**Status**: Draft

## Overview

This design system provides a comprehensive guide to the visual and interaction design of the JLearn app. It ensures consistency across all screens and components while maintaining flexibility for future growth.

**Design Philosophy**:
> "Learn without friction. The interface should be invisible, allowing users to focus entirely on learning."

---

## 1. Color System

### Material Design 3 Dynamic Color

We use Material Design 3's dynamic color system with a custom seed color.

```dart
// Implementation
ColorScheme.fromSeed(
  seedColor: const Color(0xFF2196F3), // Primary blue
  brightness: Brightness.light,
)

ColorScheme.fromSeed(
  seedColor: const Color(0xFF2196F3),
  brightness: Brightness.dark,
)
```

### Color Palette

#### Light Theme

**Core Colors**:
- **Primary**: `#2196F3` - Main brand color, CTAs, links
- **On Primary**: `#FFFFFF` - Text/icons on primary
- **Primary Container**: `#D1E4FF` - Subtle primary backgrounds
- **On Primary Container**: `#001D36` - Text on primary container

**Secondary Colors**:
- **Secondary**: `#625B71` - Less prominent components
- **On Secondary**: `#FFFFFF` - Text/icons on secondary
- **Secondary Container**: `#E8DEF8` - Subtle secondary backgrounds
- **On Secondary Container**: `#1D192B` - Text on secondary container

**Tertiary Colors**:
- **Tertiary**: `#7D5260` - Accent, highlights
- **On Tertiary**: `#FFFFFF` - Text/icons on tertiary
- **Tertiary Container**: `#FFD8E4` - Subtle tertiary backgrounds
- **On Tertiary Container**: `#31111D` - Text on tertiary container

**Surfaces**:
- **Background**: `#FFFBFE` - App background
- **On Background**: `#1C1B1F` - Text on background
- **Surface**: `#FFFBFE` - Component backgrounds
- **On Surface**: `#1C1B1F` - Text on surface
- **Surface Variant**: `#E7E0EC` - Alternative surface
- **On Surface Variant**: `#49454F` - Text on surface variant

**Utility Colors**:
- **Error**: `#BA1A1A` - Errors, warnings
- **On Error**: `#FFFFFF` - Text on error
- **Error Container**: `#FFDAD6` - Error backgrounds
- **On Error Container**: `#410002` - Text on error container
- **Outline**: `#79747E` - Borders, dividers
- **Outline Variant**: `#CAC4D0` - Subtle borders

#### Dark Theme

**Core Colors**:
- **Primary**: `#A1C9FF` - Main brand color
- **On Primary**: `#003258` - Text/icons on primary
- **Primary Container**: `#00497D` - Primary backgrounds
- **On Primary Container**: `#D1E4FF` - Text on primary container

**Surfaces**:
- **Background**: `#1C1B1F` - App background
- **On Background**: `#E6E1E5` - Text on background
- **Surface**: `#1C1B1F` - Component backgrounds
- **On Surface**: `#E6E1E5` - Text on surface

*(Similar pattern for secondary, tertiary, error colors)*

### Custom Semantic Colors

Beyond Material's default colors, we add semantic colors for learning contexts:

```dart
// Custom colors for app-specific meanings
extension CustomColors on ColorScheme {
  Color get success => brightness == Brightness.light 
      ? const Color(0xFF4CAF50) 
      : const Color(0xFF81C784);
  
  Color get warning => brightness == Brightness.light
      ? const Color(0xFFFFA726)
      : const Color(0xFFFFB74D);
  
  Color get info => brightness == Brightness.light
      ? const Color(0xFF29B6F6)
      : const Color(0xFF4FC3F7);
  
  // Learning-specific colors
  Color get correctAnswer => success;
  Color get incorrectAnswer => error;
  Color get streak => const Color(0xFFFF9800); // Orange
  Color get achievement => const Color(0xFFFFD700); // Gold
}
```

### Color Usage Guidelines

| Element | Color | Usage |
|---------|-------|-------|
| Primary Button | Primary | Main actions (Start Lesson, Submit) |
| Secondary Button | Secondary | Supporting actions (Skip, Back) |
| FAB | Primary | Primary screen action |
| Links | Primary | Interactive text |
| Success Feedback | Success | Correct answers, achievements |
| Error Feedback | Error | Incorrect answers, validation |
| Warning | Warning | Hints, cautions |
| Progress Bar (active) | Primary | Current progress |
| Progress Bar (inactive) | Outline Variant | Remaining progress |
| Streak Counter | Streak (Orange) | Daily streak display |
| Achievement Badge | Achievement (Gold) | Badge backgrounds |

### Accessibility Requirements

**Color Contrast Ratios** (WCAG 2.1 Level AA):
- Normal text (< 18pt): Minimum 4.5:1
- Large text (≥ 18pt): Minimum 3:1
- UI components: Minimum 3:1

**Never use color alone**: Always pair with icons, labels, or patterns.

---

## 2. Typography

### Type Scale

We use Material Design 3 type scale with custom font choices.

#### Font Family

**Primary Font**: `Roboto` (default Material font)
- Clean, modern, highly legible
- Excellent for body text and UI
- Available in multiple weights

**Display Font**: `Poppins` (optional, for headers)
- Friendly, approachable
- Great for titles and hero text
- Use for special emphasis only

```dart
// Implementation
ThemeData(
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 64 / 57,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 52 / 45,
    ),
    // ... other styles
  ),
)
```

### Type Styles

| Style | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| **Display Large** | 57sp | Regular (400) | 64sp | Hero titles, splash |
| **Display Medium** | 45sp | Regular (400) | 52sp | Large headers |
| **Display Small** | 36sp | Regular (400) | 44sp | Section headers |
| **Headline Large** | 32sp | Regular (400) | 40sp | Screen titles |
| **Headline Medium** | 28sp | Regular (400) | 36sp | Card headers |
| **Headline Small** | 24sp | Regular (400) | 32sp | List headers |
| **Title Large** | 22sp | Regular (400) | 28sp | App bar titles |
| **Title Medium** | 16sp | Medium (500) | 24sp | Emphasized text |
| **Title Small** | 14sp | Medium (500) | 20sp | Secondary titles |
| **Label Large** | 14sp | Medium (500) | 20sp | Buttons, tabs |
| **Label Medium** | 12sp | Medium (500) | 16sp | Chips, badges |
| **Label Small** | 11sp | Medium (500) | 16sp | Captions, hints |
| **Body Large** | 16sp | Regular (400) | 24sp | Main content |
| **Body Medium** | 14sp | Regular (400) | 20sp | Secondary content |
| **Body Small** | 12sp | Regular (400) | 16sp | Captions |

### Typography Usage Examples

**Screen Titles**: Headline Large
```dart
Text(
  'My Lessons',
  style: Theme.of(context).textTheme.headlineLarge,
)
```

**Card Titles**: Title Large
```dart
Text(
  'Introduction to Flutter',
  style: Theme.of(context).textTheme.titleLarge,
)
```

**Body Content**: Body Large or Body Medium
```dart
Text(
  'This lesson covers the basics of Flutter widgets.',
  style: Theme.of(context).textTheme.bodyLarge,
)
```

**Button Text**: Label Large
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Start Lesson'), // Uses labelLarge by default
)
```

### Text Scaling Support

Support text scaling up to 200% without breaking layout:

```dart
Text(
  'Example text',
  style: Theme.of(context).textTheme.bodyLarge,
  maxLines: 2,
  overflow: TextOverflow.ellipsis, // Prevent overflow
)
```

---

## 3. Spacing & Layout

### 8dp Grid System

All spacing follows an 8dp baseline grid for consistency and visual rhythm.

**Base Unit**: 8dp

**Spacing Scale**:
```dart
class Spacing {
  static const double xs = 4.0;   // 0.5x
  static const double sm = 8.0;   // 1x
  static const double md = 16.0;  // 2x
  static const double lg = 24.0;  // 3x
  static const double xl = 32.0;  // 4x
  static const double xxl = 48.0; // 6x
}
```

### Layout Guidelines

**Screen Padding**:
- Mobile: 16dp horizontal, 16dp vertical
- Tablet: 24dp horizontal, 24dp vertical
- Desktop: 32dp horizontal, 24dp vertical

**Card Padding**:
- Internal: 16dp all sides
- Between cards: 8dp gap

**List Items**:
- Vertical padding: 12-16dp
- Horizontal padding: 16dp
- Between items: 0dp (use dividers if needed)

**Buttons**:
- Internal padding: 16dp horizontal, 10dp vertical
- Between buttons: 8dp
- Icon-only buttons: 12dp all sides

### Touch Target Sizes

Minimum touch target: **48 x 48 dp**

```dart
// Ensure minimum touch target
InkWell(
  onTap: () {},
  child: Container(
    width: 48,
    height: 48,
    alignment: Alignment.center,
    child: Icon(Icons.favorite),
  ),
)
```

### Safe Areas

Respect system UI:
```dart
SafeArea(
  child: Scaffold(...),
)
```

### Max Content Width

For readability on large screens:
- **Optimal**: 600-800dp
- **Maximum**: 1200dp

```dart
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 800),
  child: content,
)
```

---

## 4. Elevation & Shadows

Material Design 3 uses surface tints instead of shadows for elevation.

### Elevation Levels

| Level | Usage | Example Components |
|-------|-------|-------------------|
| 0 | Base surface | Screen background |
| 1 | Slightly raised | Cards, chips |
| 2 | Resting | FAB (resting) |
| 3 | Raised | FAB (pressed), app bar (scrolled) |
| 4 | High emphasis | Navigation drawer |
| 6 | Dialogs | Dialogs, menus |

### Implementation

```dart
// Using Material widget
Material(
  elevation: 1,
  child: Container(...),
)

// Using Card widget
Card(
  elevation: 1,
  child: content,
)

// Custom shadow
Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  ),
)
```

---

## 5. Components

### Button Styles

#### Filled Button (Primary)
**Usage**: Primary actions, main CTAs

```dart
FilledButton(
  onPressed: () {},
  child: Text('Start Lesson'),
)
```

**Style**:
- Background: Primary color
- Text: On Primary color
- Height: 40dp
- Border radius: 20dp (fully rounded)
- Padding: 24dp horizontal

#### Filled Tonal Button (Secondary)
**Usage**: Secondary actions, less emphasis

```dart
FilledButton.tonal(
  onPressed: () {},
  child: Text('Continue'),
)
```

**Style**:
- Background: Secondary Container
- Text: On Secondary Container
- Same dimensions as Filled Button

#### Outlined Button (Tertiary)
**Usage**: Tertiary actions, alternative choices

```dart
OutlinedButton(
  onPressed: () {},
  child: Text('Skip'),
)
```

**Style**:
- Background: Transparent
- Border: 1dp Outline color
- Text: Primary color

#### Text Button (Low Emphasis)
**Usage**: Inline actions, links

```dart
TextButton(
  onPressed: () {},
  child: Text('Learn More'),
)
```

**Style**:
- Background: Transparent
- Text: Primary color
- No border

### Cards

#### Elevated Card
**Usage**: Default card style, lesson cards, content containers

```dart
Card(
  elevation: 1,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lesson Title', style: titleLarge),
        SizedBox(height: 8),
        Text('Description', style: bodyMedium),
      ],
    ),
  ),
)
```

**Style**:
- Elevation: 1
- Border radius: 12dp
- Padding: 16dp
- Background: Surface color

#### Outlined Card
**Usage**: Alternative selections, optional content

```dart
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    side: BorderSide(color: Theme.of(context).colorScheme.outline),
    borderRadius: BorderRadius.circular(12),
  ),
  child: content,
)
```

### Input Fields

#### Text Field
**Usage**: Text input, search, forms

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'your@email.com',
    prefixIcon: Icon(Icons.email),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

**Style**:
- Border radius: 8dp
- Height: 56dp
- Padding: 16dp horizontal

#### Search Field
**Usage**: Search functionality

```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Search lessons...',
    prefixIcon: Icon(Icons.search),
    filled: true,
    fillColor: surfaceVariant,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide.none,
    ),
  ),
)
```

### Navigation

#### Bottom Navigation Bar

```dart
NavigationBar(
  destinations: [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.book_outlined),
      selectedIcon: Icon(Icons.book),
      label: 'Learn',
    ),
    NavigationDestination(
      icon: Icon(Icons.edit_outlined),
      selectedIcon: Icon(Icons.edit),
      label: 'Practice',
    ),
    NavigationDestination(
      icon: Icon(Icons.analytics_outlined),
      selectedIcon: Icon(Icons.analytics),
      label: 'Progress',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
  selectedIndex: currentIndex,
  onDestinationSelected: (index) {
    setState(() => currentIndex = index);
  },
)
```

**Style**:
- Height: 80dp
- Icon size: 24dp
- Label: Label Medium
- Selected: Primary color
- Unselected: On Surface Variant

#### App Bar

```dart
AppBar(
  title: Text('My Lessons'),
  actions: [
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () {},
    ),
  ],
)
```

**Style**:
- Height: 64dp
- Title: Title Large
- Background: Surface (default) or Primary (for emphasis)

### Floating Action Button (FAB)

```dart
FloatingActionButton.extended(
  onPressed: () {},
  icon: Icon(Icons.add),
  label: Text('Start Learning'),
)
```

**Style**:
- Size: 56dp (regular), 40dp (small), 96dp (large)
- Elevation: 3
- Background: Primary Container
- Icon/Text: On Primary Container

### Progress Indicators

#### Linear Progress
**Usage**: Determinate progress (lesson completion)

```dart
LinearProgressIndicator(
  value: 0.7, // 70% complete
  backgroundColor: Colors.grey[300],
  valueColor: AlwaysStoppedAnimation<Color>(primary),
)
```

#### Circular Progress
**Usage**: Indeterminate loading

```dart
CircularProgressIndicator()
```

#### Custom Progress Ring
**Usage**: Overall progress display

```dart
CircularPercentIndicator(
  radius: 60.0,
  lineWidth: 10.0,
  percent: 0.75,
  center: Text('75%'),
  progressColor: primary,
)
```

### Badges

```dart
Badge(
  label: Text('New'),
  backgroundColor: error,
  child: Icon(Icons.notifications),
)
```

**Usage**: Notifications, unread counts, status

### Chips

#### Filter Chip
```dart
FilterChip(
  label: Text('Beginner'),
  selected: isSelected,
  onSelected: (selected) {},
)
```

#### Choice Chip
```dart
ChoiceChip(
  label: Text('Video'),
  selected: selectedType == 'video',
  onSelected: (selected) {
    if (selected) setState(() => selectedType = 'video');
  },
)
```

### Dialogs

```dart
AlertDialog(
  title: Text('Exit Lesson?'),
  content: Text('Your progress will be saved.'),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text('Cancel'),
    ),
    FilledButton(
      onPressed: () {
        // Save and exit
        Navigator.pop(context);
      },
      child: Text('Exit'),
    ),
  ],
)
```

### Bottom Sheets

```dart
showModalBottomSheet(
  context: context,
  builder: (context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Save for later'),
            onTap: () {},
          ),
        ],
      ),
    );
  },
)
```

### Snackbars

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Lesson completed!'),
    action: SnackBarAction(
      label: 'View',
      onPressed: () {},
    ),
    behavior: SnackBarBehavior.floating,
  ),
)
```

---

## 6. Icons

### Icon Set
**Material Icons**: Default icon set for Flutter

### Icon Sizes
- **Small**: 16dp (inline with text)
- **Medium**: 24dp (default, most UI elements)
- **Large**: 32dp (prominent actions)
- **Extra Large**: 48dp+ (empty states, onboarding)

### Icon Usage Guidelines

**Outlined vs Filled**:
- Use outlined icons for unselected/inactive states
- Use filled icons for selected/active states

**Example**:
```dart
Icon(
  isSelected ? Icons.favorite : Icons.favorite_border,
  size: 24,
  color: isSelected ? primary : onSurfaceVariant,
)
```

### Key Icons

| Function | Icon | Usage |
|----------|------|-------|
| Home | `home` / `home_outlined` | Home navigation |
| Learn | `book` / `book_outlined` | Learn section |
| Practice | `edit` / `edit_outlined` | Practice section |
| Progress | `analytics` / `analytics_outlined` | Progress section |
| Profile | `person` / `person_outlined` | Profile section |
| Start | `play_arrow` | Start lesson/exercise |
| Pause | `pause` | Pause |
| Complete | `check_circle` | Completion |
| Favorite | `favorite` / `favorite_border` | Bookmark/like |
| Share | `share` | Share content |
| Settings | `settings` | Settings |
| Search | `search` | Search |
| Filter | `filter_list` | Filters |
| Close | `close` | Dismiss |
| Back | `arrow_back` | Back navigation |
| More | `more_vert` | More options |
| Achievement | `emoji_events` | Achievements/trophies |
| Streak | `local_fire_department` | Streak counter |

---

## 7. Animations & Transitions

### Animation Principles
1. **Purposeful**: Every animation should have a reason
2. **Quick**: Keep animations snappy (< 300ms)
3. **Subtle**: Don't distract from content
4. **Consistent**: Use same durations/curves throughout

### Standard Durations

```dart
class AnimationDurations {
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration medium = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration verySlow = Duration(milliseconds: 500);
}
```

### Curves

```dart
class AnimationCurves {
  static const Curve standard = Curves.easeInOut;
  static const Curve decelerate = Curves.easeOut;
  static const Curve accelerate = Curves.easeIn;
  static const Curve emphasized = Curves.easeInOutCubic;
}
```

### Screen Transitions

#### Default (Fade)
```dart
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NewScreen(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
  transitionDuration: AnimationDurations.medium,
)
```

#### Slide Up (for modals)
```dart
SlideTransition(
  position: Tween<Offset>(
    begin: Offset(0, 1),
    end: Offset.zero,
  ).animate(animation),
  child: child,
)
```

### Micro-interactions

#### Button Press
```dart
InkWell(
  onTap: () {},
  splashColor: primary.withOpacity(0.3),
  highlightColor: primary.withOpacity(0.1),
  child: Container(...),
)
```

#### Card Tap
```dart
AnimatedContainer(
  duration: AnimationDurations.fast,
  transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
  child: Card(...),
)
```

#### List Item Appearance
```dart
AnimatedList(
  itemBuilder: (context, index, animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.3),
          end: Offset.zero,
        ).animate(animation),
        child: ListTile(...),
      ),
    );
  },
)
```

---

## 8. States & Feedback

### Interactive States

All interactive elements should have these states:

1. **Default** (resting)
2. **Hover** (desktop only)
3. **Focused** (keyboard navigation)
4. **Pressed** (active tap)
5. **Disabled** (non-interactive)

### Loading States

#### Skeleton Screens
Use for initial page load:

```dart
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    width: double.infinity,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

#### Progress Indicators
Use for actions in progress:
- Circular: Indeterminate operations
- Linear: Determinate operations (with known progress)

### Success States

**Visual Feedback**:
- Green checkmark icon
- Success color background
- Positive message
- Optional confetti/celebration animation

```dart
// Success snackbar
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Row(
      children: [
        Icon(Icons.check_circle, color: Colors.white),
        SizedBox(width: 8),
        Text('Lesson completed!'),
      ],
    ),
    backgroundColor: success,
  ),
)
```

### Error States

**Visual Feedback**:
- Error color
- Clear error message
- Action to resolve (retry, dismiss)
- Icon indicating problem

```dart
// Error dialog
AlertDialog(
  icon: Icon(Icons.error_outline, color: error, size: 48),
  title: Text('Couldn\'t load lesson'),
  content: Text('Check your internet connection and try again.'),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text('Dismiss'),
    ),
    FilledButton(
      onPressed: () {
        // Retry
      },
      child: Text('Retry'),
    ),
  ],
)
```

### Empty States

**Components**:
- Illustrative icon/image (large, friendly)
- Descriptive text (what and why)
- Call to action

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.library_books, size: 64, color: onSurfaceVariant),
      SizedBox(height: 16),
      Text(
        'No lessons yet',
        style: headlineSmall,
      ),
      SizedBox(height: 8),
      Text(
        'Start learning to see your progress here',
        style: bodyMedium,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 24),
      FilledButton(
        onPressed: () {},
        child: Text('Browse Lessons'),
      ),
    ],
  ),
)
```

---

## 9. Accessibility

### Color Contrast

All text and interactive elements must meet WCAG 2.1 Level AA:
- Normal text: 4.5:1 minimum
- Large text (18pt+): 3:1 minimum
- UI components: 3:1 minimum

**Testing**: Use contrast checker tools during design.

### Touch Targets

Minimum size: 48 x 48 dp
Minimum spacing: 8dp between targets

### Semantic Widgets

```dart
Semantics(
  label: 'Start vocabulary lesson',
  hint: 'Double tap to begin',
  button: true,
  enabled: true,
  child: ElevatedButton(
    onPressed: () {},
    child: Text('Start'),
  ),
)
```

### Focus Management

```dart
FocusScope.of(context).requestFocus(nextFocusNode);
```

### Text Scaling

Test all layouts with text scaling:
```dart
MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaleFactor: 2.0),
  child: YourWidget(),
)
```

---

## 10. Implementation Checklist

### For Each Screen

- [ ] Uses Material Design 3 components
- [ ] Follows color system (light & dark themes)
- [ ] Uses type scale correctly
- [ ] Adheres to 8dp spacing grid
- [ ] Touch targets minimum 48dp
- [ ] Includes loading states
- [ ] Includes error states
- [ ] Includes empty states
- [ ] Has semantic labels
- [ ] Meets color contrast requirements
- [ ] Supports text scaling to 200%
- [ ] Responsive (phone, tablet, desktop)
- [ ] Animations are purposeful and < 300ms
- [ ] Keyboard navigation works
- [ ] Screen reader tested

---

## 11. Resources

### Design Tools
- **Figma**: For mockups and prototypes
- **Material Theme Builder**: For color schemes
- **Contrast Checker**: For accessibility validation

### Flutter Packages
- `flutter_animate`: Advanced animations
- `shimmer`: Loading skeletons
- `cached_network_image`: Image caching
- `percent_indicator`: Progress displays

### Documentation
- [Material Design 3](https://m3.material.io/)
- [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)
- [Material Components Flutter](https://github.com/material-components/material-components-flutter)

---

## Change Log

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-12-04 | 1.0 | Initial design system | UX Designer Agent |

---

## Next Steps

1. **Create Component Library**: Build reusable widgets based on this system
2. **Design Mockups**: Create high-fidelity designs for key screens
3. **Build Storybook**: Document all components with examples
4. **Accessibility Audit**: Test with screen readers and tools
5. **User Testing**: Validate design decisions with real users

