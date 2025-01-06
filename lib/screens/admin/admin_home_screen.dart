import 'package:bookshop/models/book.dart';
import 'package:bookshop/providers/book_provider.dart';
import 'package:bookshop/screens/admin/add_book_screen.dart';
import 'package:bookshop/screens/admin/category_screen.dart';
import 'package:bookshop/screens/admin/widgets/books_widget.dart';
import 'package:bookshop/screens/details_book.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'widgets/categories_widge.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    context.read<BookProvider>()
      ..getBooks()
      ..getCategories();
    super.initState();
  }

  final _typeController = TextEditingController();

  _addCategory() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Thêm thể loại'),
              content: TextField(
                decoration: InputDecoration(hintText: 'Tên thể loại'),
                controller: _typeController,
              ),
              actions: [
                OutlinedButton(onPressed: Get.back, child: Text('Huỷ')),
                FilledButton(
                    onPressed: () {
                      if (_typeController.text.isNotEmpty) {
                        context
                            .read<BookProvider>()
                            .addCategory(_typeController.text);
                        _typeController.clear();
                        Get.back();
                      } else {
                        Get.snackbar(
                            'Lưu ý', 'Vui lòng nhập thể loại muốn thêm');
                      }
                    },
                    child: Text('Thêm'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, provider, child) {
        final products = provider.bookList;
        final categories = provider.categoryList;
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'Book Library Admin',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => AddBookScreen());
            },
            child: Icon(Icons.add),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<BookProvider>()
                ..getBooks()
                ..getCategories();
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Thể loại',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              TextButton.icon(
                                  onPressed: categories.isEmpty
                                      ? _addCategory
                                      : () => Get.to(() => CategoryScreen()),
                                  label: categories.isEmpty
                                      ? Text('Thêm')
                                      : Text('Chỉnh sửa'),
                                  icon: Icon(Icons.edit))
                            ],
                          ),
                          SizedBox(height: 100, child: CategoriesWidget()),
                        ],
                      ),
                    ),
                  ),
                ),
                BooksWidget(),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 300,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ItemBook(
                          product: products[index],
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ItemBook extends StatelessWidget {
  final Book product;
  const ItemBook({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DetailBook(product));
      },
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/book.jpg', fit: BoxFit.cover),
                ),
              ),
            ),
            Text(
              product.name,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text("Author: ${product.author}",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
