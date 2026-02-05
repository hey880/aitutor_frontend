# Claude Code Execution Prompts Guide

> **Prerequisites:**  
> 1. Create a Flutter project in Android Studio (package name: `com.example.lingodash`).  
> 2. Copy `CLAUDE.md` to the **root folder** of your Flutter project.  
> 3. Also copy the Stitch original folder (`stitch_incoming_ai_call/`) to the Flutter project root.  
> 4. Paste the step-by-step prompts below **sequentially** into Claude Code.  
> 5. After each phase completes, **verify build in Android Studio**, and fix any errors before proceeding to the next phase.

---

## Phase 0: Initial Project Setup

```
Read the CLAUDE.md file and set up the basic Flutter project structure. Only perform the tasks below; do NOT create screen code yet.

Task list:
1. Add the google_fonts package to pubspec.yaml.
2. Add the shared_preferences package to pubspec.yaml for login state persistence.
3. Create lib/app/theme.dart. Based on the "2. Design Tokens" section in CLAUDE.md, define Color constants and TextStyle constants, and create ThemeData (light) and ThemeData (dark). Use Lexend font via GoogleFonts.lexend().
4. Create lib/app/routes.dart. For now, just write an empty route map and list route names as comments, since screen files don't exist yet.
5. Create lib/app/app.dart. Define MaterialApp and connect ThemeData from theme.dart. Implement login state check:
   - Read SharedPreferences for 'isLoggedIn' boolean
   - If isLoggedIn = true → set initialRoute to '/home'
   - If isLoggedIn = false → set initialRoute to '/login'
   - For now, use a temporary empty Container() for home until home screen is created
6. Modify lib/main.dart to call MyApp from app.dart.
7. Create lib/utils/stub_services.dart. Write the structure from the "7. Stub Definitions" section in CLAUDE.md exactly as is. Add methods:
   - setLoggedIn(bool value) to save login state to SharedPreferences
   - getLoggedIn() to retrieve login state from SharedPreferences
8. Create lib/widgets/common/ folder and create empty files only (bottom_nav_bar.dart, onboarding_progress_bar.dart, primary_button.dart, app_text_field.dart, back_button.dart). Put only class declarations in each file with empty Container() bodies.

Make it buildable.
```

---

## Phase 1: Common Widget Implementation

```
Refer to CLAUDE.md and implement the common widgets in lib/widgets/common/ folder. Always use constants from theme.dart; do NOT hardcode colors directly.

1. back_button.dart
   - Widget with arrow_back_ios_new icon + onPressed callback
   - Icon size: 24, color: theme's primary or dark text

2. primary_button.dart
   - Parameters: text (String), onPressed (VoidCallback), isFullWidth (bool, default true)
   - bg: primary, text: white, bold, radius: xl (16)
   - shadow: primaryShadow
   - Add optional leading icon parameter

3. app_text_field.dart
   - Parameters: label (String), hintText (String), controller (TextEditingController), onChanged callback
   - border: slate-200, radius: xl, height: 56px
   - On focus: border: primary, ring: primary/20
   - Add optional suffixIcon parameter

4. onboarding_progress_bar.dart
   - Parameters: currentStep (int), totalSteps (int)
   - Display "Step X of Y" text and percentage text
   - LinearProgressIndicator (primary color, background slate-100, radius: full)

5. bottom_nav_bar.dart
   - Parameters: currentIndex (int), onTap (Function(int))
   - 3 tabs: Schedule(calendar_month), Call(call), Study(menu_book)
   - Active tab: primary color + circular primary/10 background around icon
   - Inactive tab: slate-400
   - Background: white 90% opacity + top border
   - Parameter: showSettings (bool, default false): if true, add 4th "Settings" tab
```

---

## Phase 2: Login and Onboarding Screens (Steps 1-4)

