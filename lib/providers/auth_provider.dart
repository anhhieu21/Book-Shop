import 'package:bookshop/models/user_model.dart';
import 'package:bookshop/screens/admin/main_screens.dart';
import 'package:bookshop/screens/signin_screens.dart';
import 'package:bookshop/screens/student/main_screens.dart';
import 'package:bookshop/service/dio_client.dart';
import 'package:bookshop/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final _repository = UserService();

  bool get isAuthenticated => _authenticated;
  bool _authenticated = false;
  User? user;

  Future<bool> checkAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) {
        Get.offAll(() => SignInScreen());
        return false;
      }
      dioClient.setToken(token);
      _authenticated = true;
      user = await _repository.getUserInfo();
      if (user == null) {
        Get.offAll(() => SignInScreen());
        return false;
      }

      if (user!.role == 'student') {
        Get.offAll(() => const MainScreens());
      } else {
        Get.offAll(() => const AdminMainScreens());
      }
      notifyListeners();
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    required String atClass,
  }) async {
    final res =
        await _repository.register(email, name, password, role, atClass);
    notifyListeners();
    return res;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final res = await _repository.login(email, password);
    _authenticated = res;
    // Get user info
    user = await _repository.getUserInfo();
    if (user != null) {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove('accessToken');
    pref.remove('refreshToken');
    return false;
  }
}
