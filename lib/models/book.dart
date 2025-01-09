import 'package:bookshop/models/user_model.dart';
import 'package:bookshop/service/service_url.dart';

class Book {
  late String? id;
  late String name;
  late String image;
  late double productPrice;
  late String author;
  String? categoryId;
  String yearPubish;
  Book({
    required this.id,
    required this.name,
    required this.image,
    this.productPrice = 0,
    required this.author,
    this.categoryId,
    required this.yearPubish,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      image: json['image'] != null
          ? '${ServiceUrl.baseUrl}/static/images/${json['image']}'
          : 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Ym9va3xlbnwwfDF8MHx8fDA%3D',
      author: json['author'],
      categoryId: json['category'],
      yearPubish: json['yearPubish'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'yearPubish': yearPubish,
      'author': author,
      'category': categoryId,
    };
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
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

  getTitle(String cate) {}
}

class BorrowBook {
  String id;
  String userId;
  String bookId;
  DateTime borrowDate;
  DateTime returnDate;
  bool isReturn;
  Book? book;
  User? user;
  BorrowBook({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.borrowDate,
    required this.returnDate,
    required this.isReturn,
  });

  factory BorrowBook.fromJson(Map<String, dynamic> json) {
    return BorrowBook(
      id: json['id'],
      userId: json['userId'],
      bookId: json['bookId'],
      borrowDate: DateTime.parse(json['borrowDate']),
      returnDate: DateTime.parse(json['returnDate']),
      isReturn: json['isReturn'],
    );
  }
}
