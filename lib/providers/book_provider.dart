import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bookshop/models/book.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

import '../service/book_service.dart';

class BookProvider extends ChangeNotifier {
  List<Book> bookList = [];
  List<Book> bookListSearch = [];
  List<Category> categoryList = [];
  Book? detailBook;
  final _bookService = BookService();
  Future getBooks() async {
    final res = await _bookService.getBooks();
    bookList = res;
    notifyListeners();
  }

  searchBook({String? value, String? category}) {
    if (category != null) {
      bookListSearch = bookList.where((e) => e.categoryId == category).toList();
    } else {
      bookListSearch = bookList;
    }
    if (value != null && value.isNotEmpty) {
      bookListSearch = bookListSearch
          .where((e) =>
              e.name.toLowerCase().contains(value.toLowerCase()) ||
              e.author.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
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
    await getBooks();

    return success;
  }

  Future<bool> updateBook(
      {required String id,
      required String name,
      required String author,
      required String yearPubish,
      required String category,
      File? file}) async {
    final success = await _bookService.updateBook(
      id: id,
      name: name,
      author: author,
      yearPubish: yearPubish,
      category: category,
      filePath: file?.path,
    );
    await getBooks();
    detailBook = bookList.firstWhere((e) => e.id == id);
    notifyListeners();
    return success;
  }

  Future<bool> deleteBook(String id) async {
    final success = await _bookService.deleteBook(id);
    await getBooks();
    return success;
  }

  Future<bool> deleteCategory(String id) async {
    final success = await _bookService.deleteCategory(id);
    return success;
  }

  Future<void> getCategories() async {
    final res = await _bookService.getCategories();
    categoryList = res;
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    final success = await _bookService.addCategory(name);
    if (success) {
      Get.snackbar('Thành cộng', 'Đã thêm thể loại sách');
      await getCategories();
      return;
    }
    Get.snackbar('Thất bại', 'Không thể thêm loại sách');
  }

  Future<void> updateCategory(String name, String id) async {
    final success = await _bookService.updateCategory(name, id);
    if (success) {
      Get.snackbar('Thành cộng', 'Cập nhật thể loại sách');
      await getCategories();
      return;
    }
    Get.snackbar('Thất bại', 'Không thể cập nhật loại sách');
  }
}
