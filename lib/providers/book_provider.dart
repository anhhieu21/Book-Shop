import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bookshop/models/book.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

import '../service/book_service.dart';

class BookProvider extends ChangeNotifier {
  List<Book> bookList = [];
  List<Book> bookListPopular = [];
  final _bookService = BookService();
  Future getBooks() async {
    final res = await _bookService.getBooks();
    bookList = res;
    notifyListeners();
  }

  Future<Book> getBookFromId(String id) async {
    // Find product by id from the local list
    return bookList.firstWhere((product) => product.id == id);
  }

  insertList() async {
    try {
      String jsonString = await rootBundle.loadString('assets/books.json');
      List<dynamic> books = json.decode(jsonString);

      // Process books as needed
      for (var book in books) {
        final id = UniqueKey().toString();
        book['productId'] = id;
        bookList.add(Book.fromJson(book));
      }
      print('Books loaded successfully!');
    } catch (e) {
      print('Error loading books: $e');
    }
  }

  Future<bool> addBook(
      {required String name,
      required String author,
      required String yearPubish,
      required String category,
      File? file}) async {
    final success = await _bookService.addBook(
      name: name,
      author: author,
      yearPubish: yearPubish,
      category: category,
      filePath: file?.path,
    );

    return success;
  }
}
