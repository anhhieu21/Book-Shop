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
}
