import 'package:bookshop/models/book.dart';
import 'package:flutter/material.dart';

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
  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the data
      print('Title: ${_titleController.text}');
      print('Author: ${_authorController.text}');
      print('Year: ${_yearController.text}');
      print('Genre: ${_genreController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sách mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
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
    );
  }
}
