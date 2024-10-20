import 'package:bookshop/providers/auth_provider.dart';
import 'package:bookshop/providers/user_provider.dart';
import 'package:bookshop/screens/auth_screens.dart';
import 'package:bookshop/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  Widget listTile(
      {required IconData icon, required String title, VoidCallback? onTap}) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        ListTile(
          onTap: onTap,
          leading: Icon(icon),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.orange,
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              "My Profile",
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 100,
                    color: Colors.orange,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: ListView(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.user!.userName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  provider.user!.email,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          listTile(
                              onTap: () => Get.to(() => OrderScreen()),
                              icon: Icons.shopping_bag_outlined,
                              title: "My Orders"),
                          listTile(
                              icon: Icons.policy_outlined,
                              title: "Privacy Policy"),
                          listTile(icon: Icons.add_chart, title: "About"),
                          listTile(
                              icon: Icons.exit_to_app_outlined,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text("Logout"),
                                          content: Text(
                                              "Are you sure you want to log out?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                context
                                                    .read<AuthProvider>()
                                                    .logout()
                                                    .whenComplete(() {
                                                  Get.offAll(
                                                      () => AuthScreen());
                                                });
                                              },
                                              child: Text("Yes"),
                                            ),
                                          ],
                                        ));
                              },
                              title: "Log Out"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 30),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: CircleAvatar(
                      backgroundImage: AssetImage(
                        "assets/male-avt.jpg",
                      ),
                      radius: 45,
                      backgroundColor: Colors.grey),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
