# LingoDash 🚀

AI 기반 영어 회화 학습 앱입니다. AI 튜터와 자연스럽게 대화하며 실시간 피드백, 발음 점수, 맞춤형 학습 경험을 제공받을 수 있습니다.

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10.7-02569B?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey" alt="Platform" />
</div>

## ✨ 주요 기능

### 🎯 핵심 기능
- **AI 회화 연습**: AI 언어 튜터와 자연스러운 대화 연습
- **음성 녹음**: 통합 오디오 녹음으로 스피킹 연습
- **실시간 피드백**: 발음, 문법, 어휘에 대한 즉각적인 피드백
- **세션 리뷰**: 상세한 성과 분석 및 대화 기록
- **스마트 표현 학습**: 대화에서 핵심 표현 자동 추출
- **맞춤형 학습**: 사용자 수준에 맞춘 AI 응답

### 📱 사용자 경험
- **온보딩 플로우**: 수준 평가를 포함한 맞춤형 설정
- **일일 스케줄링**: 연습 알림 및 푸시 알림 설정
- **진행도 추적**: 시간 경과에 따른 개선 사항 모니터링
- **북마크**: 유용한 표현 저장 및 나중에 복습
- **다중 테마**: 통화 중 라이트/다크 모드 지원

### 🔧 기술적 특징
- **Firebase 연동**: 연습 알림을 위한 푸시 알림
- **오디오 서비스**: 고품질 음성-텍스트 및 텍스트-음성 변환
- **오프라인 지원**: 네트워크 문제 처리
- **보안 인증**: JWT 기반 사용자 인증

## 🏗️ 프로젝트 구조

```
lib/
├── app/                    # 앱 레벨 설정
│   ├── routes.dart         # 라우트 정의
│   └── theme.dart          # UI 테마 및 스타일링
│
├── screens/                # UI 화면
│   ├── call/              # 활성 통화 및 수신 전화 화면
│   ├── home/              # 홈 대시보드
│   ├── onboarding/        # 사용자 온보딩 플로우
│   ├── performance/       # 세션 상세 및 분석
│   ├── settings/          # 앱 설정 및 환경설정
│   └── study/             # 학습 세션 및 저장 항목
│
├── services/              # 비즈니스 로직 및 외부 서비스
│   ├── api_service.dart   # 백엔드 API 통신
│   ├── audio_player_service.dart
│   ├── audio_recorder_service.dart
│   └── notification_service.dart
│
├── widgets/               # 재사용 가능한 UI 컴포넌트
│   ├── common/            # 공통 위젯 (버튼, 헤더 등)
│   └── study/             # 학습 관련 위젯
│
└── utils/                 # 유틸리티 함수 및 헬퍼
```

## 🚀 시작하기

### 필수 요구사항

- **Flutter SDK**: 3.10.7 이상
- **Dart SDK**: 3.0 이상
- **Android Studio** 또는 **Xcode** (모바일 개발용)
- **백엔드 API**: LingoDash 백엔드 서버 실행 필요 (`lingodash_backend` 저장소 참조)

### 설치

1. **저장소 클론**
   ```bash
   git clone <repository-url>
   cd lingodash
   ```

2. **의존성 설치**
   ```bash
   flutter pub get
   ```

3. **Firebase 설정** (알림용)
   - `android/app/`에 `google-services.json` 파일 배치
   - `ios/Runner/`에 `GoogleService-Info.plist` 파일 배치
   - **주의**: 이 파일들은 보안상 gitignore에 포함되어 있습니다

4. **API 엔드포인트 설정**
   - `lib/services/api_service.dart`에서 백엔드 URL 업데이트
   ```dart
   static const String baseUrl = 'http://your-backend-url:8000';
   ```

### 앱 실행

#### 개발 모드
```bash
# 연결된 기기/에뮬레이터에서 실행
flutter run

# 특정 기기에서 실행
flutter devices
flutter run -d <device-id>

# 웹에서 실행
flutter run -d chrome
```

#### 프로덕션 빌드
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

## 🔌 백엔드 연동

