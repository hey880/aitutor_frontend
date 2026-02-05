import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// API Service for LingoDash backend communication.
/// Handles authentication, session management, and all API calls.
class ApiService {
  // Base URL for API calls
  // Android emulator uses 10.0.2.2 to access host machine's localhost
  // iOS simulator uses localhost directly
  // TODO: Add platform detection for iOS support
  // static const String _baseUrl = 'http://10.0.2.2:8000/api';
  static const String _baseUrl = 'http://localhost:8000/api';

  // Keys for SharedPreferences
  static const String _tokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _oauthDataKey = 'pending_oauth_data';
  static const String _onboardingLevelKey = 'onboarding_level';

  /// Get the appropriate base URL based on platform
  static String get baseUrl => _baseUrl; // TODO: detect platform

  // ===========================================================================
  // TOKEN MANAGEMENT
  // ===========================================================================

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setInt(_userIdKey, userId);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
  }

  // ===========================================================================
  // PENDING OAUTH DATA (for onboarding flow)
  // ===========================================================================

  /// Store OAuth data temporarily while user completes onboarding
  static Future<void> savePendingOAuthData({
    required String provider,
    required String oauthId,
    required String idToken,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'provider': provider,
      'oauth_id': oauthId,
      'id_token': idToken,
      'name': name,
      'email': email,
    });
    await prefs.setString(_oauthDataKey, data);
  }

  /// Retrieve pending OAuth data for registration
  static Future<Map<String, dynamic>?> getPendingOAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_oauthDataKey);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  /// Clear pending OAuth data after successful registration
  static Future<void> clearPendingOAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_oauthDataKey);
  }

  // ===========================================================================
  // ONBOARDING DATA (level selection during onboarding)
  // ===========================================================================

  /// Save selected level during onboarding (beginner, intermediate, advanced)
  static Future<void> saveOnboardingLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_onboardingLevelKey, level);
  }

  /// Get the selected level from onboarding
  static Future<String?> getOnboardingLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_onboardingLevelKey);
  }

  /// Clear onboarding level after registration
  static Future<void> clearOnboardingLevel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingLevelKey);
  }

  // ===========================================================================
  // AUTH API CALLS
  // ===========================================================================

  /// Try to login with OAuth credentials.
  /// Returns ApiResponse with success=true if user exists, success=false with status 404 if not.
  static Future<ApiResponse> login({
    required String provider,
    required String oauthId,
    required String idToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'oauth_provider': provider,
          'oauth_id': oauthId,
          'id_token': idToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          userId: data['user_id'],
        );
        return ApiResponse(success: true, data: data);
      } else if (response.statusCode == 404) {
        return ApiResponse(
          success: false,
          statusCode: 404,
          message: 'User not found',
        );
      } else {
        return ApiResponse(
          success: false,
          statusCode: response.statusCode,
          message: 'Login failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  /// Register a new user.
  /// Returns ApiResponse with success=true and status 201 if created,
  /// success=false with status 409 if user already exists.
  static Future<ApiResponse> register({
    required String provider,
    required String oauthId,
    required String idToken,
    required String name,
    required String email,
    required String level,
    String targetLanguage = 'en',
    String nativeLanguage = 'ko',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'oauth_provider': provider,
          'oauth_id': oauthId,
          'id_token': idToken,
          'name': name,
          'email': email,
          'level': level,
          'target_language': targetLanguage,
          'native_language': nativeLanguage,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          userId: data['user_id'],
        );
        await clearPendingOAuthData();
        await clearOnboardingLevel();
        return ApiResponse(success: true, statusCode: 201, data: data);
      } else if (response.statusCode == 409) {
        return ApiResponse(
          success: false,
          statusCode: 409,
          message: 'User already exists',
        );
      } else {
        final error = jsonDecode(response.body);
        return ApiResponse(
          success: false,
          statusCode: response.statusCode,
          message: error['detail'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  // ===========================================================================
  // HELPER METHODS
  // ===========================================================================

  /// Make authenticated GET request
  static Future<ApiResponse> get(String endpoint) async {
    try {
      final token = await getAccessToken();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: jsonDecode(response.body));
      } else {
        return ApiResponse(
          success: false,
          statusCode: response.statusCode,
          message: 'Request failed',
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: $e');
    }
  }

  /// Make authenticated POST request
  static Future<ApiResponse> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await getAccessToken();
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          statusCode: response.statusCode,
          data: response.body.isNotEmpty ? jsonDecode(response.body) : null,
        );
      } else {
        return ApiResponse(
          success: false,
          statusCode: response.statusCode,
          message: 'Request failed',
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: $e');
    }
  }
}

/// Standard API response wrapper
class ApiResponse {
  final bool success;
  final int? statusCode;
  final String? message;
  final dynamic data;

  ApiResponse({
    required this.success,
    this.statusCode,
    this.message,
    this.data,
  });
}
