# LingoDash — Flutter Conversion Guide (CLAUDE.md)

> **Purpose:** This is the main context file for converting a Stitch-generated HTML prototype app into Flutter, to be read by Claude Code.  
> **Conversion Scope:** UI code only (screens, navigation, design tokens). Backend/API/actual voice call logic will remain as stubs.  
> **Execution:** Run directly in Android Studio. Claude Code handles code conversion only.

---

## 1. App Name and Package

| Item | Value |
|---|---|
| App Name | LingoDash |
| Package Name | `com.example.lingodash` |
| Flutter SDK | `>=3.0.0` |
| Dart SDK | `>=3.0.0` |

---

## 2. Design Tokens

All colors, fonts, and radii are managed through a **centralized theme file**. **NEVER** hardcode them directly.

### 2.1 Colors

```
primary          : #2b6cee   (all buttons, focus states, highlights)
darkBg           : #101622   (dark mode background — incoming_call, active_call)
darkBgAlt        : #0F172A   (dark mode background alternative)
lightBg          : #f6f6f8   (light mode background)
callGreen        : #22c55e   (call accept button)
callRed          : #ef4444   (call decline / End Call)
kakaoBg          : #FEE500   (Kakao login button)
kakaoText        : #191919
aiBubble (light) : #f1f1f4   (AI chat bubble — light mode)
aiBubble (dark)  : #1E293B   (AI chat bubble — dark mode)
userBubble       : #2b6cee   (user chat bubble)
levelColors      : [#f1f5f9, #dbeafe, #93c5fd, #3b82f6, #1d4ed8]  (learning activity heatmap)
```

### 2.2 Typography

| Level | Font | Weight | Size |
|---|---|---|---|
| Display / Hero | Lexend | 700 | 28–32 px |
| Title Large | Lexend | 700 | 24 px |
| Title Medium | Lexend | 600–700 | 18–20 px |
| Body Large | Lexend | 400–500 | 16 px |
| Body Medium | Lexend | 400–500 | 14–15 px |
| Body Small | Lexend | 400 | 13 px |
| Label Large | Lexend | 600–700 | 12 px |
| Label Small / Caption | Lexend | 500–700 | 10–11 px (uppercase, wide tracking) |

**Font Package:** Use `google_fonts` package → `GoogleFonts.lexend(…)`

### 2.3 Border Radius

```
full    : 9999  (Pills — buttons, chips, tabs)
xxl     : 24    (large cards)
xl      : 16    (regular cards, input fields)
lg      : 12
md      : 8
```

### 2.4 Shadows / Elevation

```
cardShadow      : BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: Offset(0,2))
primaryShadow   : BoxShadow(color: Color(0x332b6cee), blurRadius: 12, offset: Offset(0,4))  (for primary buttons)
redShadow       : BoxShadow(color: Colors.red.withOpacity(0.2), blurRadius: 12, offset: Offset(0,4))
```

---

## 3. Project Folder Structure (Recommended)