이 앱은 LingoDash 백엔드 API가 실행 중이어야 합니다. 백엔드는 다음을 제공합니다:
- 사용자 인증
- AI 대화 생성
- 음성-텍스트 변환 (STT) 처리
- 텍스트-음성 변환 (TTS) 합성
- 피드백 및 분석
- 세션 관리

설정 방법은 `lingodash_backend` 저장소를 참조하세요.

## 📦 주요 의존성

```yaml
dependencies:
  flutter: sdk: flutter
  http: ^1.2.0              # API 통신
  shared_preferences: ^2.2.2 # 로컬 저장소
  firebase_core: ^2.24.2    # Firebase 연동
  firebase_messaging: ^14.7.10 # 푸시 알림
  intl: ^0.19.0             # 국제화
  path_provider: ^2.1.2     # 파일 시스템 접근
  record: ^5.0.5            # 오디오 녹음
  audioplayers: ^6.1.0      # 오디오 재생
```

## 🎨 UI/UX 특징

### 디자인 시스템
- **커스텀 테마**: 일관된 색상 팔레트와 타이포그래피
- **반응형 레이아웃**: 다양한 화면 크기에 적응
- **부드러운 애니메이션**: 페이지 전환 및 로딩 상태
- **다크 모드**: 통화 화면에서 지원

### 주요 화면
1. **수신 전화**: AI 튜터 호출 인터페이스
2. **활성 통화 채팅**: 메시지 버블로 실시간 대화
3. **세션 상세**: 통화 후 분석 리뷰
4. **홈 대시보드**: 연습 기록 및 빠른 실행
5. **온보딩**: 8단계 맞춤형 설정 플로우

## 🔒 보안

- **하드코딩된 자격 증명 없음**: 모든 민감 데이터는 gitignore 파일에
- **JWT 인증**: 안전한 API 접근
- **Firebase 규칙**: 푸시 알림 토큰 보호
- **입력 유효성 검사**: 클라이언트 및 서버 측 검증

### Gitignore 파일
```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
.env 파일들
```

## 🧪 테스트

```bash
# 모든 테스트 실행
flutter test

# 커버리지와 함께 실행
flutter test --coverage

# 코드 분석
flutter analyze

# 오래된 의존성 확인
flutter pub outdated
```

## 📱 플랫폼별 참고사항

### Android
- **최소 SDK**: 21 (Android 5.0)
- **타겟 SDK**: 34 (Android 14)
- **필요한 권한**:
  - `INTERNET`
  - `RECORD_AUDIO`
  - `POST_NOTIFICATIONS`

### iOS
- **최소 버전**: iOS 12.0
- **필요한 권한**:
  - 마이크 접근
  - 알림 권한

### Web
- 오디오 녹음은 HTTPS 또는 localhost 필요
- 일부 기능은 제한적 지원

## 🐛 문제 해결

### 일반적인 문제

**"Failed to load session data"**
- 백엔드 API가 실행 중인지 확인
- `api_service.dart`의 API URL 확인
- 네트워크 연결 확인

**오디오 녹음이 작동하지 않음**
- 마이크 권한 부여
- 웹에서는 HTTPS 또는 localhost 사용
- 기기 오디오 설정 확인

**Firebase 알림이 작동하지 않음**
- `google-services.json` 파일이 있는지 확인
- 백엔드에서 FCM 토큰 등록 확인
- 기기 설정에서 알림 활성화

## 🤝 기여하기

1. 저장소 포크
2. 기능 브랜치 생성 (`git checkout -b feature/amazing-feature`)
3. 변경사항 커밋 (`git commit -m '멋진 기능 추가'`)
4. 브랜치에 푸시 (`git push origin feature/amazing-feature`)
5. Pull Request 오픈

## 📄 라이센스

이 프로젝트는 비공개이며 공개 사용을 위한 라이센스가 없습니다.

## 🙏 감사의 말

- [Flutter](https://flutter.dev/)로 제작
- 백엔드 LLM 서비스로 AI 기능 제공
- 아이콘: [Material Icons](https://fonts.google.com/icons)
- 오디오 서비스: record & audioplayers 패키지

---

**영어 학습자를 위해 ❤️로 만들었습니다**
