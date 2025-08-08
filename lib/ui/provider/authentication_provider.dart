// ignore_for_file: use_build_context_synchr
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:palm_ecommerce_app/data/repository/authentication_repository.dart';
import 'package:palm_ecommerce_app/models/params/profile_param.dart';
import 'package:palm_ecommerce_app/models/user/user.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticationRepository repository;
  AuthenticationProvider({required this.repository});
  AsyncValue<Users?> _user = AsyncValue.empty();
  String? _token;
  String? _error;
  Users? _userInfo;
  final bool _isDebugMode = true;

  String? get token => _token;
  String? get error => _error;
  AsyncValue<Users?> get user => _user;
  Users? get userInfo => _userInfo;
  bool get isAuthenticated => _token != null;

  // Debug log helper
  void _debugLog(String message) {
    if (_isDebugMode) {
      print('🔐 AuthProvider: $message');
    }
  }

  Future<void> _cacheUserInfo(Users userInfo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = userInfo.toJson();
      await prefs.setString('cached_user_info', jsonEncode(userJson));
      _debugLog('User info cached successfully');
    } catch (e) {
      _debugLog('Error caching user info: $e');
    }
  }

  Future<Users?> _loadCachedUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedUserJson = prefs.getString('cached_user_info');

      if (cachedUserJson != null) {
        _debugLog('Found cached user info, deserializing...');
        final userMap = jsonDecode(cachedUserJson);
        return Users.fromJson(userMap);
      }
      _debugLog('No cached user info found');
      return null;
    } catch (e) {
      _debugLog('Error loading cached user info: $e');
      return null;
    }
  }

  Future<bool> signIn(String email, String password,
      {bool rememberMe = false}) async {
    try {
      _debugLog('Attempting sign in for email: $email');
      await repository.signIn(email, password);
      _debugLog('Sign in successful, fetching user info');
      await getUserInfo();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _debugLog('Sign in failed: $_error');
      notifyListeners();
      return false;
    }
  }

  Future<void> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    try {
      _debugLog('Attempting to change password');
      await repository.changePassword(
          oldPassword, newPassword, confirmPassword);
      _error = null;
      _debugLog('Password changed successfully');
      // Optionally, you can refresh user info or token here
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _debugLog('Password change failed: $_error');
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> signUp(String name, String email, String phone, String password,
      String confirmPassword) async {
    try {
      _debugLog('Attempting sign up for email: $email');
      await repository.signUp(name, email, phone, password, confirmPassword);
      _debugLog('Sign up successful');
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _debugLog('Sign up failed: $_error');
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _debugLog('Signing out user');
      await repository.signOut();
      _token = null;
      _userInfo = null;
      _user = AsyncValue.empty();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_user_info');
      _debugLog('Sign out complete, cache cleared');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _debugLog('Sign out failed: $_error');
      notifyListeners();
    }
  }

  Future<void> getUserInfo() async {
    try {
      _user = AsyncValue.loading();
      notifyListeners();
      final userInfo = await repository.getUserInfo();
      _debugLog('User info retrieved successfully: ${userInfo.toJson()}');
      _userInfo = userInfo;
      await _cacheUserInfo(_userInfo!);

      // Ensure language settings are initialized
      try {
        final prefs = await SharedPreferences.getInstance();
        // Check if language is set in SharedPreferences
        final savedLanguage = prefs.getString('selected_language');
        if (savedLanguage == null || savedLanguage.isEmpty) {
          _debugLog('No language preference found, setting default language');
          // Set default language (English or based on user's settings)
          await prefs.setString('selected_language', 'en');
        } else {
          _debugLog('Found language preference: $savedLanguage');
        }
      } catch (e) {
        _debugLog('Error checking language settings: $e');
      }
      _user = AsyncValue.success(_userInfo);
      notifyListeners();
    } catch (e) {
      _debugLog('Error getting user info: $e');
      _user = AsyncValue.error(e);
      notifyListeners();
    }
  }

  Future<void> debugUserParsing(Map<String, dynamic> rawApiResponse) async {
    try {
      _debugLog('Testing user parsing with raw data');
      _debugLog('Raw API response: $rawApiResponse');
      final userData =
          rawApiResponse['data']?['user'] ?? rawApiResponse['data'];
      _debugLog('Extracted user data: $userData');
      if (userData != null) {
        final testUser = Users.fromJson(userData);
        _debugLog('Parsed user: ${testUser.toJson()}');
        _debugLog('User ID: ${testUser.id}');
        _debugLog('User name: ${testUser.name}');
        _debugLog('User email: ${testUser.email}');
        _debugLog('User phone: ${testUser.phone}');
      } else {
        _debugLog('User data is null, cannot parse');
      }
    } catch (e) {
      _debugLog('Error parsing user: $e');
    }
  }

  Future<void> initializeCurrentUser() async {
    try {
      _debugLog('Initializing current user');
      _token = await repository.getCurrentToken();
      _debugLog('Current token: ${_token != null ? "Found" : "Not found"}');
      try {
        final prefs = await SharedPreferences.getInstance();
        final savedLanguage = prefs.getString('selected_language');
        if (savedLanguage == null || savedLanguage.isEmpty) {
          _debugLog(
              'No language preference found during initialization, setting default');
          await prefs.setString('selected_language', 'en');
        } else {
          _debugLog('Language already set: $savedLanguage');
        }
      } catch (e) {
        _debugLog('Error checking language settings: $e');
      }
      if (_token != null) {
        final cachedUser = await _loadCachedUserInfo();
        if (cachedUser != null) {
          _debugLog('Using cached user info: ${cachedUser.toJson()}');
          _userInfo = cachedUser;
          _user = AsyncValue.success(cachedUser);
          notifyListeners();
        } else {
          _debugLog('No cached user found, loading from network');
          _user = AsyncValue.loading();
          notifyListeners();
        }
        try {
          _debugLog('Refreshing user info from server');
          final userInfo = await repository.getUserInfo();
          _debugLog('Fresh user info retrieved: ${userInfo.toJson()}');
          _userInfo = userInfo;
          await _cacheUserInfo(userInfo);
          _user = AsyncValue.success(userInfo);
        } catch (e) {
          _debugLog("Error refreshing user data: $e");
          if (cachedUser != null) {
            if (e.toString().contains("bot protection")) {
              _error =
                  "Using cached profile data. Server security is blocking API requests.";
              _debugLog("Bot protection detected, using cached data");
            } else {
              _error = "Using cached data. Couldn't refresh: ${e.toString()}";
              _debugLog("Using cached data due to refresh error");
            }
          } else {
            _debugLog("No cached data available, showing error");
            _user = AsyncValue.error(e);
          }
        }
      } else {
        _debugLog('No token found, user not authenticated');
        _user = AsyncValue.empty();
        _userInfo = null;
      }
      notifyListeners();
    } catch (e) {
      _debugLog("Error initializing user: $e");
      _error = e.toString();
      _user = AsyncValue.error(e);
      notifyListeners();
    }
  }

  Future<String?> getUserToken() async {
    final token = await repository.getCurrentToken();
    _debugLog('Retrieved user token: $token');
    return token;
  }

  Future<void> sendOTP() async {
    _debugLog('Sending OTP');
    await repository.sendOTP();
    _debugLog('OTP sent successfully');
    notifyListeners();
  }

  Future<void> verifyOTP(String otp, String phone) async {
    try {
      _debugLog('Verifying OTP for phone: $phone with code: $otp');
      await repository.verifyOTP(otp, phone);
      _debugLog('OTP verification completed successfully');
      try {
        await getUserInfo();
      } catch (e) {
        _debugLog('Error getting user info after OTP verification: $e');
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _debugLog('OTP verification failed: $_error');
      rethrow;
    }
  }

  void debugAuthState() {
    _debugLog('--- Auth State Debug ---');
    _debugLog('Token exists: ${_token != null}');
    _debugLog('User info exists: ${_userInfo != null}');
    if (_userInfo != null) {
      _debugLog('User details: ${_userInfo!.toJson()}');
    }
    _debugLog('Auth state: ${_user.toString()}');
    _debugLog('Error state: $_error');
    _debugLog('----------------------');
  }

  Future<void> googleLogin() async {
    await repository.signInWithGoogle();
    notifyListeners();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      _debugLog('Starting Google Sign In process');
      final GoogleSignInAccount? googleUser =
          await repository.signInWithGoogle();

      if (googleUser == null) {
        _debugLog('Google Sign In was cancelled by user');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await repository.getGoogleAuth(googleUser);
      final String? googleAccessToken = googleAuth.accessToken;
      final String? googleIdToken = googleAuth.idToken;

      _debugLog(
          'Google Access Token: ${googleAccessToken != null ? "Available" : "Not available"}');
      _debugLog(
          'Google ID Token: ${googleIdToken != null ? "Available" : "Not available"}');

      // Try access token first as it's more commonly used by backends
      String? tokenForBackend = googleAccessToken;
      if (tokenForBackend == null || tokenForBackend.isEmpty) {
        tokenForBackend = googleIdToken;
      }

      if (tokenForBackend == null || tokenForBackend.isEmpty) {
        throw Exception('Failed to get Google tokens');
      }

      _debugLog(
          'Using token type: ${tokenForBackend.startsWith('ya29') ? "access_token" : "id_token"}');
      _debugLog(
          'Token for backend (first 20 chars): ${tokenForBackend.substring(0, 20)}...');

      // Send token to backend
      await repository.googleSignIn(tokenForBackend);

      // Get user info after successful authentication
      await getUserInfo();

      _debugLog('Google Sign In completed successfully');
    } catch (e) {
      _debugLog('Google Sign In failed: $e');
      rethrow;
    }
  }

  // Method to get Google access token specifically
  Future<String?> getGoogleAccessToken() async {
    try {
      _debugLog('Getting Google access token');
      final GoogleSignInAccount? googleUser =
          await repository.signInWithGoogle();

      if (googleUser == null) {
        _debugLog('Google Sign In was cancelled');
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await repository.getGoogleAuth(googleUser);

      final String? accessToken = googleAuth.accessToken;
      _debugLog(
          'Google access token: ${accessToken != null ? "Obtained" : "Not available"}');
      return accessToken;
    } catch (e) {
      _debugLog('Error getting Google access token: $e');
      return null;
    }
  }

  // Method to get Google ID token specifically
  Future<String?> getGoogleIdToken() async {
    try {
      _debugLog('Getting Google ID token');
      final GoogleSignInAccount? googleUser =
          await repository.signInWithGoogle();
      if (googleUser == null) {
        _debugLog('Google Sign In was cancelled');
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await repository.getGoogleAuth(googleUser);

      final String? idToken = googleAuth.idToken;
      _debugLog(
          'Google ID token: ${idToken != null ? "Obtained" : "Not available"}');

      return idToken;
    } catch (e) {
      _debugLog('Error getting Google ID token: $e');
      return null;
    }
  }

  // Method to get current Google user's token (if already signed in)
  Future<Map<String, String?>> getCurrentGoogleUserTokens() async {
    try {
      _debugLog('Getting current Google user tokens');

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? currentUser = googleSignIn.currentUser;

      if (currentUser == null) {
        _debugLog('No current Google user found');
        return {
          'accessToken': null,
          'idToken': null,
          'email': null,
        };
      }
      _debugLog('Current Google user found: ${currentUser.email}');
      final GoogleSignInAuthentication auth = await currentUser.authentication;
      _debugLog(
          'Current user access token: ${auth.accessToken != null ? "Available" : "Not available"}');
      _debugLog(
          'Current user ID token: ${auth.idToken != null ? "Available" : "Not available"}');

      return {
        'accessToken': auth.accessToken,
        'idToken': auth.idToken,
        'email': currentUser.email,
      };
    } catch (e) {
      _debugLog('Error getting current Google user tokens: $e');
      return {
        'accessToken': null,
        'idToken': null,
        'email': null,
      };
    }
  }

  // Method to refresh Google tokens
  Future<Map<String, String?>> refreshGoogleTokens() async {
    try {
      _debugLog('Refreshing Google tokens');
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? currentUser = googleSignIn.currentUser;
      if (currentUser == null) {
        _debugLog('No current Google user to refresh tokens for');
        return {
          'accessToken': null,
          'idToken': null,
          'email': null,
        };
      }
      _debugLog('Refreshing tokens for user: ${currentUser.email}');
      // Force token refresh
      final GoogleSignInAuthentication auth = await currentUser.authentication;
      _debugLog('Tokens refreshed successfully');
      return {
        'accessToken': auth.accessToken,
        'idToken': auth.idToken,
        'email': currentUser.email,
      };
    } catch (e) {
      _debugLog('Error refreshing Google tokens: $e');
      return {
        'accessToken': null,
        'idToken': null,
        'email': null,
      };
    }
  }

  Future<void> clearGoogleSignInCache() async {
    try {
      _debugLog('Clearing Google Sign-In cache');
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await googleSignIn.disconnect();
      _debugLog('Google Sign-In cache cleared');
    } catch (e) {
      _debugLog('Error clearing Google Sign-In cache: $e');
    }
  }

  Future<void> updateUserProfile(ProfileParams params) async {
    try {
      await repository.updateUserProfile(params);
      _debugLog('User profile updated successfully');
      await getUserInfo();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _debugLog('Error updating user profile: $_error');
      notifyListeners();
    }
  }
}
