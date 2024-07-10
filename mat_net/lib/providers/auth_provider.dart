import 'package:flutter/material.dart';
import 'package:mat_net/models/user_model.dart';
import 'package:mat_net/services/auth_service.dart';


class AuthProvider with ChangeNotifier {
  User? _user;
  final AuthService _authService = AuthService();

  User? get user => _user;

  Future<void> login(String username, String password) async {
    final token = await _authService.login(username, password);
    _user = await _authService.getUser();
    notifyListeners();
  }

  Future<void> register(String username, String password, String role) async {
    await _authService.register(username, password, role);
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> loadUser() async {
    _user = await _authService.getUser();
    notifyListeners();
  }
}