```
lib/
├── main.dart
├── app/
│   ├── app.dart                  # MaterialApp, ThemeData definition
│   ├── theme.dart                # Design token constants and ThemeData
│   └── routes.dart               # Route definitions (named routes)
├── screens/
│   ├── onboarding/
│   │   ├── proficiency_level_screen.dart
│   │   ├── learning_goals_screen.dart
│   │   ├── challenges_screen.dart
│   │   ├── intro_card_screen.dart
│   │   ├── schedule_setup_screen.dart
│   │   ├── choose_voice_screen.dart
│   │   ├── personal_details_screen.dart
│   │   ├── self_introduction_screen.dart
│   │   └── create_account_screen.dart
│   ├── auth/
│   │   └── login_screen.dart
│   ├── home/
│   │   └── home_dashboard_screen.dart
│   ├── call/
│   │   ├── incoming_call_screen.dart
│   │   ├── active_call_screen.dart          # Dark audio visualizer view
│   │   ├── active_call_chat_screen.dart     # Chat bubble view (light/dark toggle)
│   │   └── end_call_modal.dart              # End call reason modal
│   ├── study/
│   │   ├── session_list_screen.dart         # Session archive
│   │   └── saved_items_screen.dart          # Saved learning items
│   ├── performance/
│   │   ├── phrase_practice_screen.dart      # Sentence practice (mic hold)
│   │   └── session_detail_screen.dart       # Session detail (scores, key expressions)
│   └── settings/
│       ├── settings_screen.dart
│       ├── edit_profile_screen.dart
│       ├── tutor_settings_screen.dart
│       ├── learning_activity_screen.dart    # Calendar heatmap
│       └── edit_schedule_screen.dart
├── widgets/
│   ├── common/
│   │   ├── bottom_nav_bar.dart              # Shared bottom tab navigation
│   │   ├── onboarding_progress_bar.dart     # Onboarding progress indicator
│   │   ├── primary_button.dart              # Common primary button
│   │   ├── app_text_field.dart              # Common input field
│   │   └── back_button.dart                 # Common back button
│   ├── call/
│   │   ├── audio_visualizer.dart            # Blue circular audio bars
│   │   ├── chat_bubble.dart                 # AI/User bubble component
│   │   └── call_control_button.dart         # Mute/Speaker/End etc
│   └── study/
│       ├── archive_card.dart                # Learning item card
│       ├── session_card.dart                # Session list card
│       └── score_ring.dart                  # SVG circular progress (Pronunciation etc)
└── utils/
    └── stub_services.dart                   # API/voice stub classes
```

---

## 4. Screen List and Original Mapping

The correspondence between each Stitch HTML folder → Flutter screen file with key implementation points.

### 4.1 Onboarding Flow (Sequential navigation, using stub data)

| # | HTML Folder | Flutter Screen | Key Points |
|---|---|---|---|
| 1 | `select_proficiency_level` | `proficiency_level_screen.dart` | 4 radio options, border-primary on selection, bottom Next button |
| 2 | `select_learning_goals` | `learning_goals_screen.dart` | 2-column grid, multi-select (checkboxes), Travel selected by default |
| 3 | `personal_information_7` | `challenges_screen.dart` | Multi-select list, each item with icon+description, Pronunciation selected by default |
| 4 | `personal_information_8` | `intro_card_screen.dart` | Center-aligned info card, bottom 2 feature cards |
| 5 | `schedule_ai_calls` | `schedule_setup_screen.dart` | Day grid (M~S toggle) + daily time list + DND info card |
| 6 | `choose_ai_voice` | `choose_voice_screen.dart` | Voice list, selected item border-primary + check_circle, Play Sample button |
| 7 | `personal_information_9` | `personal_details_screen.dart` | Name/nickname/DOB input, gender 3-column grid selection |
| 8 | `self_introduction` | `self_introduction_screen.dart` | Large TextField (multiline), hint example text, Finish/Skip |
| 9 | `create_account` | `create_account_screen.dart` | 3 buttons (Google/Kakao/Email), terms agreement text |

### 4.2 Auth

| HTML Folder | Flutter Screen | Key Points |
|---|---|---|
| `home_dashboard_2` | `login_screen.dart` | LingoDash logo + title, Google SVG icon, Kakao button, terms links |

### 4.3 Main App (Tab Navigation)

