import 'package:bookshop/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartProvider extends ChangeNotifier {
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
      final existingItemIndex = cartList.indexWhere((item) => item.cartId == productId);
      if (existingItemIndex != -1) {
        final existingItem = cartList[existingItemIndex];
        existingItem.cartQuantity += 1;
        existingItem.totalPrice += cartPrice;
      } else {
        cartList.add(CartModel(
          cartId: productId,
          cartPrice: cartPrice,
          cartQuantity: cartQuantity,
          totalPrice: double.tryParse(totalPrice) ?? 0.0,
          productId: productId,
          cartName: cartName,
          cartImage: cartImage,
        ));
      }
      calculateTotalPrice();
      Get.snackbar('Added to cart', 'Item added to cart',
          icon: Icon(
            Icons.check_circle,
            color: Colors.green,
          ));
      notifyListeners();
      return true;
    } catch (e) {
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
      // Add order logic here (e.g., save to local storage or another service)

      cartList.clear();
      totalPrice = 0.0;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void addSingleCart(CartModel cartItem) {
    cartItem.cartQuantity += 1;
    cartItem.totalPrice = cartItem.cartPrice * cartItem.cartQuantity;
    calculateTotalPrice();
    notifyListeners();
  }

  Future<bool> removeCartItem({required String cartId}) async {
    try {
      cartList.removeWhere((element) => element.cartId == cartId);
      calculateTotalPrice();
      Get.snackbar('Removed from cart', 'Item removed from cart');
      notifyListeners();
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  void calculateTotalPrice() {
    totalPrice = cartList.fold(0, (sum, item) => sum + item.totalPrice);
  }

  Future<List<CartModel>> getCartData() async {
    // Fetch cart data logic here (e.g., from local storage or another service)
    notifyListeners();
    return cartList;
  }
}
