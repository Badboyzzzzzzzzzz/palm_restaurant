import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:palm_ecommerce_app/ui/provider/authentication_provider.dart';

/// Example class demonstrating how to get Google tokens
class GoogleTokenExamples {
  /// Example 1: Get Google tokens when user signs in
  static Future<void> getTokensOnSignIn(BuildContext context) async {
    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);

      // This will trigger Google sign-in and return tokens
      final accessToken = await authProvider.getGoogleAccessToken();
      final idToken = await authProvider.getGoogleIdToken();

      if (accessToken != null) {
        print('✅ Google Access Token: $accessToken');
        // Use this token to authenticate with your backend
        // await authProvider.repository.googleSignIn(accessToken);
      }

      if (idToken != null) {
        print('✅ Google ID Token: $idToken');
        // Use this token for additional verification if needed
      }
    } catch (e) {
      print('❌ Error getting Google tokens: $e');
    }
  }

  /// Example 2: Get tokens from current user (if already signed in)
  static Future<Map<String, String?>> getCurrentUserTokens(
      BuildContext context) async {
    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);

      final tokens = await authProvider.getCurrentGoogleUserTokens();

      if (tokens['accessToken'] != null) {
        print('✅ Current user access token: ${tokens['accessToken']}');
        print('✅ Current user email: ${tokens['email']}');
      } else {
        print('ℹ️ No current Google user found');
      }

      return tokens;
    } catch (e) {
      print('❌ Error getting current user tokens: $e');
      return {
        'accessToken': null,
        'idToken': null,
        'email': null,
      };
    }
  }

  /// Example 3: Refresh Google tokens
  static Future<Map<String, String?>> refreshTokens(
      BuildContext context) async {
    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);

      final refreshedTokens = await authProvider.refreshGoogleTokens();

      if (refreshedTokens['accessToken'] != null) {
        print('✅ Tokens refreshed successfully');
        print('✅ New access token: ${refreshedTokens['accessToken']}');
      } else {
        print('ℹ️ No tokens to refresh');
      }

      return refreshedTokens;
    } catch (e) {
      print('❌ Error refreshing tokens: $e');
      return {
        'accessToken': null,
        'idToken': null,
        'email': null,
      };
    }
  }

  /// Example 4: Complete Google sign-in with token extraction
  static Future<void> completeGoogleSignInWithTokens(
      BuildContext context) async {
    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);

      // Step 1: Get Google tokens
      final accessToken = await authProvider.getGoogleAccessToken();
      if (accessToken == null) {
        print('❌ Failed to get Google access token');
        return;
      }

      print(
          '✅ Google access token obtained: ${accessToken.substring(0, 20)}...');

      // Step 2: Use token to authenticate with your backend
      await authProvider.repository.googleSignIn(accessToken);
      print('✅ Successfully authenticated with backend using Google token');

      // Step 3: Get user info and navigate
      await authProvider.getUserInfo();
      print('✅ User info retrieved successfully');

      // Step 4: Navigate to main screen
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('❌ Error in complete Google sign-in: $e');
    }
  }

  /// Example 5: Check if user is signed in with Google and get tokens
  static Future<bool> isGoogleUserSignedIn(BuildContext context) async {
    try {
      final tokens = await getCurrentUserTokens(context);
      return tokens['accessToken'] != null;
    } catch (e) {
      print('❌ Error checking Google sign-in status: $e');
      return false;
    }
  }

  /// Example 6: Sign out from Google
  static Future<void> signOutFromGoogle(BuildContext context) async {
    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);

      // Sign out from your app
      await authProvider.signOut();

      // Sign out from Google
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      print('✅ Successfully signed out from Google and app');
    } catch (e) {
      print('❌ Error signing out: $e');
    }
  }
}

/// Widget example showing how to use Google tokens in UI
class GoogleTokenExampleWidget extends StatefulWidget {
  const GoogleTokenExampleWidget({Key? key}) : super(key: key);

  @override
  State<GoogleTokenExampleWidget> createState() =>
      _GoogleTokenExampleWidgetState();
}

class _GoogleTokenExampleWidgetState extends State<GoogleTokenExampleWidget> {
  String _tokenInfo = 'No tokens available';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _isLoading ? null : () => _getTokens(),
          child: Text(_isLoading ? 'Loading...' : 'Get Google Tokens'),
        ),
        const SizedBox(height: 16),
        Text(_tokenInfo),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : () => _refreshTokens(),
          child: const Text('Refresh Tokens'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : () => _checkSignInStatus(),
          child: const Text('Check Sign-in Status'),
        ),
      ],
    );
  }

  Future<void> _getTokens() async {
    setState(() => _isLoading = true);

    try {
      final tokens = await GoogleTokenExamples.getCurrentUserTokens(context);

      if (tokens['accessToken'] != null) {
        setState(() {
          _tokenInfo =
              'Access Token: ${tokens['accessToken']!.substring(0, 20)}...\n'
              'Email: ${tokens['email']}';
        });
      } else {
        setState(() {
          _tokenInfo = 'No Google user signed in';
        });
      }
    } catch (e) {
      setState(() {
        _tokenInfo = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshTokens() async {
    setState(() => _isLoading = true);

    try {
      final tokens = await GoogleTokenExamples.refreshTokens(context);

      if (tokens['accessToken'] != null) {
        setState(() {
          _tokenInfo = 'Tokens refreshed!\n'
              'Access Token: ${tokens['accessToken']!.substring(0, 20)}...';
        });
      } else {
        setState(() {
          _tokenInfo = 'No tokens to refresh';
        });
      }
    } catch (e) {
      setState(() {
        _tokenInfo = 'Error refreshing: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkSignInStatus() async {
    setState(() => _isLoading = true);

    try {
      final isSignedIn =
          await GoogleTokenExamples.isGoogleUserSignedIn(context);

      setState(() {
        _tokenInfo = isSignedIn
            ? '✅ Google user is signed in'
            : '❌ No Google user signed in';
      });
    } catch (e) {
      setState(() {
        _tokenInfo = 'Error checking status: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
