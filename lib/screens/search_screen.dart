import 'package:bookshop/models/book.dart';
import 'package:bookshop/providers/book_provider.dart';
import 'package:bookshop/screens/details_book.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Category? _categorySelected;
  ScrollController? controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 45,
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Nhập tên sách, hoặc tác giả',
                  contentPadding: EdgeInsets.only(left: 8.0),
                  suffixIcon:
                      IconButton(onPressed: () {}, icon: Icon(Icons.search))),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: ListView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  children: provider.categoryList
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ChoiceChip(
                              label: Text(e.name),
                              selected: _categorySelected?.id == e.id,
                              onSelected: (value) {
                                if (value) {
                                  _categorySelected = e;
                                  setState(() {});
                                }
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: provider.bookList
                    .map((e) => GestureDetector(
                          onTap: () => Get.to(() => DetailBook(e)),
                          child: Card.filled(
                            child: Row(
                              spacing: 8,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    e.image,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text('Tác giả: ${e.author}'),
                                      Text('Năm xuất bản: ${e.yearPubish}'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      );
    });
  }
}
