import 'package:bookshop/screens/admin/book_lent_screen.dart';
import 'package:bookshop/screens/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/borrowed_provider.dart';
import 'admin_home_screen.dart';

class AdminMainScreens extends StatefulWidget {
  const AdminMainScreens({super.key});

  @override
  State<AdminMainScreens> createState() => _AdminMainScreensState();
}

class _AdminMainScreensState extends State<AdminMainScreens> {
  List<Widget> _screen = [];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    super.initState();
    _screen = [
      AdminHomeScreen(),
      BookLentScreen(),
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
          NavigationDestination(
              icon: Icon(Icons.book_rounded), label: "Trang chủ"),
          NavigationDestination(
              icon: Consumer<BorrowedBookProvider>(
                  builder: (context, provider, child) {
                return Badge.count(
                  count: provider.cartList.length,
                  child: Icon(Icons.library_books_rounded),
                );
              }),
              label: "Đã cho mượn"),
          NavigationDestination(icon: Icon(Icons.person), label: "Tài khoản"),
        ],
      ),
    );
  }
}
