import 'package:flutter_test/flutter_test.dart';
import 'package:roadsafe_ai/services/auth_service.dart';

void main() {
  group('Firebase auth message mapping', () {
    test('maps wrong password error to user-friendly message', () {
      expect(
        AuthService.getFriendlyMessage('wrong-password'),
        'Wrong password. Please try again.',
      );
    });

    test('maps user-not-found to email guidance', () {
      expect(
        AuthService.getFriendlyMessage('user-not-found'),
        'Gmail/email is incorrect or account does not exist.',
      );
    });

    test('maps invalid email to valid email guidance', () {
      expect(
        AuthService.getFriendlyMessage('invalid-email'),
        'Please enter a valid email address.',
      );
    });
  });
}
