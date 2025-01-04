import 'package:flutter/material.dart';
import 'package:bookshop/models/book.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ProductProvider extends ChangeNotifier {
  List<Book> productList = [];
  List<Book> productListPopular = [];

  Future getProducts() async {
    // Load products from local JSON file or other source
    String jsonString = await rootBundle.loadString('assets/books.json');
    List<dynamic> books = json.decode(jsonString);
    productList = books.map((book) => Book.fromJson(book)).toList();
    productListPopular = productList.sublist(0, 10);
    notifyListeners();
    return productList;
  }

  Future<Book> getProductFromId(String id) async {
    // Find product by id from the local list
    return productList.firstWhere((product) => product.id == id);
  }

  insertList() async {
    try {
      String jsonString = await rootBundle.loadString('assets/books.json');
      List<dynamic> books = json.decode(jsonString);

      // Process books as needed
      for (var book in books) {
        final id = UniqueKey().toString();
        book['productId'] = id;
        productList.add(Book.fromJson(book));
      }
      print('Books loaded successfully!');
    } catch (e) {
      print('Error loading books: $e');
    }
  }
}
