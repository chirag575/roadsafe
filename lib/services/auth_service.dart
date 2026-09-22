import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential?> signInWithEmail(
    String email,
    String password,
  ) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty) {
      throw const AuthException('Please enter your Gmail/email.');
    }

    if (trimmedPassword.isEmpty) {
      throw const AuthException('Please enter your password.');
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmedEmail)) {
      throw const AuthException('Please enter a valid email address.');
    }

    return _auth.signInWithEmailAndPassword(
      email: trimmedEmail,
      password: trimmedPassword,
    );
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      throw const AuthException('Please enter your email address first.');
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmedEmail)) {
      throw const AuthException('Please enter a valid email address.');
    }

    await _auth.sendPasswordResetEmail(email: trimmedEmail);
  }

  static Future<UserCredential> createAccount(
    String email,
    String password,
  ) async {
    final trimmedEmail = email.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmedEmail)) {
      throw const AuthException('Please enter a valid email address.');
    }
    if (password.isEmpty) {
      throw const AuthException('Please enter your password.');
    }
    return _auth.createUserWithEmailAndPassword(
      email: trimmedEmail,
      password: password,
    );
  }

  static String getFriendlyMessage(String? code, {String? message}) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
      case 'email-not-found':
      case 'account-exists-with-different-credential':
        return 'Gmail/email is incorrect or account does not exist.';
      case 'wrong-password':
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Wrong password. Please try again.';
      case 'invalid-credential':
        return 'Gmail/email is incorrect or account does not exist.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase.';
      case 'email-already-in-use':
        return 'An account already exists for this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'expired-action-code':
        return 'This password reset link has expired. Request a new one.';
      case 'invalid-action-code':
        return 'This password reset link is invalid. Request a new one.';
      case 'missing-email':
        return 'Please enter your email address.';
      case 'app-not-authorized':
        return 'This app is not authorized for the Firebase project.';
      case 'no-app':
      case 'core/no-app':
        return 'Firebase is not configured. Add the Firebase Android configuration and try again.';
      default:
        if (message != null && message.trim().isNotEmpty) {
          return message.trim();
        }
        return 'Firebase authentication failed ($code). Please try again.';
    }
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
