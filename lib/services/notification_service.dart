import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'api_service.dart';

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message received: ${message.messageId}');
}

/// Notification service for handling Firebase Cloud Messaging
class NotificationService {
  static final NotificationService instance = NotificationService._internal();

  factory NotificationService() {
    return instance;
  }

  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize Firebase Messaging and local notifications
  Future<void> init() async {
    if (_initialized) return;

    try {
      // Request notification permissions
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted notification permission');
      } else {
        print('User declined or has not accepted notification permission');
      }

      // Initialize local notifications
      await _initLocalNotifications();

      // Set up foreground notification handler
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle notification tap when app is in background/terminated
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a notification
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      // Get FCM token and register with backend
      await _registerFCMToken();

      _initialized = true;
      print('NotificationService initialized successfully');
    } catch (e) {
      print('Error initializing NotificationService: $e');
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'lingodash_calls',
      'LingoDash Call Notifications',
      description: 'Notifications for scheduled English practice calls',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Get FCM token and register with backend
  Future<void> _registerFCMToken() async {
    try {
      String? token = await _fcm.getToken();
      if (token != null) {
        print('FCM Token: $token');
        await ApiService.post('/users/fcm-token', {
          'fcm_token': token,
        });
        print('FCM token registered with backend');
      }

      // Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) async {
        print('FCM Token refreshed: $newToken');
        await ApiService.post('/users/fcm-token', {
          'fcm_token': newToken,
        });
      });
    } catch (e) {
      print('Error registering FCM token: $e');
    }
  }

  /// Handle foreground notification
  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.messageId}');
    _showLocalNotification(message);
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'lingodash_calls',
            'LingoDash Call Notifications',
            channelDescription:
                'Notifications for scheduled English practice calls',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          ),
        ),
        payload: message.data['route'],
      );
    }
  }

  /// Handle notification tap (when app is in background)
  void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.data}');
    String? route = message.data['route'];
    if (route != null) {
      print('Should navigate to: $route');
    }
  }

  /// Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('Local notification tapped: ${response.payload}');
    if (response.payload != null) {
      print('Should navigate to: ${response.payload}');
    }
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Get FCM token
  Future<String?> getToken() async {
    return await _fcm.getToken();
  }
}
