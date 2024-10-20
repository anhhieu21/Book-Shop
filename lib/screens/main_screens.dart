import 'package:bookshop/widgets/cart_screen.dart';
import 'package:bookshop/widgets/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'home_screen.dart';

class MainScreens extends StatefulWidget {
  const MainScreens({super.key});

  @override
  State<MainScreens> createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  List<Widget> _screen = [];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    super.initState();
    _screen = [
      HomeScreen(),
      CartScreen(),
      MyProfile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screen,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) => setState(() => _currentIndex = value),
        destinations: [
          NavigationDestination(icon: Icon(Icons.book_rounded), label: "Home"),
          NavigationDestination(
              icon: Consumer<CartProvider>(builder: (context, provider, child) {
                return Badge.count(
                  count: provider.cartList.length,
                  child: Icon(Icons.shopping_bag),
                );
              }),
              label: "Cart"),
          NavigationDestination(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
