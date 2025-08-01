# Google Token Guide for Palm Restaurant App

This guide explains how to get and use Google tokens when users sign in via Google account.

## Overview

When a user signs in with Google, you can access two types of tokens:
- **Access Token**: Used to authenticate with your backend API
- **ID Token**: Used for additional verification and user identification

## Available Methods

### 1. Get Google Access Token
```dart
// Trigger Google sign-in and get access token
String? accessToken = await authProvider.getGoogleAccessToken();
```

### 2. Get Google ID Token
```dart
// Trigger Google sign-in and get ID token
String? idToken = await authProvider.getGoogleIdToken();
```

### 3. Get Current User's Tokens (if already signed in)
```dart
// Get tokens from current Google user without triggering sign-in
Map<String, String?> tokens = await authProvider.getCurrentGoogleUserTokens();
String? accessToken = tokens['accessToken'];
String? idToken = tokens['idToken'];
String? email = tokens['email'];
```

### 4. Refresh Google Tokens
```dart
// Refresh tokens for current user
Map<String, String?> refreshedTokens = await authProvider.refreshGoogleTokens();
```

## Usage Examples

### Example 1: Complete Google Sign-in with Token Extraction
```dart
Future<void> signInWithGoogleAndGetToken(BuildContext context) async {
  try {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    
    // Get Google access token
    final accessToken = await authProvider.getGoogleAccessToken();
    if (accessToken == null) {
      print('Failed to get Google access token');
      return;
    }
    
    // Use token to authenticate with your backend
    await authProvider.repository.googleSignIn(accessToken);
    
    // Get user info and navigate
    await authProvider.getUserInfo();
    Navigator.pushReplacementNamed(context, '/home');
    
  } catch (e) {
    print('Error: $e');
  }
}
```

### Example 2: Check if User is Signed in with Google
```dart
Future<bool> isGoogleUserSignedIn(BuildContext context) async {
  final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
  final tokens = await authProvider.getCurrentGoogleUserTokens();
  return tokens['accessToken'] != null;
}
```

### Example 3: Get Tokens for API Calls
```dart
Future<void> makeApiCallWithGoogleToken(BuildContext context) async {
  final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
  final tokens = await authProvider.getCurrentGoogleUserTokens();
  
  if (tokens['accessToken'] != null) {
    // Use the access token in your API headers
    final headers = {
      'Authorization': 'Bearer ${tokens['accessToken']}',
      'Content-Type': 'application/json',
    };
    
    // Make your API call here
    // await http.get('your-api-endpoint', headers: headers);
  }
}
```

## Modified Sign-in Flow

The `signInWithGoogle` method in `AuthenticationProvider` has been updated to:

1. **Extract Google tokens** from the authentication response
2. **Use the access token** to authenticate with your backend
3. **Store the backend token** for future API calls
4. **Cache user information** for offline access

## Token Types Explained

### Access Token
- **Purpose**: Authenticate with your backend API
- **Usage**: Send in Authorization header
- **Format**: `Bearer <access_token>`
- **Lifetime**: Usually 1 hour (Google automatically refreshes)

### ID Token
- **Purpose**: Verify user identity and get user info
- **Usage**: Decode to get user details (email, name, etc.)
- **Format**: JWT token
- **Lifetime**: Usually 1 hour

## Best Practices

1. **Always check for null tokens** before using them
2. **Handle token refresh** automatically (Google SDK does this)
3. **Store tokens securely** (the app already handles this)
4. **Use access tokens for API calls** to your backend
5. **Use ID tokens for user verification** when needed

## Error Handling

```dart
try {
  final accessToken = await authProvider.getGoogleAccessToken();
  if (accessToken == null) {
    // Handle case where user cancelled sign-in
    print('User cancelled Google sign-in');
    return;
  }
  // Use the token
} catch (e) {
  // Handle other errors
  print('Error getting Google token: $e');
}
```

## Debug Information

The authentication provider includes debug logging. You can see token information in the console:

```
🔐 AuthProvider: Google access token obtained: Yes
🔐 AuthProvider: Google ID token obtained: Yes
🔐 AuthProvider: Successfully signed in with Google token to backend
```

## Example Widget

See `lib/util/google_token_examples.dart` for a complete example widget that demonstrates all the token methods.

## Integration with Your Backend

Your backend should:
1. **Receive the Google access token** from the app
2. **Verify the token** with Google's servers
3. **Create or update user** in your database
4. **Return your app's JWT token** for future API calls

The `googleSignIn` method in your repository already handles this flow.