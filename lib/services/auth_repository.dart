import '../models/user_model.dart';

/// Simulates a backend auth API. Swap this implementation for real HTTP
/// calls (e.g. via `dio` or `http`) without touching any UI code.
class AuthRepository {
  Future<UserModel> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (usernameOrPhone.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Please enter both your username/phone and password.');
    }
    if (password.length < 4) {
      throw Exception('Incorrect username or password. Please try again.');
    }

    return UserModel(
      id: 'user_001',
      name: 'Riya Sharma',
      usernameOrPhone: usernameOrPhone,
      email: '$usernameOrPhone@example.com',
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<UserModel> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (name.trim().isEmpty || phone.trim().isEmpty || password.length < 4) {
      throw Exception('Please fill all fields with a valid password.');
    }

    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      usernameOrPhone: phone,
      email: email,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<void> sendPasswordReset({required String contact}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (contact.trim().isEmpty) {
      throw Exception('Enter the phone number or email linked to your account.');
    }
  }
}
