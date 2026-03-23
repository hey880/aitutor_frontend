import 'package:shared_preferences/shared_preferences.dart';

/// LingoDash Stub Services
/// Provides stub data/services so the app runs without a real backend.
/// All API calls, voice communication, Firebase integration etc are replaced
/// with stub functions (noop or return fixed data).

class StubServices {
  // ===========================================================================
  // LOGIN STATE PERSISTENCE
  // ===========================================================================

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  static Future<bool> getLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
  // ===========================================================================
  // AUTH
  // ===========================================================================

  static Future<void> loginWithGoogle() async {
    // noop - stub for Google login
  }

  static Future<void> loginWithKakao() async {
    // noop - stub for Kakao login
  }

  static Future<void> loginWithEmail(String email, String password) async {
    // noop - stub for email login
  }

  static Future<void> logout() async {
    // noop - stub for logout
  }

  // ===========================================================================
  // USER
  // ===========================================================================

  static String displayName = 'Alex Smith';
  static String tutorName = 'Alex';
  static String nickname = 'Alex';
  static String dateOfBirth = '1995-03-15';
  static String gender = 'Male';
  static String selfIntroduction =
      'I love traveling and want to improve my English for my upcoming trips.';
  static String uniqueIdentifier = '@alexsmith_1234';

  // ===========================================================================
  // SCHEDULE
  // ===========================================================================

  static List<bool> selectedDays = [
    true, // Monday
    true, // Tuesday
    true, // Wednesday
    true, // Thursday
    true, // Friday
    false, // Saturday
    false, // Sunday
  ];

  static List<String> scheduleTimes = [
    '09:30 AM',
    '09:30 AM',
    '09:30 AM',
    '09:30 AM',
    '09:30 AM',
  ];

  // ===========================================================================
  // CALL
  // ===========================================================================

  static int callDurationSeconds = 582; // 09:42

  static String formatCallDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  // ===========================================================================
  // STUDY / ARCHIVE
  // ===========================================================================

  static List<Map<String, dynamic>> sessions = [
    {
      'id': '1',
      'date': '2024-01-15',
      'topic': 'Travel Vocabulary',
      'wordCount': 45,
      'accuracy': 85,
      'duration': '12:34',
      'isFavorite': true,
      'isCompleted': true,
    },
    {
      'id': '2',
      'date': '2024-01-14',
      'topic': 'Restaurant Conversations',
      'wordCount': 38,
      'accuracy': 92,
      'duration': '10:22',
      'isFavorite': false,
      'isCompleted': true,
    },
    {
      'id': '3',
      'date': '2024-01-13',
      'topic': 'Daily Routines',
      'wordCount': 52,
      'accuracy': 78,
      'duration': '15:45',
      'isFavorite': true,
      'isCompleted': true,
    },
    {
      'id': '4',
      'date': '2024-01-12',
      'topic': 'Weather & Small Talk',
      'wordCount': 29,
      'accuracy': 88,
      'duration': '08:15',
      'isFavorite': false,
      'isCompleted': false,
    },
  ];

  static List<Map<String, dynamic>> savedItems = [
    {
      'id': '1',
      'category': 'Vocabulary',
      'original': 'I was wondering if...',
      'correction': null,
      'explanation': 'A polite way to ask questions or make requests.',
      'savedAt': '2024-01-15',
    },
    {
      'id': '2',
      'category': 'Grammar',
      'original': 'I have went to the store.',
      'correction': 'I have gone to the store.',
      'explanation':
          'Use the past participle "gone" with "have", not the simple past "went".',
      'savedAt': '2024-01-14',
    },
    {
      'id': '3',
      'category': 'Pronunciation',
      'original': 'comfortable',
      'correction': '/ˈkʌmf.tə.bəl/',
      'explanation':
          'The word has 3 syllables, not 4. The "or" is reduced to a schwa sound.',
      'savedAt': '2024-01-13',
    },
    {
      'id': '4',
      'category': 'Vocabulary',
      'original': 'To cut a long story short',
      'correction': null,
      'explanation': 'An idiom meaning to get to the main point quickly.',
      'savedAt': '2024-01-12',
    },
    {
      'id': '5',
      'category': 'Vocabulary',
      'original': 'Under the weather',
      'correction': null,
      'explanation': 'An idiom meaning feeling slightly ill or unwell.',
      'savedAt': '2024-01-11',
    },
  ];

  // ===========================================================================
  // PERFORMANCE
  // ===========================================================================

