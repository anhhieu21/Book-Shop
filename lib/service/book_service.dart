import 'dart:convert';

import 'package:bookshop/models/book.dart';
import 'package:dio/dio.dart';

import 'dio_client.dart';
import 'service_url.dart';

class BookService {
  //singleton
  static final BookService _instance = BookService._internal();
  factory BookService() => _instance;
  BookService._internal();

  Future<List<Book>> getBooks() async {
    final res = await dioClient.get(ServiceUrl.book);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return (res.data as List).map((e) => Book.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> addBook(
      {required String name,
      required String author,
      required String yearPubish,
      required String category,
      String? filePath}) async {
    try {
      var data = FormData.fromMap({
        'image': filePath != null
            ? await MultipartFile.fromFile(filePath,
                filename: filePath.split('/').last)
            : null,
        'name': name,
        'author': author,
        'yearPubish': yearPubish,
        'category': category
      });

      final response = await dioClient.post(ServiceUrl.book, data, false);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateBook(
      {required String id,
      required String name,
      required String author,
      required String yearPubish,
      required String category,
      String? filePath}) async {
    try {
      var data = FormData.fromMap({
        'image': filePath != null
            ? await MultipartFile.fromFile(filePath,
                filename: filePath.split('/').last)
            : null,
        'name': name,
        'author': author,
        'yearPubish': yearPubish,
        'category': category
      });

      final response = await dioClient.put('${ServiceUrl.book}/$id', data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> addCategory(String name) async {
    try {
      final response =
          await dioClient.post(ServiceUrl.category, {'name': name});
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateCategory(String name, String id) async {
    try {
      final response =
          await dioClient.put('${ServiceUrl.category}/$id', {'name': name});
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final res = await dioClient.get(ServiceUrl.category);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return (res.data as List).map((e) => Category.fromJson(e)).toList();
      }
      return [];
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> deleteBook(String id) async {
    try {
      final response = await dioClient.delete('${ServiceUrl.book}/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final response = await dioClient.delete('${ServiceUrl.category}/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }
}
