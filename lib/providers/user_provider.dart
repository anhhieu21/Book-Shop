import 'package:bookshop/models/order.dart';
import 'package:bookshop/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  CollectionReference dbUser = FirebaseFirestore.instance.collection('users');
  User? user;
  List<OrderModel> orders = [];
  Future<User?> getSingleUser() async {
    final uid = auth.FirebaseAuth.instance.currentUser!.uid;
    final snap = await dbUser.doc(uid).get();
    user = User.fromJson(snap.data() as Map<String, dynamic>);
    notifyListeners();
    return user;
  }

  User singleUser(QuerySnapshot querySnapshot) {
    final singeData = querySnapshot.docs[0].data() as Map<String, dynamic>;
    return User.fromJson(singeData);
  }

  Stream<List<User>> getUser() {
    final data = dbUser.snapshots().map((event) => _getFromSnap(event));
    return data;
  }

  List<User> _getFromSnap(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((e) => User.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future getOrders() async {
    final data = await dbUser
        .doc(auth.FirebaseAuth.instance.currentUser!.uid)
        .collection('orders')
        .get();
    orders = data.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    
    notifyListeners();
  }
}
