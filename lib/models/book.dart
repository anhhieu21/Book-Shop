import 'dart:ui';

import 'package:flutter/material.dart';

class Book {
  late String? id;
  late String name;
  late String image;
  late double productPrice;
  late String author;
  String? category;
  Book({
    required this.id,
    required this.name,
    required this.image,
    required this.productPrice,
    required this.author,
    this.category,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      productPrice: json['productPrice'],
      author: json['author'],
      category: json['categories'] == null ? "" : json['categories'][0],
    );
  }
}

enum CategoryEnum {
  khoaHocVienTuong('Khoa Học Viễn Tưởng'),
  langMan('Lãng Mạn'),
  biAn('Bí Ẩn'),
  lichSu('Lịch Sử'),
  tieuSu('Tiểu Sử'),
  giaTuong('Giả Tưởng');

  final String title;
  const CategoryEnum(this.title);
}