  static Map<String, int> scores = {
    'pronunciation': 85,
    'intonation': 92,
    'fluency': 78,
  };

  static List<Map<String, String>> keyExpressionsDetailed = [
    {
      'expression': 'I was wondering if...',
      'translation': '~할 수 있는지 궁금해요',
      'example': 'I was wondering if you could help me with this.',
    },
    {
      'expression': 'To cut a long story short',
      'translation': '간단히 말하자면',
      'example': 'To cut a long story short, we missed the train.',
    },
    {
      'expression': 'Under the weather',
      'translation': '몸이 좀 안 좋은',
      'example': "I'm feeling a bit under the weather today.",
    },
    {
      'expression': 'Could you speak slower?',
      'translation': '천천히 말씀해 주시겠어요?',
      'example': 'Could you speak a little slower, please?',
    },
    {
      'expression': 'Make a reservation',
      'translation': '예약하다',
      'example': "I'd like to make a reservation for two.",
    },
  ];

  static String aiFeedback =
      'Great job today! Your pronunciation has improved significantly. '
      'Focus on maintaining a steady pace when speaking longer sentences. '
      'Keep practicing the expressions we covered!';

  static String sessionTopic = 'Ordering Coffee at a Cafe';
  static String sessionDate = 'Jan 15, 2024 • 10:30 AM';

  static List<Map<String, dynamic>> conversationMessages = [
    {
      'messageId': 1,
      'sender': 'ai',
      'text': "Hello! Welcome to our practice session. Today we'll learn how to order coffee. How are you feeling?",
      'translatedText': '안녕하세요! 연습 세션에 오신 것을 환영합니다. 오늘은 커피 주문하는 법을 배워볼 거예요. 기분이 어떠세요?',
      'timestamp': '10:30 AM',
    },
    {
      'messageId': 2,
      'sender': 'user',
      'text': "I'm feeling good, thank you! I'm ready to learn.",
      'timestamp': '10:31 AM',
      'pronunciationScore': 88,
    },
    {
      'messageId': 3,
      'sender': 'ai',
      'text': "Great! Let's start. Imagine you're at a cafe. How would you greet the barista?",
      'translatedText': '좋아요! 시작해 볼까요. 카페에 있다고 상상해 보세요. 바리스타에게 어떻게 인사하시겠어요?',
      'timestamp': '10:31 AM',
    },
    {
      'messageId': 4,
      'sender': 'user',
      'text': 'Hi, I would like to order a coffee please.',
      'timestamp': '10:32 AM',
      'pronunciationScore': 92,
    },
    {
      'messageId': 5,
      'sender': 'ai',
      'text': "Perfect! That's very polite. Now, what if you want to ask about the menu? You could say 'I was wondering if you have any specials today.'",
      'translatedText': "완벽해요! 아주 공손하네요. 이제 메뉴에 대해 물어보고 싶다면요? 'I was wondering if you have any specials today.'라고 말할 수 있어요.",
      'timestamp': '10:32 AM',
    },
    {
      'messageId': 6,
      'sender': 'user',
      'text': 'I was wondering if you have any specials today?',
      'timestamp': '10:33 AM',
      'pronunciationScore': 85,
    },
    {
      'messageId': 7,
      'sender': 'ai',
      'text': "Excellent use of the expression! Your pronunciation is getting better. Remember to keep a steady pace.",
      'translatedText': '표현을 아주 잘 사용하셨어요! 발음이 점점 좋아지고 있어요. 일정한 속도를 유지하는 것을 기억하세요.',
      'timestamp': '10:33 AM',
    },
  ];

  // ===========================================================================
  // LEARNING ACTIVITY (Calendar Heatmap)
  // ===========================================================================

  static Map<int, int> dailyWordCount = {
    1: 120,
    2: 340,
    3: 0,
    4: 650,
    5: 220,
    6: 0,
    7: 180,
    8: 450,
    9: 320,
    10: 0,
    11: 280,
    12: 0,
    13: 520,
    14: 380,
    15: 290,
    16: 0,
    17: 0,
    18: 410,
    19: 350,
    20: 0,
    21: 190,
    22: 480,
    23: 0,
    24: 310,
    25: 270,
    26: 0,
    27: 420,
    28: 380,
    29: 0,
    30: 290,
    31: 150,
  };

  static int currentStreak = 7;
  static int totalWords = 1250;
  static int totalSessions = 23;

