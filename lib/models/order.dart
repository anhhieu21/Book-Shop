import 'package:bookshop/models/cartModel.dart';

class OrderModel {
  late int amount;
  late double totalPrice;
  late List<CartModel> products;
  AddressModel address;

  OrderModel(
      {required this.totalPrice,
      required this.products,
      required this.address});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      totalPrice: json['totalPrice'].toDouble(),
      products:
          (json['products'] as List).map((e) => CartModel.fromJson(e)).toList(),
      address: AddressModel.fromJson(json['address']),
    );
  }
}

class AddressModel {
  late String name;
  late String numberPhone;
  late String address;
  late String provinceCity;

  AddressModel(
      {required this.name,
      required this.address,
      required this.provinceCity,
      required this.numberPhone});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: json['name'],
      address: json['address'],
      provinceCity: json['provinceCity'],
      numberPhone: json['numberPhone'],
    );
  }
}