```
Refer to CLAUDE.md and code.html from the stitch_incoming_ai_call/ original folder to create the following screens. Write each screen in a separate file. Use stub data from stub_services.dart. All colors reference theme.dart.

1. lib/screens/auth/login_screen.dart  (original: home_dashboard_2)
   - LingoDash logo (translate icon + primary/10 background circle) + title
   - "Master English with your AI Tutor" hero text
   - Google login button (use Google 4-color SVG icon, or simple "G" text as fallback)
   - Kakao login button (kakaoBg color, chat_bubble icon)
   - Bottom terms text + links
   - Button onPressed: call StubServices.loginWithGoogle/Kakao then Navigator to proficiency_level

2. lib/screens/onboarding/proficiency_level_screen.dart  (original: select_proficiency_level)
   - Top: BackButton + "Onboarding" title
   - OnboardingProgressBar (step: 1, total: 8)
   - "What is your English level?" title
   - 4 option list (Beginner/Intermediate/Advanced/Fluent)
   - Each option: icon + title + description + right radio circle
   - On selection: border becomes primary, background becomes blue-50/30. Intermediate selected by default
   - Bottom: PrimaryButton "Next" → navigate to learning_goals
   - **VALIDATION: Must select one option. "Next" button enabled only when selection is made.**

3. lib/screens/onboarding/learning_goals_screen.dart  (original: select_learning_goals)
   - Top: BackButton + "Step 2 of 8"
   - OnboardingProgressBar (step: 2, total: 8)
   - "Why are you learning English?" title
   - 2-column Grid: Career, Travel, Exams, Conversation, Hobbies, Relocation
   - Each card: icon(primary/10 bg) + title + top-right check circle
   - Multi-select enabled, Travel selected by default
   - Bottom fixed: PrimaryButton "Next" → navigate to challenges
   - **VALIDATION: Must select at least one goal. "Next" button enabled only when at least one is selected.**

4. lib/screens/onboarding/challenges_screen.dart  (original: personal_information_7)
   - Top: BackButton + "Step 3 of 8"
   - OnboardingProgressBar (step: 3, total: 8)
   - "What is your biggest challenge…" title + description
   - Multi-select list of 5 (Pronunciation/Listening/Grammar/Speaking Confidence/Vocabulary)
   - Each item: large icon(48px square) + title+description + right check circle
   - Pronunciation selected by default
   - Bottom: PrimaryButton "Continue" → navigate to intro_card
   - **VALIDATION: Must select at least one challenge. "Continue" button enabled only when at least one is selected.**

5. lib/screens/onboarding/intro_card_screen.dart  (original: personal_information_8)
   - Top: BackButton + "Step 4 of 8"
   - OnboardingProgressBar (step: 4, total: 8)
   - Center: large call icon(primary/10 circular background) + top-right green check badge
   - "Real conversations, real progress." title
   - Description text
   - 2 Feature Cards: "Scheduled for you" (schedule icon), "Natural dialogue" (forum icon)
   - Bottom: PrimaryButton "Sounds Great" → navigate to schedule_setup

Register routes for these screens in routes.dart. Set login_screen as home in app.dart.
```

---

## Phase 3: Onboarding Screens (Steps 5-9 and Sign Up)

