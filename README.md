# LingoDash 🚀

An AI-powered English conversation learning app built with Flutter. Practice speaking English naturally with an AI tutor that provides real-time feedback, pronunciation scoring, and personalized learning experiences.

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10.7-02569B?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey" alt="Platform" />
</div>

## ✨ Features

### 🎯 Core Features
- **AI Conversation Practice**: Engage in natural conversations with an AI language tutor
- **Voice Recording**: Practice speaking with integrated audio recording
- **Real-time Feedback**: Get instant feedback on pronunciation, grammar, and vocabulary
- **Session Review**: Detailed performance analytics and conversation history
- **Smart Expressions**: Learn key expressions from your conversations
- **Personalized Learning**: Adaptive AI responses based on your proficiency level

### 📱 User Experience
- **Onboarding Flow**: Personalized setup with proficiency assessment
- **Daily Scheduling**: Set up practice reminders and notifications
- **Progress Tracking**: Monitor your improvement over time
- **Saved Items**: Bookmark useful expressions for later review
- **Multiple Themes**: Light and dark mode support during calls

### 🔧 Technical Features
- **Firebase Integration**: Push notifications for practice reminders
- **Audio Services**: High-quality speech-to-text and text-to-speech
- **Offline Support**: Graceful handling of network issues
- **Secure Authentication**: JWT-based user authentication

## 🏗️ Project Structure

```
lib/
├── app/                    # App-level configuration
│   ├── routes.dart         # Route definitions
│   └── theme.dart          # UI theme and styling
│
├── screens/                # UI screens
│   ├── call/              # Active call and incoming call screens
│   ├── home/              # Home dashboard
│   ├── onboarding/        # User onboarding flow
│   ├── performance/       # Session details and analytics
│   ├── settings/          # App settings and preferences
│   └── study/             # Study sessions and saved items
│
├── services/              # Business logic and external services
│   ├── api_service.dart   # Backend API communication
│   ├── audio_player_service.dart
│   ├── audio_recorder_service.dart
│   └── notification_service.dart
│
├── widgets/               # Reusable UI components
│   ├── common/            # Common widgets (buttons, headers, etc.)
│   └── study/             # Study-specific widgets
│
└── utils/                 # Utility functions and helpers
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.10.7 or higher
- **Dart SDK**: 3.0 or higher
- **Android Studio** or **Xcode** (for mobile development)
- **Backend API**: LingoDash backend server running (see `lingodash_backend` repo)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd lingodash
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (for notifications)
   - Place your `google-services.json` in `android/app/`
   - Place your `GoogleService-Info.plist` in `ios/Runner/`
   - **Note**: These files are gitignored for security

4. **Configure API endpoint**
   - Update `lib/services/api_service.dart` with your backend URL
   ```dart
   static const String baseUrl = 'http://your-backend-url:8000';
   ```

### Running the App

#### Development Mode
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>

# Run on web
flutter run -d chrome
```

#### Build for Production
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🔌 Backend Integration

This app requires the LingoDash backend API to be running. The backend provides:
- User authentication
- AI conversation generation
- Speech-to-text (STT) processing
- Text-to-speech (TTS) synthesis
- Feedback and analytics
- Session management

See the `lingodash_backend` repository for setup instructions.

## 📦 Key Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  http: ^1.2.0              # API communication
  shared_preferences: ^2.2.2 # Local storage
  firebase_core: ^2.24.2    # Firebase integration
  firebase_messaging: ^14.7.10 # Push notifications
  intl: ^0.19.0             # Internationalization
  path_provider: ^2.1.2     # File system access
  record: ^5.0.5            # Audio recording
  audioplayers: ^6.1.0      # Audio playback
```

## 🎨 UI/UX Features

### Design System
- **Custom Theme**: Consistent color palette and typography
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Page transitions and loading states
- **Dark Mode**: Supported in call screens

### Key Screens
1. **Incoming Call**: AI tutor calling interface
2. **Active Call Chat**: Real-time conversation with message bubbles
3. **Session Detail**: Post-call review with analytics
4. **Home Dashboard**: Practice history and quick actions
5. **Onboarding**: 8-step personalized setup flow

## 🔒 Security

- **No hardcoded credentials**: All sensitive data in gitignored files
- **JWT Authentication**: Secure API access
- **Firebase Rules**: Protected push notification tokens
- **Input Validation**: Client-side and server-side validation

### Gitignored Files
```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
.env files
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Check for outdated dependencies
flutter pub outdated
```

## 📱 Platform-Specific Notes

### Android
- **Minimum SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)
- **Permissions Required**:
  - `INTERNET`
  - `RECORD_AUDIO`
  - `POST_NOTIFICATIONS`

### iOS
- **Minimum Version**: iOS 12.0
- **Permissions Required**:
  - Microphone access
  - Notification permissions

### Web
- Audio recording requires HTTPS or localhost
- Some features may have limited support

## 🐛 Troubleshooting

### Common Issues

**"Failed to load session data"**
- Check backend API is running
- Verify API URL in `api_service.dart`
- Check network connectivity

**Audio recording not working**
- Grant microphone permissions
- On web, use HTTPS or localhost
- Check device audio settings

**Firebase notifications not working**
- Verify `google-services.json` is present
- Check FCM token registration in backend
- Enable notifications in device settings

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is private and not licensed for public use.

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- AI powered by backend LLM service
- Icons from [Material Icons](https://fonts.google.com/icons)
- Audio services: record & audioplayers packages

---

**Made with ❤️ for English learners**