| HTML Folder | Flutter Screen | Key Points |
|---|---|---|
| `home_dashboard_1` | `home_dashboard_screen.dart` | Premium badge, Practice with Sarah card, tutoring type list, Streak/Words stat cards, bottom tabs |
| `incoming_ai_call` | `incoming_call_screen.dart` | Dark background, large "S" avatar (circular), Remind/Message buttons, Accept(green)/Decline(red) |
| `active_ai_conversation_1` | `active_call_screen.dart` | Dark background, MM:SS timer, circular audio visualizer, bottom 4 controls, End Call shows modal |
| `active_ai_conversation_2` | `active_call_chat_screen.dart` (light) | Chat bubble list, AI bubble(left)=gray, User bubble(right)=primary, Feedback chip, Listening indicator, bottom controls |
| `active_ai_conversation_3` | `active_call_chat_screen.dart` (dark) | Same structure as above, dark theme toggle implementation |
| `active_ai_conversation_1` (modal) | `end_call_modal.dart` | Bottom sheet modal, 5 radio reasons, Submit & Close button |

### 4.4 Performance / Study

| HTML Folder | Flutter Screen | Key Points |
|---|---|---|
| `call_performance_summary_1` | `phrase_practice_screen.dart` | Top progress (1/5), English sentence+Korean translation, Listen button, large mic button (hold to speak) |
| `call_performance_summary_2` | `session_detail_screen.dart` | 3 circular score rings (SVG), AI Feedback card, Key Expressions list+Practice button, bottom tabs |
| `learning_archive_by_session` | `session_list_screen.dart` | Top tabs (All Sessions/Favorites/Completed), session card list (date/topic/word count/accuracy) |
| `learning_archive` | `saved_items_screen.dart` | Search bar, category chip filter (All/Vocabulary/Grammar/Pronunciation), learning card (original→correction→explanation) |

### 4.5 Settings

| HTML Folder | Flutter Screen | Key Points |
|---|---|---|
| `personal_information_3` | `settings_screen.dart` | User name, Q&A/Account/Privacy list, Logout button, bottom 4 tabs |
| `personal_information_2` | `edit_profile_screen.dart` | Display Name, Self-Introduction(multiline), DOB, unique identifier display |
| `personal_information_1` | `tutor_settings_screen.dart` | AI tutor avatar, tutor name input, 4 voices (2x2 grid cards), Speaking Speed slider |
| `personal_information_4` | `learning_activity_screen.dart` | 3 stat cards, monthly 7x~4 calendar grid (heatmap), Activity Level legend, insights card |
| `personal_information_5` | `edit_schedule_screen.dart` | Day toggle grid, iOS-style time scroll picker (HH:MM AM/PM), notification info |
| `personal_information_6` | (same screen, list view variant) | Day toggle (circular) + daily time list cards |

---

## 5. Common Widget Guidelines

### 5.1 Bottom Tab Navigation (`BottomNavBar`)

```
Tab structure:
  0: Schedule  (calendar_month icon)
  1: Call      (call icon) — circular background highlight when active
  2: Study     (menu_book or auto_stories icon)

- Settings tab added only on personal_information_3 (Settings screen)
- Active tab: primary color, icon filled variant
- Inactive tab: slate-400 color
- Background: white 90% opacity + backdrop blur effect (use frostedGlass effect in Flutter)
```

### 5.2 Onboarding Progress Bar

```
Type A (Single progress bar): proficiency_level, select_learning_goals, challenges, intro_card, personal_details, self_introduction
  → Top "Step X of 8" + percentage text + single progress bar

Type B (Segment bar): choose_ai_voice
  → 8 small rectangular segments, completed segments = primary, incomplete = slate-100

Type C (3-segment bar): create_account
  → 3 segments (Final Step, 3 of 3, 100%)
```

### 5.3 Common Button Patterns

```
Primary Button (final CTA):
  - bg: primary (#2b6cee)
  - text: white, bold
  - radius: xl (16) or full (pill)
  - shadow: primaryShadow
  - weight: always fixed at bottom of screen

Secondary / Outline Button:
  - bg: white / slate-50
  - border: slate-200
  - text: dark

Kakao Button:
  - bg: #FEE500
  - text: #191919, bold
  - icon: chat_bubble (filled)
```

---

## 6. Dark / Light Mode Handling

