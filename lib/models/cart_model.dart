class CartModel {
  late String cartId;
  String productId;
  late double cartPrice;
  late int cartQuantity;
  late double totalPrice;
  late String cartName;
  late String cartImage;

  CartModel({
    required this.cartId,
    required this.cartPrice,
    required this.cartQuantity,
    required this.totalPrice,
    required this.productId,
    required this.cartName,
    required this.cartImage,
  });
  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        cartId: json["cartId"],
        cartPrice: json["cartPrice"].toDouble(),
        cartQuantity: json["cartQuantity"],
        totalPrice: json["totalPrice"].toDouble(),
        productId: json["cartId"],
        cartName: json["cartName"],
        cartImage: json["cartImage"],
      );

  Map<String, dynamic> toJson() => {
        "cartId": cartId,
        "cartPrice": cartPrice,
        "cartQuantity": cartQuantity,
        "totalPrice": totalPrice,
        "productId": productId,
        "cartName": cartName,
        "cartImage": cartImage,
      };
}
