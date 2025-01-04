import 'package:bookshop/models/user_model.dart';
import 'package:bookshop/service/service_url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dio_client.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  UserService._internal();
  factory UserService() {
    return _instance;
  }

  Future<User?> getUserInfo() async {
    try {
      final res = await dioClient.get(ServiceUrl.userInfo);
      return User.fromJson(res.data);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool>   login(String email, String password) async {
    try {
      final data = {
        'email': email,
        'password': password,
      };
      final res = await dioClient.post(ServiceUrl.login, data);
      // Save token to local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', res.data['accessToken']);
      await prefs.setString('refreshToken', res.data['refreshToken']);
      dioClient.setToken(res.data['accessToken']);
      return true;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> register(String email, String name, String password, String role,
      String atClass) async {
    try {
      final data = {
        'email': email,
        'password': password,
        'name': name,
        'role': role,
        'class': atClass,
      };
      await dioClient.post(ServiceUrl.register, data);
      return true;
    } on Exception catch (e) {
      // Handle error
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      return true;
    } on Exception catch (e) {
      // Handle error
      return false;
    }
  }
}
