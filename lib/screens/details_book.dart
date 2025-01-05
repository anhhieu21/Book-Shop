import 'package:bookshop/models/book.dart';
import 'package:bookshop/providers/auth_provider.dart';
import 'package:bookshop/providers/borrowed_provider.dart';
import 'package:bookshop/screens/student/book_mg_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DetailBook extends StatelessWidget {
  final Book book;
  const DetailBook(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowedBookProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      book.image,
                      height: context.height * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  book.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('Description: ',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  book.author,
                ),
                Text(
                  'Category: ${book.category}',
                  style: TextStyle(fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<AuthProvider>(builder: (context, provider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: provider.user?.role == 'admin'
                  ? [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.edit_document),
                        label: Text('Chỉnh sửa'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.delete_forever),
                        label: Text('Xóa sách'),
                      ),
                    ]
                  : [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.bookmark),
                        label: Text('Mượn sách'),
                      ),
                    ],
            );
          }),
        ),
      );
    });
  }
}
