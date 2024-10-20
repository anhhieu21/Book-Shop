import 'package:bookshop/models/cart_model.dart';
import 'package:bookshop/widgets/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartProvider extends ChangeNotifier {
  CollectionReference dbUser = FirebaseFirestore.instance.collection('users');

  List<CartModel> cartList = []; // List<CartModel>

  double totalPrice = 0.0;
  Future<bool> addToCart(
    String productId,
    double cartPrice,
    int cartQuantity,
    String totalPrice,
    String cartName,
    String cartImage,
  ) async {
    try {
      final ref =
          dbUser.doc(FirebaseAuth.instance.currentUser!.uid).collection('cart');

      final doc = await ref.doc(productId).get();
      if (doc.exists) {
        final data = CartModel.fromJson(doc.data() as Map<String, dynamic>);
        await ref.doc(productId).update({
          'cartQuantity': FieldValue.increment(1),
          'totalPrice': data.totalPrice + cartPrice,
        });
      } else {
        await ref.doc(productId).set({
          'cartId': productId,
          'cartPrice': cartPrice,
          'cartQuantity': cartQuantity,
          'totalPrice': double.tryParse(totalPrice),
          'cartName': cartName,
          'cartImage': cartImage,
        });
      }
      getCartData();
      Get.snackbar('Added to cart', 'Item added to cart');
      Get.to(() => CartScreen());

      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addOrder({
    required String name,
    required String numberPhone,
    required String address,
    required String provinceCity,
  }) async {
    if (cartList.isEmpty) {
      return false;
    }
    try {
      await dbUser
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .add({
        'totalPrice': totalPrice,
        'products': cartList.map((e) => e.toJson()).toList(),
        'address': {
          'name': name,
          'numberPhone': numberPhone,
          'address': address,
          'provinceCity': provinceCity,
        },
      });

      final ids = cartList.map((e) => e.cartId).toList();
      for (var id in ids) {
        await dbUser
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('cart')
            .doc(id)
            .delete();
      }
      cartList.clear();
      totalPrice = 0.0;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  void addSingleCart(CartModel cartItem) {
    cartItem.cartQuantity = cartItem.cartQuantity + 1;
    cartItem.totalPrice = cartItem.cartPrice * (cartItem.cartQuantity + 1);
  }

  Future<bool> removeCartItem({required String cartId}) async {
    try {
      final ref = dbUser
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('cart')
          .doc(cartId);
      await ref.delete();

      cartList.removeWhere((element) => element.cartId == cartId);

      totalPrice = cartList.fold(0, (sum, item) => sum + item.totalPrice);
      Get.snackbar('Removed from cart', 'Item removed from cart');
      notifyListeners();
      return true;
    } on FirebaseException catch (err) {
      print(err);
      return false;
    }
  }

  Future<List<CartModel>> getCartData() async {
    final data = await dbUser
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cart')
        .get();
    cartList = _getFromSnap(data);
    totalPrice = cartList.fold(0, (sum, item) => sum + item.totalPrice);
    notifyListeners();
    return cartList;
  }

  List<CartModel> _getFromSnap(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      return CartModel(
        cartId: e.id,
        cartPrice: data['cartPrice'],
        cartQuantity: data['cartQuantity'],
        totalPrice: data['cartPrice'].toDouble() * data['cartQuantity'],
        productId: data['productId'] ?? 'temporary',
        cartName: data["cartName"] ?? "",
        cartImage: data["cartImage"] ?? "",
      );
    }).toList();
  }
}
