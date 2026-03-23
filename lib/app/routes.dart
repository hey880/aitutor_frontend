import 'package:flutter/material.dart';

// Auth screens
import '../screens/auth/login_screen.dart';

// Home screens
import '../screens/home/home_dashboard_screen.dart';

// Call screens
import '../screens/call/incoming_call_screen.dart';
import '../screens/call/active_call_screen.dart';
import '../screens/call/active_call_chat_screen.dart';

// Onboarding screens
import '../screens/onboarding/proficiency_level_screen.dart';
import '../screens/onboarding/learning_goals_screen.dart';
import '../screens/onboarding/challenges_screen.dart';
import '../screens/onboarding/intro_card_screen.dart';
import '../screens/onboarding/schedule_setup_screen.dart';
import '../screens/onboarding/choose_voice_screen.dart';
import '../screens/onboarding/personal_details_screen.dart';
import '../screens/onboarding/self_introduction_screen.dart';
import '../screens/onboarding/create_account_screen.dart';

// Study screens
import '../screens/study/session_list_screen.dart';
import '../screens/study/saved_items_screen.dart';

// Performance screens
import '../screens/performance/phrase_practice_screen.dart';
import '../screens/performance/session_detail_screen.dart';

// Settings screens
import '../screens/settings/settings_screen.dart';
import '../screens/settings/edit_profile_screen.dart';
import '../screens/settings/tutor_settings_screen.dart';
import '../screens/settings/learning_activity_screen.dart';
import '../screens/settings/edit_schedule_screen.dart';

/// LingoDash Route Definitions
/// All named routes are defined here.

// =============================================================================
// ROUTE NAMES
// =============================================================================

class AppRoutes {
  // Auth
  static const String login = '/login';

  // Home
  static const String home = '/home';

  // Call Screens
  static const String incomingCall = '/call/incoming';
  static const String activeCall = '/call/active';
  static const String activeCallChat = '/call/active-chat';

  // Onboarding Flow
  static const String proficiencyLevel = '/onboarding/proficiency-level';
  static const String learningGoals = '/onboarding/learning-goals';
  static const String challenges = '/onboarding/challenges';
  static const String introCard = '/onboarding/intro-card';
  static const String scheduleSetup = '/onboarding/schedule-setup';
  static const String chooseVoice = '/onboarding/choose-voice';
  static const String personalDetails = '/onboarding/personal-details';
  static const String selfIntroduction = '/onboarding/self-introduction';
  static const String createAccount = '/onboarding/create-account';

  // Study Screens
  static const String sessionList = '/study/sessions';
  static const String savedItems = '/study/saved-items';

  // Performance Screens
  static const String phrasePractice = '/performance/phrase-practice';
  static const String sessionDetail = '/performance/session-detail';

  // Settings Screens
  static const String settings = '/settings';
  static const String editProfile = '/settings/edit-profile';
  static const String tutorSettings = '/settings/tutor';
  static const String learningActivity = '/settings/learning-activity';
  static const String editSchedule = '/settings/edit-schedule';
}

// =============================================================================
// ROUTE MAP
// =============================================================================

/// Returns the route map for MaterialApp.
Map<String, WidgetBuilder> getRoutes() {
  return {
    // Auth
    AppRoutes.login: (context) => const LoginScreen(),

    // Home
    AppRoutes.home: (context) => const HomeDashboardScreen(),

    // Call
    AppRoutes.incomingCall: (context) => const IncomingCallScreen(),
    AppRoutes.activeCall: (context) => const ActiveCallScreen(),
    AppRoutes.activeCallChat: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final sessionId = args?['sessionId'] as int? ?? 1; // Default to 1 for testing
      return ActiveCallChatScreen(sessionId: sessionId);
    },

    // Onboarding
    AppRoutes.proficiencyLevel: (context) => const ProficiencyLevelScreen(),
    AppRoutes.learningGoals: (context) => const LearningGoalsScreen(),
    AppRoutes.challenges: (context) => const ChallengesScreen(),
    AppRoutes.introCard: (context) => const IntroCardScreen(),
    AppRoutes.scheduleSetup: (context) => const ScheduleSetupScreen(),
    AppRoutes.chooseVoice: (context) => const ChooseVoiceScreen(),
    AppRoutes.personalDetails: (context) => const PersonalDetailsScreen(),
    AppRoutes.selfIntroduction: (context) => const SelfIntroductionScreen(),
    AppRoutes.createAccount: (context) => const CreateAccountScreen(),

    // Study
    AppRoutes.sessionList: (context) => const SessionListScreen(),
    AppRoutes.savedItems: (context) => const SavedItemsScreen(),

    // Performance
    AppRoutes.phrasePractice: (context) => const PhrasePracticeScreen(),
    AppRoutes.sessionDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final sessionId = args?['sessionId'] as int? ?? 1; // Default to 1 for testing
      return SessionDetailScreen(sessionId: sessionId);
    },

    // Settings
    AppRoutes.settings: (context) => const SettingsScreen(),
    AppRoutes.editProfile: (context) => const EditProfileScreen(),
    AppRoutes.tutorSettings: (context) => const TutorSettingsScreen(),
    AppRoutes.learningActivity: (context) => const LearningActivityScreen(),
    AppRoutes.editSchedule: (context) => const EditScheduleScreen(),
  };
}
