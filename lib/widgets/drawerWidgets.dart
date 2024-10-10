import 'package:bookshop/providers/auth_provider.dart';
import 'package:bookshop/providers/user_provider.dart';
import 'package:bookshop/screens/main_screen.dart';
import 'package:bookshop/widgets/myProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DrawerWidgets extends StatelessWidget {
  const DrawerWidgets({super.key});

  Widget listTile({
    required String title,
    required IconData iconData,
  }) {
    return SizedBox(
      height: 50,
      child: ListTile(
        onTap: () {},
        leading: Icon(
          iconData,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, child) {
      final user = provider.user!;
      return Drawer(
        child: Container(
            color: Colors.white,
            child: ListView(
              children: [
                DrawerHeader(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 43,
                          backgroundColor: Colors.white54,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://th.bing.com/th/id/OIP.W2xIbYmLZhyVqZRp_dATDwAAAA?pid=ImgDet&w=300&h=284&rs=1'),
                            radius: 40,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    user.userName,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  Text(user.email,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18)),
                                ],
                              ),
                            ])
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home_rounded),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_rounded),
                  title: Text('Profile'),
                  onTap: () async {
                    await Get.showOverlay(
                        asyncFunction: context.read<UserProvider>().getOrders,
                        loadingWidget:
                            Center(child: CircularProgressIndicator()));
                    Get.to(MyProfile());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.format_quote_outlined),
                  title: Text('FAQ'),
                ),
                InkWell(
                  onTap: () {
                    context.read<AuthProvider>().logout();
                  },
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app_rounded),
                    title: Text("Log Out"),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Contact Support"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text("Call us:"),
                          SizedBox(
                            width: 10,
                          ),
                          Text("984125010"),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text("Mail us:"),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "bookshop@gmail.com",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      );
    });
  }
}