```
Refer to CLAUDE.md and original code.html to create the remaining onboarding screens.

1. lib/screens/onboarding/schedule_setup_screen.dart  (original: schedule_ai_calls)
   - Top: BackButton + "Onboarding" title
   - OnboardingProgressBar (step: 5, total: 8)
   - "Set your availability" title + description
   - Day grid 7 (M T W T F S S) — square buttons
     - Selected: primary bg, white text, shadow
     - Unselected: white bg, slate-200 border, slate text
     - Default: M, W, F selected
   - "Daily Schedule:" section
     - Card list for selected days (day name + time + edit/cancel buttons)
     - Default times: Mon 08:30 PM, Wed 07:45 PM, Fri 09:15 AM
   - DND info card (blue-50 background, notifications_paused icon)
   - Bottom: PrimaryButton "Set Schedule & Continue" → navigate to choose_voice
   - **VALIDATION: Must select at least one day and set time for each selected day. Button enabled only when valid.**

2. lib/screens/onboarding/choose_voice_screen.dart  (original: choose_ai_voice)
   - Top: BackButton + "Step 6 of 8"
   - Segment progress bar (8 segments, 6 primary, 2 slate-100)
   - "Choose AI Voice" title + description
   - Voice list of 4 (Female-Friendly, Male-Calm, Female-Warm, Male-Clear)
   - Each item: title + "Play Sample" button
   - Selected item: border-2 primary, check_circle icon displayed
   - First item (Female-Friendly) selected by default
   - Bottom fixed: PrimaryButton "Select & Continue" → navigate to personal_details
   - **VALIDATION: Must select one voice. "Select & Continue" button enabled only when selection is made.**

3. lib/screens/onboarding/personal_details_screen.dart  (original: personal_information_9)
   - Top: BackButton + "Step 7 of 8"
   - OnboardingProgressBar (step: 7, total: 8)
   - "Personal Details" title + description
   - Form fields: Full Name (default: "John Doe"), How should I address you? (empty), Date of Birth (default: 1995-01-01)
   - Gender selection: 3-column grid (He/Him, She/Her, Other/They) — He/Him selected by default
   - Bottom info card (info icon)
   - Bottom: PrimaryButton "Continue" → navigate to self_introduction
   - **VALIDATION: Name and Date of Birth are required. "Continue" button enabled only when both are filled.**

4. lib/screens/onboarding/self_introduction_screen.dart  (original: self_introduction)
   - Top: BackButton + "Step 8 of 8"
   - Progress bar 100%
   - "Tell me about yourself…" title + description
   - Large multiline TextField (min height 240px, radius 2xl, border-light)
   - Placeholder text: "I'm a marketing manager from Seoul…"
   - "Optional" label at bottom-right
   - lightbulb icon + example text
   - Bottom: "Finish" button (primary) → navigate to create_account
   - "Skip for now" text button
   - **VALIDATION: This field is optional. Both "Finish" and "Skip" buttons are always enabled.**

5. lib/screens/onboarding/create_account_screen.dart  (original: create_account)
   - Segment progress (Final Step, 3 of 3, 100%)
   - Center: large graphic_eq icon (primary circular background + glow effect)
   - "You're all set!" title
   - Description text
   - Google button (icon+text), Kakao button (kakaoBg)
   - "Sign up with Email" text link
   - Terms agreement text + Terms/Privacy links
   - Button onPressed: call StubServices then navigate to home_dashboard
   - **After sign up, set login state to true so user goes directly to home on next app launch.**

Add new screen routes to routes.dart.
```

---

## Phase 4: Home Dashboard and Incoming Call

```
Create core screens of the main app.

1. lib/screens/home/home_dashboard_screen.dart  (original: home_dashboard_1)
   - Scaffold with BottomNavBar (currentIndex: 1 = Call)
   - Top Header: LingoDash logo + Premium badge (amber-50 bg, workspace_premium icon) + calendar/person buttons
   - Display "Sarah" name below header (simple text, no large card)
   - "Tutoring Type" section: 2 selectable list items
     - English to Korean (icon: translate, chevron_right)
     - Korean to English (icon: translate, chevron_right)
     - Each item shows selection state with primary border or background highlight
     - English to Korean selected by default
     - Tap to toggle selection between the two options
   - Stats cards: Streak(5 Days, 🔥 icon) / Words Today(450, chat_bubble icon) — 2 columns
   - Bottom navigation: BottomNavBar with Call tab in center
   - **Call button (center tab) onPressed: navigate to incoming_call screen**
   - No separate "Start Practice Session" button needed

2. lib/screens/call/incoming_call_screen.dart  (original: incoming_ai_call)
   - Always dark background (#101622) — force via Scaffold's backgroundColor
   - Top: expand_more icon (left) + "AI Language Partner" text (center)
   - Center: large circular avatar (192x192) — internal "S" text (large, white, light weight)
     - Surrounding blurred primary/10 glow effect
     - Internal border (border white/5)
   - "Sarah" name (large bold) + "Scheduled Daily Practice" (primary) + "Incoming AI Call..." (white/40)
   - Remind Me / Message buttons (each with icon+text, white/5 circular bg)
   - Bottom: Accept(green, call icon) / Decline(red, call icon rotated 135°) — each large circular button(80x80)
   - **Accept onPressed: navigate to active_call_screen**
   - **Decline onPressed: Navigator.pushNamedAndRemoveUntil('/home', (route) => false) — return to home and clear navigation stack**
```

