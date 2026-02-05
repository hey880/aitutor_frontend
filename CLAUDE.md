# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LingoDash is a Flutter mobile app for AI-powered English conversation practice. Users receive scheduled "calls" from an AI tutor, practice conversations, and review their performance with feedback on pronunciation, grammar, and vocabulary.

## Common Commands

```bash
# Run on device/emulator
flutter run

# Build APK
flutter clean && flutter pub get && flutter build apk

# Run all tests
flutter test

# Run single test file
flutter test test/screens/auth/login_screen_test.dart

# Run specific test by name
flutter test test/widgets/common/primary_button_test.dart -n "displays correctly"

# Analyze code
flutter analyze

# Format code
dart format lib/
```

## Architecture

**State Management:**
- Uses local `StatefulWidget` state for UI (no Provider/Riverpod/Bloc)
- `StubServices` class (`lib/utils/stub_services.dart`) provides mock data and API stubs
- `SharedPreferences` for login persistence only

**Navigation:**
- Named routes defined in `lib/app/routes.dart` (AppRoutes class)
- Routes configured in `lib/app/app.dart`
- Use `Navigator.pushNamed()`, `Navigator.pushReplacementNamed()`, `Navigator.pop()`

**Screen Organization:**
```
lib/screens/
├── auth/          # Login
├── call/          # Incoming call, active call, chat
├── home/          # Dashboard
├── onboarding/    # 9-step signup flow
├── performance/   # Post-call practice, session detail
├── settings/      # User preferences
└── study/         # Session archive, saved items
```

**Reusable Widgets:** `lib/widgets/common/` (buttons, nav bars, text fields)

## Design System

All design tokens centralized in `lib/app/theme.dart`:

| Class | Purpose |
|-------|---------|
| `AppColors` | Primary (#2B6CEE), backgrounds, semantic colors |
| `AppRadius` | Border radii (full, xxl, xl, lg, md) |
| `AppTextStyles` | Typography using GoogleFonts.lexend() |
| `AppShadows` | Card and button shadows |

**Usage Pattern:**
```dart
// Always use theme constants
Container(
  color: AppColors.primary,  // Never hardcode colors
  borderRadius: BorderRadius.circular(AppRadius.xl),
)
```

## Key Patterns

**Screen Structure:**
```dart
Scaffold(
  backgroundColor: Colors.white,  // AppColors.darkBg for dark screens
  body: SafeArea(
    child: Column(
      children: [
        // Header
        Expanded(
          child: SingleChildScrollView(
            child: Column(children: [...]),
          ),
        ),
      ],
    ),
  ),
  bottomNavigationBar: BottomNavBar(...),
)
```

**Stub Data Access:**
```dart
final String userName = StubServices.displayName;
final List sessions = StubServices.sessions;
```

**Dark Theme Screens:**
- Only `incoming_call_screen` and `active_call_screen` use dark theme
- Force with `Scaffold(backgroundColor: AppColors.darkBg)`

## Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point |
| `lib/app/app.dart` | MaterialApp config, routes, initial route logic |
| `lib/app/theme.dart` | Design tokens (colors, typography, shadows) |
| `lib/app/routes.dart` | Route name constants |
| `lib/utils/stub_services.dart` | All mock data and API stubs |

## Current State

**Implemented (UI Complete):**
- Full onboarding flow (9 screens)
- Login with Google/Kakao buttons (stub auth)
- Home dashboard with call scheduling
- Incoming/active call screens with audio visualizer
- Chat interface with message bubbles and translations
- Session review with score rings
- Settings and profile management
- Learning activity calendar heatmap

**Stub Only (No Backend):**
- Authentication (returns mock success)
- Voice/audio communication
- API calls (all return mock data)
- Push notifications
