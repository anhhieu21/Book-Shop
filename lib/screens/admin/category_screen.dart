import 'package:bookshop/models/book.dart';
import 'package:bookshop/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _typeController = TextEditingController();
  _editCategory(Category category) {
    _typeController.text = category.name;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Chỉnh sửa thể loại'),
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
                            .updateCategory(_typeController.text, category.id);

                        Get.back();
                      } else {
                        Get.snackbar('Lưu ý', 'Vui lòng nhập thể loại');
                      }
                      _typeController.clear();
                    },
                    child: Text('Cập nhật'))
              ],
            ));
  }

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

                        Get.back();
                      } else {
                        Get.snackbar(
                            'Lưu ý', 'Vui lòng nhập thể loại muốn thêm');
                      }
                      _typeController.clear();
                    },
                    child: Text('Thêm'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thể loại sách"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: Icon(Icons.add),
      ),
      body: Consumer<BookProvider>(builder: (context, provider, child) {
        return ListView(children: [
          ...provider.categoryList.map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey),
                  ),
                  contentPadding: EdgeInsets.only(left: 8),
                  title: Text(e.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton.filledTonal(
                        onPressed: () => _editCategory(e),
                        icon: Icon(Icons.edit),
                      ),
                      IconButton.filledTonal(
                        onPressed: () async {
                          final success = await provider.deleteCategory(e.id);
                          if (success) {
                            Get.snackbar('Thành cộng', 'Đã xoa thể loại sách');
                            await provider.getCategories();
                          } else {
                            Get.snackbar(
                                'Thất bị', 'Xoa thể loại sách thất bại');
                          }
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ))
        ]);
      }),
    );
  }
}