  // ===========================================================================
  // VOICE
  // ===========================================================================

  static List<Map<String, String>> voices = [
    {'name': 'Female - Friendly & Energetic', 'gender': 'female'},
    {'name': 'Male - Calm & Professional', 'gender': 'male'},
    {'name': 'Female - Warm & Direct', 'gender': 'female'},
    {'name': 'Male - Clear & Encouraging', 'gender': 'male'},
  ];

  static int selectedVoiceIndex = 0;
  static double speakingSpeed = 1.0; // 0.5 to 1.5

  // ===========================================================================
  // CHALLENGES (Onboarding)
  // ===========================================================================

  static List<Map<String, String>> challenges = [
    {
      'title': 'Pronunciation',
      'icon': 'record_voice_over',
      'desc': 'Mastering accents and sounds',
    },
    {
      'title': 'Listening',
      'icon': 'hearing',
      'desc': 'Understanding native speakers',
    },
    {
      'title': 'Grammar',
      'icon': 'edit_note',
      'desc': 'Rules, verb tenses, sentence structure',
    },
    {
      'title': 'Speaking Confidence',
      'icon': 'psychology',
      'desc': 'Overcoming fear of speaking',
    },
    {
      'title': 'Vocabulary',
      'icon': 'menu_book',
      'desc': 'Expressing yourself with the right words',
    },
  ];

  // ===========================================================================
  // LEARNING GOALS (Onboarding)
  // ===========================================================================

  static List<Map<String, String>> learningGoals = [
    {'title': 'Travel', 'icon': 'flight'},
    {'title': 'Work', 'icon': 'work'},
    {'title': 'Study Abroad', 'icon': 'school'},
    {'title': 'Daily Life', 'icon': 'home'},
    {'title': 'Business', 'icon': 'business_center'},
    {'title': 'Entertainment', 'icon': 'movie'},
  ];

  // ===========================================================================
  // PROFICIENCY LEVELS (Onboarding)
  // ===========================================================================

  static List<Map<String, String>> proficiencyLevels = [
    {
      'level': 'Beginner',
      'desc': 'I know some basic words and phrases',
    },
    {
      'level': 'Elementary',
      'desc': 'I can have simple conversations',
    },
    {
      'level': 'Intermediate',
      'desc': 'I can discuss familiar topics',
    },
    {
      'level': 'Advanced',
      'desc': 'I can speak fluently on most topics',
    },
  ];

  // ===========================================================================
  // CHAT MESSAGES (Active Call Chat)
  // ===========================================================================

  static List<Map<String, dynamic>> chatMessages = [
    {
      'isUser': false,
      'text': 'Hello! How are you doing today?',
      'timestamp': '09:30',
    },
    {
      'isUser': true,
      'text': 'I\'m doing well, thank you! How about you?',
      'timestamp': '09:31',
    },
    {
      'isUser': false,
      'text':
          'I\'m great! Let\'s practice some travel vocabulary today. Have you ever been abroad?',
      'timestamp': '09:31',
    },
    {
      'isUser': true,
      'text': 'Yes, I have went to Japan last year.',
      'timestamp': '09:32',
      'feedback': 'I have gone to Japan',
    },
    {
      'isUser': false,
      'text':
          'That sounds wonderful! What was your favorite part about visiting Japan?',
      'timestamp': '09:32',
    },
  ];

  // ===========================================================================
  // END CALL REASONS
  // ===========================================================================

  static List<String> endCallReasons = [
    'Completed the session',
    'Need to take a break',
    'Technical issues',
    'Called by mistake',
    'Other reason',
  ];

  // ===========================================================================
  // PHRASE PRACTICE
  // ===========================================================================

  static List<Map<String, String>> practicePhrases = [
    {
      'english': 'I was wondering if you could help me.',
      'korean': '저를 도와주실 수 있을지 궁금합니다.',
    },
    {
      'english': 'To cut a long story short, we missed the train.',
      'korean': '간단히 말하자면, 우리는 기차를 놓쳤습니다.',
    },
    {
      'english': 'I\'m feeling a bit under the weather today.',
      'korean': '오늘 몸이 좀 안 좋아요.',
    },
    {
      'english': 'Could you speak a little slower, please?',
      'korean': '조금 천천히 말씀해 주시겠어요?',
    },
    {
      'english': 'I\'d like to make a reservation for two.',
      'korean': '2명 예약하고 싶습니다.',
    },
  ];
}