---

## Phase 5: Active Call Screens and Modal

```
Implement call-in-progress screens and end call modal.

1. lib/screens/call/active_call_screen.dart  (original: active_ai_conversation_1)
   - Always dark background
   - Top: "Live Session" (red pulse dot + text), MM:SS timer card
     - Timer initializes with StubServices.callDurationSeconds (582 seconds = 09:42), increments every second (StatefulWidget + Timer)
   - Center: "AI Language Coach" title + "Listening..." (primary)
   - Circular audio visualizer (separate to lib/widgets/call/audio_visualizer.dart)
     - 192x192 circle, primary→5b96ff gradient background
     - Internal 5 white vertical bars (randomly changing heights — implement with AnimationController)
     - External border circle (primary/20, scale 110%)
     - Glow effect: BoxShadow (primary/30, blur 20)
   - Language Toggle: "English Only" / "KR Translation" — pill-shaped toggle (2 options)
   - Bottom 4 controls: Mute(mic), Speaker(volume_up), Reset Turn(pause+replay), End Call(red)
   - End Call button onPressed: showModalBottomSheet to display end_call_modal

2. lib/screens/call/end_call_modal.dart  (original: active_ai_conversation_1 modal)
   - BottomSheet format (rounded top corners)
   - Top drag indicator (12x1.5, white/20)
   - "Why are you ending the call?" title + description
   - 5 radio options:
     - "I've finished my practice" (selected by default)
     - "It's a bad time"
     - "The AI didn't understand me"
     - "Technical issues"
     - "Other"
   - Each option: rounded-2xl card, on selection primary/10 bg + primary border
   - "Submit & Close" button (primary, full width)
   - onSubmit: Navigator.pop to close modal, navigate to session_detail (or return home)

3. lib/screens/call/active_call_chat_screen.dart  (original: active_ai_conversation_2, _3)
   - Top: AI avatar(smart_toy) + "Coach Sarah" + green dot "Active Session" + timer
   - Chat list (ListView):
     - AI message: left-aligned, aiBubble background, rounded-2xl (no top-left corner)
       - English text + bottom divider + Korean translation (small gray text)
       - Bottom-right time label
     - User message: right-aligned, userBubble(primary) background, rounded-2xl (no top-right corner)
       - Bottom-right: "Feedback" chip + time label
     - Thinking indicator: 3 bounce dots in AI bubble + "Sarah is thinking" text
   - Bottom: Listening indicator (5 vertical bars + "Listening..." text, primary/5 pill background)
   - Bottom controls: Mute / Speaker / Reset Turn / End Call (same)
   - Dark/light mode toggle: manage with state variable, change background/bubble colors in dark mode
   - Display initial messages using stub chat message data
```

---

## Phase 6: Performance and Study Screens

