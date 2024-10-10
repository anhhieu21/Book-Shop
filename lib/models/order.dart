import 'package:bookshop/models/cartModel.dart';

class OrderModel {
  late int amount;
  late double totalPrice;
  late List<CartModel> products;

  OrderModel({required this.totalPrice, required this.products});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      totalPrice: json['totalPrice'].toDouble(),
      products:
          (json['products'] as List).map((e) => CartModel.fromJson(e)).toList(),
    );
  }
}
