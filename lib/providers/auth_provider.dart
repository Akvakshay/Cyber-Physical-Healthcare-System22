import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_repository.dart';
import 'view_state.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  ViewState<UserModel> _state = const ViewState.initial();
  ViewState<UserModel> get state => _state;

  UserModel? get currentUser => _state.data;
  bool get isAuthenticated => currentUser != null;

  ViewState<void> _resetState = const ViewState.initial();
  ViewState<void> get resetState => _resetState;

  Future<void> login(String usernameOrPhone, String password) async {
    _state = const ViewState.loading();
    notifyListeners();
    try {
      final user = await _repository.login(
        usernameOrPhone: usernameOrPhone,
        password: password,
      );
      _state = ViewState.success(user);
    } catch (e) {
      _state = ViewState.error(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    _state = const ViewState.loading();
    notifyListeners();
    try {
      final user = await _repository.signUp(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );
      _state = ViewState.success(user);
    } catch (e) {
      _state = ViewState.error(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }

  Future<void> sendPasswordReset(String contact) async {
    _resetState = const ViewState.loading();
    notifyListeners();
    try {
      await _repository.sendPasswordReset(contact: contact);
      _resetState = const ViewState.success(null);
    } catch (e) {
      _resetState =
          ViewState.error(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }

  void logout() {
    _state = const ViewState.initial();
    notifyListeners();
  }
}
