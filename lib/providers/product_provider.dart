import 'package:flutter/material.dart';
import 'package:bookshop/models/productModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductProvider extends ChangeNotifier {
  CollectionReference dbPosts = FirebaseFirestore.instance.collection('books');
  List<ProductModel> productList = [];

  Future getProducts() async {
    final data = await dbPosts.get();
    productList = _getFromSnap(data);
    notifyListeners();
    return productList;
  }

  Future<ProductModel> getProductFromId(String id) async {
    final data = await dbPosts.doc(id).get();
    return _getProductFromSnap(data);
  }

  ProductModel _getProductFromSnap(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return ProductModel(
      productId: documentSnapshot.id,
      productName: data['productName'],
      productPrice: data['productPrice'],
      productDetails: data['productDetails'],
      productImage: data['productImage'],
    );
  }

  List<ProductModel> _getFromSnap(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      return ProductModel(
        productId: e.id,
        productImage: data['productImage'] ?? '',
        productName: data['productName'] ?? '',
        productPrice: data['productPrice'],
        productDetails: data['productDetails'] ?? '',
      );
    }).toList();
  }
}