| Screen | Mode |
|---|---|
| incoming_ai_call | **Always dark** |
| active_call_screen (visualizer) | **Always dark** |
| active_call_chat_screen | **Toggleable** (light default, dark switch) |
| All other screens | **Light only** (dark variants in HTML are for reference) |

→ Define two ThemeData types (light / dark) in Flutter, default to light. Force dark mode only on specific screens.

---

## 7. Stub Definitions

Provide stub data/services so the app runs without a real backend. Organize everything in `utils/stub_services.dart`.

```dart
// Stub data structure example
class StubServices {
  // Auth
  static Future<void> loginWithGoogle() async {} // noop
  static Future<void> loginWithKakao() async {} // noop

  // User
  static String displayName = 'Alex Smith';
  static String tutorName = 'Professor Sarah';

  // Schedule
  static List<bool> selectedDays = [true,true,true,true,true,false,false]; // M~F
  static List<String> scheduleTimes = ['09:30 AM','09:30 AM','09:30 AM','09:30 AM','09:30 AM'];

  // Call
  static int callDurationSeconds = 582; // 09:42

  // Study / Archive
  static List<Map<String,dynamic>> sessions = [...]; // session list stub
  static List<Map<String,dynamic>> savedItems = [...]; // saved items stub

  // Performance
  static Map<String,int> scores = {'pronunciation': 85, 'intonation': 92, 'fluency': 78};
  static List<String> keyExpressions = ['I was wondering if...', 'To cut a long story short', 'Under the weather'];

  // Learning Activity (calendar)
  static Map<int,int> dailyWordCount = {1:120, 2:340, 3:0, 4:650, ...};

  // Voice
  static List<Map<String,String>> voices = [
    {'name':'Female - Friendly & Energetic','gender':'female'},
    {'name':'Male - Calm & Professional','gender':'male'},
    {'name':'Female - Warm & Direct','gender':'female'},
    {'name':'Male - Clear & Encouraging','gender':'male'},
  ];

  // Challenges
  static List<Map<String,String>> challenges = [
    {'title':'Pronunciation','icon':'record_voice_over','desc':'Mastering accents…'},
    {'title':'Listening','icon':'hearing','desc':'Understanding native…'},
    {'title':'Grammar','icon':'edit_note','desc':'Rules, verb tenses…'},
    {'title':'Speaking Confidence','icon':'psychology','desc':'Overcoming fear…'},
    {'title':'Vocabulary','icon':'menu_book','desc':'Expressing yourself…'},
  ];
}
```

---

## 8. Icon Guide

Map `Material Symbols Outlined` icons used in HTML to Flutter's `Icons` or `material_symbols_icons` package.

| HTML Icon Name | Flutter Usage |
|---|---|
| `translate` | `Icons.translate` |
| `call` | `Icons.call` |
| `call_end` | `Icons.call_end` |
| `mic` / `mic_off` | `Icons.mic` / `Icons.mic_off` |
| `volume_up` | `Icons.volume_up` |
| `arrow_back_ios_new` | `Icons.arrow_back_ios_new` |
| `arrow_forward` | `Icons.arrow_forward` |
| `chevron_right` | `Icons.chevron_right` |
| `calendar_month` / `calendar_today` | `Icons.calendar_month` / `Icons.calendar_today` |
| `search` | `Icons.search` |
| `settings` | `Icons.settings` |
| `person` | `Icons.person` |
| `add_circle` | `Icons.add_circle_outline` |
| `bookmark` (filled) | `Icons.bookmark` |
| `play_arrow` / `play_circle` | `Icons.play_arrow` / `Icons.play_circle_outline` |
| `pause` | `Icons.pause` |
| `replay` | `Icons.replay` |
| `close` / `cancel` | `Icons.close` / `Icons.cancel` |
| `edit` / `edit_calendar` | `Icons.edit` / `Icons.edit_calendar` |
| `check` / `check_circle` | `Icons.check` / `Icons.check_circle` |
| `info` | `Icons.info_outline` |
| `lightbulb` | `Icons.lightbulb_outline` |
| `share` | `Icons.share` |
| `delete` | `Icons.delete_outline` |
| `logout` | `Icons.logout` |
| `notifications_active` | `Icons.notifications_active` |
| `alarm` | `Icons.alarm` |
| `chat_bubble` | `Icons.chat_bubble_outline` |
| `smart_toy` | `Icons.smart_toy` |
| `workspace_premium` | `Icons.workspace_premium` |
| `local_fire_department` | `Icons.local_fire_department` |
| `record_voice_over` | `Icons.record_voice_over` |
| `menu_book` / `auto_stories` | `Icons.menu_book` / `Icons.auto_stories` |
| `graphic_eq` | `Icons.graphic_eq` |
| `analytics` | `Icons.analytics` |
| `exercise` | `Icons.fitness_center` |
| `dictionary` | `Icons.book_outlined` |
| `insights` / `trending_up` | `Icons.insights` / `Icons.trending_up` |
| `speed` | `Icons.speed` |
| `save` | `Icons.save` |
| `help_center` | `Icons.help_center` |
| `manage_accounts` | `Icons.manage_accounts` |
| `verified_user` | `Icons.verified_user` |