```
Implement post-call learning-related screens.

1. lib/screens/performance/phrase_practice_screen.dart  (original: call_performance_summary_1)
   - Top: close icon(left) + "Practice Session" + "1 of 5 phrases" (primary)
   - Progress bar: 1/5 = 20% (primary, light-grey background)
   - Center: large English sentence text (bold, center-aligned) + Korean translation (gray)
   - "Listen" button (icon+text, white bg, border)
   - "Press and hold to start speaking" info text
   - Large mic button (96x96, primary bg, shadow) — "Hold to Speak" text
   - Stub: use sentence data list

2. lib/screens/performance/session_detail_screen.dart  (original: call_performance_summary_2)
   - Top: BackButton + "Session Detail" title
   - Topic display: "Ordering Coffee at a Cafe" + date/time
   - 3 Score Rings (separate to widgets/study/score_ring.dart):
     - Pronunciation: 85% (primary color)
     - Intonation: 92% (green)
     - Fluency: 78% (orange/amber)
     - Each: circular SVG progress + percentage text + label
   - Performance Feedback card (slate-50 bg, auto_awesome icon + description)
   - "Key Expressions" section (3 items badge)
     - Each expression: title + description + "Practice" button (primary/10 bg)
   - Bottom: "Start Practice Session" PrimaryButton → navigate to phrase_practice
   - "View Full Transcript" outline button
   - Bottom tabs included (Study active)

3. lib/screens/study/session_list_screen.dart  (original: learning_archive_by_session)
   - Top: BackButton + "Learning Archive" title + search icon
   - Tab bar 3: All Sessions / Favorites / Completed (bottom border active indicator)
   - "This Week" / "Last Month" section dividers
   - Session card: date/time + topic + word count(dictionary icon) + accuracy(check_circle) + Practice button
   - Use stub session data

4. lib/screens/study/saved_items_screen.dart  (original: learning_archive)
   - Top: settings icon(left) + "Study Archive" title + add_circle(right)
   - Search bar (search icon, rounded-xl, light-grey bg)
   - Category chip filter: All(default active, primary bg), Vocabulary, Grammar, Pronunciation
   - Learning card list:
     - Top: category label(by color) + date + bookmark icon
     - "You said:" (original sentence)
     - "Correction:" (corrected sentence, bold, large text)
     - Explanation card (blue-50 bg, info/lightbulb/graphic_eq icon)
     - Bottom: Practice button + (optional) share/delete icons
   - "Last Week" section divider
   - Bottom tabs: Study active, Call center circular emphasis

Add new screen routes to routes.dart.
```

---

## Phase 7: Settings Screens

```
Implement settings-related screens.

1. lib/screens/settings/settings_screen.dart  (original: personal_information_3)
   - Top: "Settings & Support" title (center)
   - User name + "Pro Member • Learning English"
   - List sections:
     - Q&A Support (help_center, blue bg icon)
     - Account Settings (manage_accounts) → navigate to edit_profile
     - Privacy Policy (verified_user)
   - Logout button (red text, border, logout icon)
   - "Version 1.4.2 (2024)" text
   - Bottom tabs: Settings added (showSettings: true)

2. lib/screens/settings/edit_profile_screen.dart  (original: personal_information_2)
   - Top: "← Settings" + "Edit Profile" title + "Save" button
   - Display Name input (default: "Alex Smith")
   - Self-Introduction (multiline TextField, min 140px)
   - Date of Birth (DatePicker, default 1995-01-01)
   - Info card (privacy_tip icon)
   - Unique Identifier display: "SN-9823-4410-XF" (mono font, pill bg)

3. lib/screens/settings/tutor_settings_screen.dart  (original: personal_information_1)
   - BackButton + "Tutor Settings" title
   - AI tutor avatar (24x24 circle, primary/10, smart_toy icon) + edit badge
   - "Tutor Name" input (default: "Professor Sarah")
   - "Voice Personality" section + "HD Natural" label
   - 2x2 voice card grid:
     - Bella (selected: border-2 primary, play button primary bg, radio dot filled)
     - Marcus, Olivia, James (unselected: border slate-200)
   - "Speech Settings" section: Speaking Speed slider (0~100, default 50 = Normal)
   - "Save Changes" PrimaryButton

4. lib/screens/settings/learning_activity_screen.dart  (original: personal_information_4)
   - BackButton + "Learning Activity" title + share icon
   - 3 stat cards: Total Words(12,482) / Avg Per Day(416) / Total Time(42h 15m)
   - "October 2023" month title + left/right chevron buttons
   - Calendar grid (7 columns):
     - Day header (Mon~Sun)
     - Each date: aspect-square, heatmap color(from levelColors), date+word count text
     - Current day(6): ring-2 primary emphasis
   - Activity Level legend (Less → More, 5-level color blocks)
   - Insights card: "You've spoken 15% more…" (primary/5 bg)
   - "Detailed Report" PrimaryButton

5. lib/screens/settings/edit_schedule_screen.dart  (original: personal_information_5 + _6)
   - BackButton + "Edit Call Schedule" title
   - "Select Days" section: 7 day toggles (circular buttons, M~F selected by default)
   - "Daily Schedule" list:
     - Each day card: day name(primary, uppercase) + time(large text) + edit/close buttons
   - Notification info card (notifications_active icon)
   - "Save Schedule" PrimaryButton

Register new screen routes in routes.dart.
```

