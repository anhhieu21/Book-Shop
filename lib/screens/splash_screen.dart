import 'package:bookshop/providers/auth_provider.dart';
import 'package:bookshop/providers/cart_provider.dart';
import 'package:bookshop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'auth_screens.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final isLogin = await context.read<AuthProvider>().checkAuthState();

      if (isLogin) {
        await context.read<UserProvider>().getSingleUser();
        await context.read<CartProvider>().getCartData();
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => AuthScreen());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
