import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:palm_ecommerce_app/models/params/profile_param.dart';
import 'package:palm_ecommerce_app/models/user/user.dart';
abstract class AuthenticationRepository {
  Future<Users> signIn(String email, String password);
  Future<Users> signUp(String name, String email, String phone, String password,
      String confirmPassword);
  Future<void> signOut();
  Future<void> sendOTP();
  Future<void> changePassword(
      String oldPassword, String newPassword, String confirmPassword);
  Future<void> verifyOTP(String otp, String phone);
  Future<Users> getUserInfo();
  Future<String> getCurrentToken();
  Future<void> saveToken(String token);
  Future<void> googleSignIn(String accessToken);
  Future<GoogleSignInAccount?> signInWithGoogle();
  Future<GoogleSignInAuthentication> getGoogleAuth(
      GoogleSignInAccount googleUser);
  AuthCredential getGoogleCredential(GoogleSignInAuthentication googleAuth);
  Future<UserCredential> signInWithGoogleCredential(AuthCredential credential);
  Future<DocumentSnapshot> getUserData(String uid);
  Future<void> saveUserToFirestore(Users user);
  Future<void> updateUserProfile(ProfileParams  params, );
}
