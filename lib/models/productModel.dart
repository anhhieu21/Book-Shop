class ProductModel {
  late String? productId;
  late String productName;
  late String productImage;
  late int productPrice;
  late String productDetails;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productDetails,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      productPrice: json['productPrice'],
      productDetails: json['productDetails'],
    );
  }
}
