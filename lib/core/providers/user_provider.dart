import 'package:flutter/material.dart';
import 'package:learning_management_system/core/constants/globals.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/core/service/user_service.dart';
import 'package:learning_management_system/features/user/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  final UserService _userService;

  UserProvider() : _userService = UserService(ApiService());

  /// ---------------- LOGIN ----------------
  Future<void> login(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _userService.getUser(email);
      // Set the global email controller for API calls
      loginEmailController.text = email;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ---------------- SIGN UP ----------------
  Future<void> signup({required String email, required String username}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _userService.createUser(email: email, username: username);
      // Set the global email controller for API calls
      loginEmailController.text = email;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ---------------- UPDATE USERNAME ----------------
  Future<void> updateUsername(String username) async {
    if (_user == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = await _userService.updateUsername(
        _user!.email,
        username,
      );
      _user = updatedUser;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ---------------- LOGOUT ----------------
  void logout() {
    _user = null;
    notifyListeners();
  }
}
