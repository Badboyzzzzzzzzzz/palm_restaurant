import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:palm_ecommerce_app/data/network/api_endpoints.dart';
import 'package:palm_ecommerce_app/data/network/fetchingdata.dart';
import 'package:palm_ecommerce_app/data/repository/authentication_repository.dart';
import 'package:palm_ecommerce_app/models/params/profile_param.dart';
import 'package:palm_ecommerce_app/models/user/user.dart';
import 'package:palm_ecommerce_app/util/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

class AuthenticationApiRepository extends AuthenticationRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _logger = Logger('AuthenticationApiRepository');
  static const _tokenKey = 'storeToken';
  String? _cachedToken;
  final _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  // Debug helper method
  void _debugLog(String message) {
    debugPrint('🔐 AuthRepository: $message');
  }

  // Debug method to check token state
  Future<Map<String, dynamic>> debugTokenState() async {
    _debugLog('Checking token state');

    final result = <String, dynamic>{};

    result['cachedToken'] = _cachedToken != null && _cachedToken!.isNotEmpty;
    result['cachedTokenValue'] = _cachedToken != null
        ? (_cachedToken!.length > 10
            ? '${_cachedToken!.substring(0, 10)}...'
            : _cachedToken)
        : null;
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString(_tokenKey);
      result['storedToken'] = storedToken != null && storedToken.isNotEmpty;
      result['storedTokenValue'] = storedToken != null
          ? (storedToken.length > 10
              ? '${storedToken.substring(0, 10)}...'
              : storedToken)
          : null;

      result['globalToken'] = token != null && token!.isNotEmpty;
      result['globalTokenValue'] = token != null
          ? (token!.length > 10 ? '${token!.substring(0, 10)}...' : token)
          : null;
      result['globalUseToken'] = usetoken != null && usetoken!.isNotEmpty;
      result['globalUseTokenValue'] = usetoken != null
          ? (usetoken!.length > 10
              ? '${usetoken!.substring(0, 10)}...'
              : usetoken)
          : null;
      result['isTokenFlag'] = isToken;
      _debugLog('Token state check complete:');
      _debugLog('- Cached token exists: ${result['cachedToken']}');
      _debugLog('- Stored token exists: ${result['storedToken']}');
      _debugLog('- Global token exists: ${result['globalToken']}');
      _debugLog('- Global usetoken exists: ${result['globalUseToken']}');
      _debugLog('- isToken flag: ${result['isTokenFlag']}');
      return result;
    } catch (e) {
      _debugLog('❌ Error checking token state: $e');
      result['error'] = e.toString();
      return result;
    }
  }

  @override
  Future<String> getCurrentToken() async {
    _debugLog('Getting current token');
    if (_cachedToken != null && _cachedToken!.isNotEmpty) {
      _debugLog('Returning cached token (length: ${_cachedToken!.length})');
      return _cachedToken!;
    }

    _debugLog('No cached token, checking SharedPreferences');
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey) ?? '';

    if (_cachedToken!.isEmpty) {
      _debugLog('❌ No token found in SharedPreferences');
    } else {
      _debugLog(
          '✅ Token retrieved from SharedPreferences (length: ${_cachedToken!.length})');
    }
    return _cachedToken!;
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      _debugLog('Saving token (length: ${token.length})');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      _cachedToken = token;
      _debugLog('✅ Token saved successfully');
    } catch (e) {
      _debugLog('❌ Error saving token: $e');
      _logger.warning('Error saving token: $e');
    }
  }

  Map<String, String> _getAuthHeaders(String token) {
    final cleanToken = token.replaceAll('"', '');
    _debugLog("Creating auth headers - original token length: ${token.length}");
    _debugLog(
        "Creating auth headers - cleaned token length: ${cleanToken.length}");

    return {
      ..._baseHeaders,
      'Authorization': 'Bearer $cleanToken',
    };
  }

  @override
  Future<Users> signIn(String email, String password) async {
    try {
      _debugLog('Attempting login with email: $email');
      final response = await FetchingData.postHeader(
        ApiConstant.login,
        _baseHeaders,
        {'email': email, 'password': password},
      );

      _debugLog('Login response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final data = responseBody['data'];
        final accessToken = responseBody['token'] ??
            (data is Map ? data['token'] ?? data['access_token'] ?? '' : '');

        if (accessToken == null || accessToken.isEmpty) {
          _debugLog('❌ Access token not found in response');
          _logger.severe('Access token not found in response: $responseBody');
          throw Exception('Access token not found in response');
        }

        _debugLog(
            '✅ Login successful, saving token (length: ${accessToken.length})');
        await saveToken(accessToken);
        _cachedToken = accessToken;
        token = accessToken;
        usetoken = accessToken.replaceAll('"', '');
        isToken = true;

        _logger.info('Login successful, token saved');
        return Users.fromJson(data ?? responseBody['user']);
      }

      throw _handleErrorResponse(response, 'Login');
    } catch (e) {
      _debugLog('❌ Login error: $e');
      _logger.severe('Login error: $e');
      rethrow;
    }
  }

  @override
  Future<Users> signUp(String name, String email, String phone, String password,
      String confirmPassword) async {
    try {
      final body = {
        'name': name,
        'email': email,
        'prefix': '855',
        'phone': phone,
        'password': password,
        'c_password': confirmPassword,
      };
      final response = await FetchingData.postHeader(
        ApiConstant.register,
        _baseHeaders,
        body,
      );
      _logger.info('Signup response status code: ${response.statusCode}');
      _logger.info('Signup response body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        return Users.fromJson(responseBody);
      }
      throw _handleErrorResponse(response, 'Registration');
    } catch (e) {
      _logger.severe('Signup error: $e');
      rethrow;
    }
  }

  @override
  Future<void> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    try {
      _logger.info('Attempting to change password');
      final token = await getCurrentToken();
      final body = {
        'old_password': oldPassword,
        'password': newPassword,
        'c_password': confirmPassword,
      };
      final response = await FetchingData.postHeader(
        ApiConstant.changePassword,
        _getAuthHeaders(token),
        body,
      );
      _logger
          .info('Change password response status code: ${response.statusCode}');
      _logger.info('Change password response body: ${response.body}');

      if (response.statusCode == 200) {
        _logger.info('Password changed successfully');
        return;
      }
      throw _handleErrorResponse(response, 'Change password');
    } catch (e) {
      _logger.severe('Change password error: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _logger.info('Attempting logout');
      _cachedToken = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (e) {
      _logger.severe('Logout error: $e');
      rethrow;
    }
  }

  @override
  Future<Users> getUserInfo() async {
    try {
      final token = await getCurrentToken();
      if (token.isEmpty) {
        throw Exception('No authentication token available');
      }
      final headers = _getAuthHeaders(token);
      final endpoint = ApiConstant.getUserInfo;
      final response = await FetchingData.getHeader(
        endpoint,
        headers,
      );
      if (response.body
          .contains("Access denied by Imunify360 bot-protection")) {
        throw Exception(
            'Server blocked request: Bot protection is active. Please contact the server administrator to whitelist your IP address.');
      }
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody == null) {
          throw Exception('Invalid response format: null response');
        }
        final userData = responseBody['data']?['user'] ?? responseBody['data'];

        if (userData == null) {
          throw Exception('Invalid response format: missing user data');
        }
        return Users.fromJson(userData);
      }
      throw _handleErrorResponse(response, 'User info');
    } catch (e) {
      _logger.severe('User info error: $e');
      rethrow;
    }
  }

  @override
  Future<void> sendOTP() async {
    try {
      _logger.info('Sending OTP to: $savePhone');
      if (savePhone.isEmpty) {
        throw Exception('Phone number is required to send OTP');
      }
      final token = await getCurrentToken();
      final body = {'phone': savePhone};
      final response = await FetchingData.postHeader(
        ApiConstant.sendOtp,
        _getAuthHeaders(token),
        body,
      );
      _logger.info('Send OTP response status code: ${response.statusCode}');
      _logger.info('Send OTP response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw _handleErrorResponse(response, 'OTP sending');
      }
      _logger.info('OTP sent successfully');
    } catch (e) {
      _logger.severe('Send OTP error: $e');
      rethrow;
    }
  }

  Exception _handleErrorResponse(dynamic response, String operation) {
    String errorMessage = '$operation failed';
    try {
      final error = json.decode(response.body);
      if (error['errors'] != null) {
        final errors = error['errors'];
        final errorMessages = <String>[];
        if (errors is Map<String, dynamic>) {
          errors.forEach((_, value) {
            if (value is List) {
              errorMessages.addAll(value.cast<String>());
            } else {
              errorMessages.add(value.toString());
            }
          });
        } else if (errors is List) {
          errorMessages.addAll(errors.map((e) => e.toString()));
        } else {
          errorMessages.add(errors.toString());
        }
        errorMessage = errorMessages.join(', ');
      } else if (error['message'] != null) {
        errorMessage = error['message'].toString();
      } else if (error['error'] != null) {
        errorMessage = error['error'].toString();
      } else {
        errorMessage = '$operation failed with status ${response.statusCode}';
      }
      _logger.warning('$operation error: $errorMessage');
    } catch (e) {
      errorMessage =
          '$operation failed with status ${response.statusCode}: ${response.body}';
      _logger.severe('Error parsing error response: $e');
    }
    return Exception(errorMessage);
  }

  @override
  Future<void> googleSignIn(String token) async {
    try {
      _logger.info(
          'Attempting Google sign in with token type: ${token.startsWith('ya29') ? 'access_token' : 'id_token'}');
      _logger.info('Token length: ${token.length}');
      _logger.info('Token prefix: ${token.substring(0, 20)}...');

      final response = await FetchingData.postHeader(
        ApiConstant.googleSignIn,
        _baseHeaders,
        {
          'social_type': 'google',
          'token': token,
        },
      );

      _logger.info('Google sign in response: ${response.statusCode}');
      _logger.info('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        _logger.info('Parsed response: $responseBody');

        final data = responseBody['data'];
        final accessToken = responseBody['token'] ??
            (data is Map ? data['token'] ?? data['access_token'] ?? '' : '');

        if (accessToken == null || accessToken.isEmpty) {
          _logger.severe('No backend token in response: $responseBody');
          throw Exception(
              'Authentication failed: No token received from server');
        }

        await saveToken(accessToken);
        _cachedToken = accessToken;
        token = accessToken;
        usetoken = accessToken.replaceAll('"', '');
        isToken = true;

        _logger.info('Google sign in successful');
        return;
      }

      // Handle specific error cases
      if (response.statusCode == 400) {
        final responseBody = json.decode(response.body);
        String errorMessage =
            responseBody['message'] ?? 'Invalid Google token format';
        throw Exception('Bad request: $errorMessage');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid Google token. Please try signing in again.');
      } else if (response.statusCode == 403) {
        throw Exception(
            'Access denied. Please check your Google account permissions.');
      } else if (response.statusCode == 422) {
        final responseBody = json.decode(response.body);
        String errorMessage =
            responseBody['message'] ?? 'Token validation failed';
        throw Exception('Token validation error: $errorMessage');
      }

      throw _handleErrorResponse(response, 'Google sign in');
    } catch (e) {
      _logger.severe('Google sign in error: $e');
      if (e.toString().contains('Send Wrong Token')) {
        throw Exception(
            'Invalid token format. Please try signing out of Google and signing in again.');
      }
      rethrow;
    }
  }

  @override
  Future<void> verifyOTP(String otp, String phone) async {
    try {
      _logger.info('Attempting OTP verification for phone: $phone');
      final body = {'verify_code': otp, 'phone': phone};
      _logger.info('OTP verification request body: $body');
      _logger.info('OTP verification endpoint: ${ApiConstant.verifyOtp}');
      final response = await FetchingData.postHeader(
        ApiConstant.verifyOtp,
        _baseHeaders,
        body,
      );
      _logger.info(
          'OTP verification response status code: ${response.statusCode}');
      _logger.info('OTP verification response body: ${response.body}');
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final data = responseBody['data'];
        final accessToken = responseBody['token'] ??
            (data is Map ? data['token'] ?? data['access_token'] ?? '' : '');
        if (accessToken == null || accessToken.isEmpty) {
          _logger.severe('Access token not found in response: $responseBody');
          throw Exception('Access token not found in response');
        }
        await saveToken(accessToken);
        _cachedToken = accessToken;
        token = accessToken;
        usetoken = accessToken.replaceAll('"', '');
        isToken = true;
        _logger.info('OTP verification successful, token saved');
        return;
      }
      throw _handleErrorResponse(response, 'OTP verification');
    } catch (e) {
      _logger.severe('OTP verification error: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveUserToFirestore(Users user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson());
  }

  @override
  Future<GoogleSignInAuthentication> getGoogleAuth(
      GoogleSignInAccount googleUser) async {
    return await googleUser.authentication;
  }

  @override
  AuthCredential getGoogleCredential(GoogleSignInAuthentication googleAuth) {
    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  @override
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    return await GoogleSignIn().signIn();
  }

  @override
  Future<UserCredential> signInWithGoogleCredential(
      AuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }

  @override
  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  @override
  Future<void> updateUserProfile(ProfileParams params) async {
    try {
      _logger.info('Updating user profile');
      final token = await getCurrentToken();
      if (token.isEmpty) {
        throw Exception('No authentication token available');
      }

      http.Response response;

      // Check if we need to handle file upload
      if (params.hasProfilePhotoUpdate()) {
        _logger.info('Profile update includes photo upload');

        // Create multipart request for file upload
        var baseUrl = FetchingData.baseUrl
            .replaceAll('https://', '')
            .replaceAll('http://', '');
        var url = Uri.https(baseUrl, ApiConstant.updateProfile);
        var request = http.MultipartRequest('POST', url);
        // Add auth headers (strip content-type as it's set by multipart)
        var headers = _getAuthHeaders(token);
        headers.remove('Content-Type'); // Remove content-type for multipart
        request.headers.addAll(headers);
        // Add the profile photo file
        _logger
            .info('Adding profile photo from: ${params.profile_photo!.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'profile_photo', // Field name expected by the server
          params.profile_photo!.path,
        ));

        // Add all other fields from params
        var jsonData = params.toJson();
        jsonData.forEach((key, value) {
          _logger.info('Adding form field: $key = $value');
          request.fields[key] = value.toString();
        });

        // Send the multipart request
        _logger.info('Sending multipart request to: $url');
        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        // Use regular request if no file to upload
        _logger.info('Profile update without photo upload');
        response = await FetchingData.postHeader(
          ApiConstant.updateProfile,
          _getAuthHeaders(token),
          params.toJson(),
        );
      }

      _logger
          .info('Update profile response status code: ${response.statusCode}');
      _logger.info('Update profile response body: ${response.body}');

      if (response.statusCode == 200) {
        _logger.info('Profile updated successfully');
      } else {
        throw _handleErrorResponse(response, 'Update profile');
      }
    } catch (e) {
      _logger.severe('Error updating profile: $e');
      throw Exception(e);
    }
  }
}
