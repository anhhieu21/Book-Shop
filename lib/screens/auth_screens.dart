import 'package:bookshop/providers/auth_provider.dart';
import 'package:bookshop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class AuthScreen extends StatelessWidget {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('BookShop')),
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
                          return 'email is required';
                        }
                        if (!val.contains('@')) {
                          return 'please provide valid email address';
                        }
                        return null;
                      },
                      controller: mailController,
                      decoration: InputDecoration(hintText: 'email'),
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'password is required';
                      }
                      if (val.length < 6) {
                        return 'minimum password length is 6';
                      }
                      if (val.length > 20) {
                        return 'maximum password length is 20';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'password'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  FilledButton(
                    onPressed: () => _login(context),
                    child: Text('Submit'),
                  ),
                  Row(
                    children: [
                      Text('Don\'t have account ?'),
                      TextButton(
                          onPressed: () => Get.to(() => SignUpScreen()),
                          child: Text('SignUp'))
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
        await context.read<UserProvider>().getSingleUser();
        Get.offAll(() => const HomeScreen());
      } else {
        Get.snackbar('Error', 'Invalid email or password');
      }
    }
  }
}

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final name = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  'Register Form',
                  style: TextStyle(
                      fontSize: 20, letterSpacing: 2, color: Colors.blueGrey),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: name,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'name is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'name'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'email is required';
                      }
                      if (!val.contains('@')) {
                        return 'please provide valid email address';
                      }
                      return null;
                    },
                    controller: mailController,
                    decoration: InputDecoration(hintText: 'email'),
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'password is required';
                    }
                    if (val.length < 6) {
                      return 'minimum password length is 6';
                    }
                    if (val.length > 20) {
                      return 'maximum password length is 20';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'password'),
                ),
                SizedBox(
                  height: 8,
                ),
                FilledButton(
                  onPressed: () => _register(context),
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _register(BuildContext context) async {
    _form.currentState!.save();
    FocusScope.of(context).unfocus();
    if (_form.currentState!.validate()) {
      final success = await Get.showOverlay(
          asyncFunction: () => context.read<AuthProvider>().signUp(
                userName: name.text.trim(),
                email: mailController.text.trim(),
                password: passwordController.text.trim(),
              ),
          loadingWidget: Center(child: CircularProgressIndicator()));

      if (success) {
        Get.back();
        Get.snackbar('Success', 'Account created successfully');
      } else {
        Get.snackbar('Error', 'Something went wrong');
      }
    }
  }
}
