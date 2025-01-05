import 'package:bookshop/providers/auth_provider.dart';
import 'package:bookshop/providers/user_provider.dart';
import 'package:bookshop/screens/admin/main_screens.dart';
import 'package:bookshop/screens/student/main_screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../providers/borrowed_provider.dart';
import 'signup_screen.dart';

class SignInScreen extends StatelessWidget {
  final mailController = TextEditingController(text: 'hieu@gmail.com');
  final passwordController = TextEditingController(text: '123456');
  final _form = GlobalKey<FormState>();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Book Library')),
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Login Form',
                    style: TextStyle(
                        fontSize: 20, letterSpacing: 2, color: Colors.blueGrey),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Email là bắt buộc';
                        }
                        if (!val.contains('@')) {
                          return 'Vui lòng cung cấp địa chỉ email hợp lệ';
                        }
                        return null;
                      },
                      controller: mailController,
                      decoration: InputDecoration(hintText: 'Email'),
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Mật khẩu là bắt buộc';
                      }
                      if (val.length < 6) {
                        return 'Mật khẩu phải chứa ít nhất 6 ký tự';
                      }
                      if (val.length > 20) {
                        return 'Mật khẩu không được quá 20 ký tự';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Mật khẩu'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  FilledButton(
                    onPressed: () => _login(context),
                    child: Text('Đăng nhập'),
                  ),
                  Row(
                    children: [
                      Text('Bạn không có tài khoản ?'),
                      TextButton(
                          onPressed: () => Get.to(() => SignUpScreen()),
                          child: Text('Đăng ký ngay'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _login(BuildContext context) async {
    _form.currentState!.save();
    FocusScope.of(context).unfocus();
    if (_form.currentState!.validate()) {
      final success = await Get.showOverlay(
          asyncFunction: () => context.read<AuthProvider>().login(
                email: mailController.text.trim(),
                password: passwordController.text.trim(),
              ),
          loadingWidget: Center(child: CircularProgressIndicator()));

      if (success) {
        final user = context.read<AuthProvider>().user;
        if (user!.role == 'admin') {
          Get.offAll(() => const AdminMainScreens());
          return;
        }
        Get.offAll(() => const MainScreens());
      } else {
        Get.snackbar('Error', 'Invalid email or password');
      }
    }
  }
}
