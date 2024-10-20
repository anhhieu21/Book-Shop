import 'package:flutter/material.dart';
import 'package:bookshop/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
      category: data['categories'] == null ? "" : data['categories'][0],
    );
  }

  List<ProductModel> _getFromSnap(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      return ProductModel(
        productId: e.id,
        productImage: data['productImage'] ?? '',
        productName: data['productName'] ?? '',
        productPrice: data['productPrice'].toDouble() ?? 0.0,
        productDetails: data['productDetails'] ?? '',
        category: data['categories'] == null ? "" : data['categories'][0],
      );
    }).toList();
  }

  insertList() async {
    try {
      String jsonString = await rootBundle.loadString('assets/books.json');
      List<dynamic> books = json.decode(jsonString);

      // Lấy tham chiếu đến collection 'books' trên Firestore
      CollectionReference booksCollection =
          FirebaseFirestore.instance.collection('books');

      // Tải từng cuốn sách lên Firestore
      for (var book in books) {
        final id = booksCollection.doc().id;
        book['productId'] = id;
        await booksCollection.doc(id).set(book);
      }
      print('Tải sách lên Firebase thành công!');
    } catch (e) {
      print('Lỗi khi tải sách lên Firebase: $e');
    }
  }
}