---

## Phase 8: Routing and Final Connections

```
All screens have been created, so finalize overall routing and navigation.

1. Complete routes.dart. Register named routes for all screens:
   /login, /proficiency, /goals, /challenges, /intro, /schedule_setup,
   /choose_voice, /personal_details, /self_intro, /create_account,
   /home, /incoming_call, /active_call, /active_call_chat,
   /phrase_practice, /session_detail, /session_list, /saved_items,
   /settings, /edit_profile, /tutor_settings, /learning_activity, /edit_schedule

2. Set home in app.dart to '/login' route.

3. Verify Navigator calls in each screen:
   - Onboarding: login → proficiency → goals → challenges → intro → schedule_setup → choose_voice → personal_details → self_intro → create_account → home
   - Home → incoming_call → active_call → (End Call) → session_detail → phrase_practice
   - Home tab navigation: Schedule(0), Call(1=home), Study(2=session_list)
   - Study: session_list → session_detail
   - Settings: from home tab person icon click → settings → edit_profile/tutor_settings/learning_activity/edit_schedule

4. Properly connect BottomNavBar's onTap in each screen.

5. Build and verify it runs without errors.
```

---

## Phase 9: UI Polish and Detail Corrections

```
Go through the entire app screen by screen, compare with original HTML, and correct design details.

Check the following checklist in order and correct any differences from the original:

1. [ ] Verify all screens use Lexend font (GoogleFonts.lexend)
2. [ ] Verify primary color (#2b6cee) is correctly applied
3. [ ] Verify dark mode screens (incoming_call, active_call) background color is #101622
4. [ ] Verify onboarding progress bar percentage is correctly calculated for each step
5. [ ] Verify card/button border radius matches values from theme.dart
6. [ ] Verify shadow effects are correctly applied with primaryShadow/cardShadow
7. [ ] Verify learning activity calendar heatmap colors match levelColors
8. [ ] Verify Score Ring circular progress draws correctly (85%, 92%, 78%)
9. [ ] Verify audio visualizer bars animate correctly
10. [ ] Verify all Navigator navigation paths work correctly
11. [ ] Verify stub data displays correctly (names, times, scores etc)
12. [ ] Verify scrolling works correctly throughout app (ListView, SingleChildScrollView)

Correct any items that need fixing from above.
```

---

## Execution Order Summary

| Phase | Content | Main Files |
|---|---|---|
| 0 | Initial project setup | theme.dart, routes.dart, app.dart, stub_services.dart |
| 1 | Common widgets | bottom_nav_bar, progress_bar, button, textfield, back_button |
| 2 | Login + Onboarding 1-4 | login, proficiency, goals, challenges, intro_card |
| 3 | Onboarding 5-9 + SignUp | schedule, voice, personal, self_intro, create_account |
| 4 | Home + Incoming Call | home_dashboard, incoming_call |
| 5 | Active Call + modal | active_call, end_call_modal, active_call_chat |
| 6 | Performance + Study | phrase_practice, session_detail, session_list, saved_items |
| 7 | Settings | settings, edit_profile, tutor_settings, learning_activity, edit_schedule |
| 8 | Routing connections | Complete routes.dart, connect Navigator |
| 9 | Final polish | Correct design details |
