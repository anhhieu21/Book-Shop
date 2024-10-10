import 'package:bookshop/providers/user_provider.dart';
import 'package:bookshop/screens/order_screen.dart';
import 'package:bookshop/widgets/drawerWidgets.dart';
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
          drawer: DrawerWidgets(),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 250,
                                height: 80,
                                padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              provider.user!.userName,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              provider.user!.email,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    IconButton.filled(
                                        onPressed: () {
                                          Get.snackbar('Inprogress',
                                              'Feature Coming Soon');
                                        },
                                        icon: Icon(Icons.edit))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          listTile(
                              onTap: () => Get.to(() => OrderScreen()),
                              icon: Icons.shop_outlined,
                              title: "My Orders"),
                          listTile(
                              icon: Icons.file_copy_outlined,
                              title: "Terms & Conditions"),
                          listTile(
                              icon: Icons.policy_outlined,
                              title: "Privacy Policy"),
                          listTile(icon: Icons.add_chart, title: "About"),
                          listTile(
                              icon: Icons.exit_to_app_outlined,
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
                        // userData.userImage ??
                        "assets/book1.jpg",
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
