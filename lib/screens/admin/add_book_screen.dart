import 'dart:io';

import 'package:bookshop/models/book.dart';
import 'package:bookshop/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _yearController = TextEditingController();
  final _genreController = TextEditingController();
  CategoryEnum _selectedGenre = CategoryEnum.lichSu;
  File? _selectedImage;
  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Process the data
      final success = await Get.showOverlay<bool>(
          asyncFunction: () => context.read<BookProvider>().addBook(
              name: _titleController.text,
              author: _authorController.text,
              yearPubish: _yearController.text,
              category: _selectedGenre.title,
              file: _selectedImage),
          loadingWidget: Center(child: CircularProgressIndicator()));
      Get.back();
      if (success) {
        Get.snackbar(
          'Thông báo',
          'Thêm sách thành công!',
        );
        print('Book added successfully!');
      } else {
        Get.snackbar('Lỗi', 'Thêm sách không thành công!');
        print('Error adding book!');
      }
    }
  }

  selectImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    _selectedImage = File(image!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sách mới'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _selectedImage != null
                    ? Image.file(
                        height: context.width * 0.5,
                        width: context.width * 0.5,
                        _selectedImage!)
                    : GestureDetector(
                        onTap: selectImage,
                        child: Card.outlined(
                            child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(children: [
                            Icon(Icons.image),
                            Text('Chọn hình ảnh')
                          ]),
                        )),
                      ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Tiêu đề'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Xin hãy nhập tiêu đề';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _authorController,
                  decoration: InputDecoration(labelText: 'Tác giả'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: 'Năm xuất bản'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Xin hãy nhập năm xuất bản';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                // Dropdown
                SizedBox(
                  width: double.infinity,
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<CategoryEnum>(
                    value: _selectedGenre,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    hint: Text('Thể loại'),
                    borderRadius: BorderRadius.circular(8),
                    items: CategoryEnum.values
                        .map<DropdownMenuItem<CategoryEnum>>((value) {
                      return DropdownMenuItem<CategoryEnum>(
                        value: value,
                        child: Text(value.title),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGenre = value!;
                      });
                    },
                  )),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Thêm sách'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