---

## 9. pubspec.yaml Base Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.0.0          # Lexend font
  material_icons: ^4.0.0        # (if needed) icon package
  # Following will be added in subsequent phases
  # firebase_core, firebase_auth, speech_to_text, etc.

flutter:
  uses-material-design: true
```

---

## 10. Conversion Rules & Prohibitions

1. **No hardcoding:** Colors, font sizes, radii → all reference `theme.dart` constants
2. **Responsive layout:** Use `MediaQuery`, `ConstrainedBox(maxWidth: 480)` (original HTML max-w-md ≈ 480px)
3. **Stubs only:** Real API calls, voice communication, Firebase integration etc → replace with stub functions (noop or return fixed data)
4. **One screen per file:** Each screen written independently in separate file
5. **Reuse common widgets:** Repetitive UI patterns (buttons, input fields, tab bars) extract to `widgets/common/`
6. **Routing:** Use `Navigator` named routes, map all routes in `routes.dart`
7. **StatefulWidget:** Use only for screens with toggle, selection, input state; rest use StatelessWidget
8. **Material Icons priority:** Use `Icons.xxx` when available; otherwise reference icon name string

---

## 11. Stitch Original Folder Reference Path

When conversion requires reference to original HTML and screenshots, originals exist at this path:

```
stitch_incoming_ai_call/
├── select_proficiency_level/    (code.html, screen.png)
├── select_learning_goals/
├── personal_information_7/      (Step 3: Challenges)
├── personal_information_8/      (Step 4: Intro Card)
├── schedule_ai_calls/           (Step 5: Schedule)
├── choose_ai_voice/             (Step 6: Voice)
├── personal_information_9/      (Step 7: Personal Details)
├── self_introduction/           (Step 8: Self Intro)
├── create_account/              (Sign Up)
├── home_dashboard_2/            (Login)
├── home_dashboard_1/            (Home Dashboard)
├── incoming_ai_call/            (Incoming Call)
├── active_ai_conversation_1/    (Live Call — Visualizer)
├── active_ai_conversation_2/    (Live Call — Chat Light)
├── active_ai_conversation_3/    (Live Call — Chat Dark)
├── call_performance_summary_1/  (Phrase Practice)
├── call_performance_summary_2/  (Session Detail)
├── learning_archive_by_session/ (Session List)
├── learning_archive/            (Saved Items)
├── personal_information_1/      (Tutor Settings)
├── personal_information_2/      (Edit Profile)
├── personal_information_3/      (Settings Root)
├── personal_information_4/      (Learning Activity)
├── personal_information_5/      (Edit Schedule — Wheel)
└── personal_information_6/      (Edit Schedule — List)
```
