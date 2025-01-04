import 'package:bookshop/models/order.dart';
import 'package:bookshop/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? user;
  List<OrderModel> orders = [];

  Future<User?> getSingleUser() async {
    // Implement your logic here
    notifyListeners();
    return user;
  }

  User? singleUser() {
    // Implement your logic here
    return null;
  }

  Stream<List<User>> getUser() {
    // Implement your logic here
    return Stream.value([]);
  }

  List<User> _getFromSnap() {
    // Implement your logic here
    return [];
  }

  Future getOrders() async {
    // Implement your logic here
    notifyListeners();
  }
}
