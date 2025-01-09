import 'package:bookshop/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookLentScreen extends StatefulWidget {
  const BookLentScreen({super.key});

  @override
  State<BookLentScreen> createState() => _BookLentScreenState();
}

class _BookLentScreenState extends State<BookLentScreen> {
  late int count = 0;

  late List<String> itemsToOrder = [];

  bool isBool = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<BookProvider>().adminGetBorrowedBooks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(builder: (context, provider, child) {
      final borrows =
          provider.borrowedBookList.where((e) => e.isReturn == false).toList();
      final returns =
          provider.borrowedBookList.where((e) => e.isReturn == true).toList();
      return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Độc giả mượn sách'),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: TabBar(
                  tabs: [
                    Tab(text: 'Đang mượn'),
                    Tab(text: 'Đã trả'),
                  ],
                ),
              ),
            ),
            body: borrows.isEmpty
                ? Center(
                    child: Text("No data"),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<BookProvider>().adminGetBorrowedBooks();
                      },
                      child: TabBarView(children: [
                        ListView.builder(
                          itemCount: borrows.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Người mượn sách: ${borrows[index].user!.name}',
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  borrows[index].book!.name,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  borrows[index].book!.author,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  'Ngày mượn: ${DateFormat('dd/MM/yyyy').format(borrows[index].borrowDate)}',
                                                  maxLines: 2,
                                                ),
                                                Text(
                                                  'Hạn trả: ${DateFormat('dd/MM/yyyy').format(borrows[index].returnDate)}',
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        ListView.builder(
                          itemCount: returns.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Người mượn sách: ${returns[index].user!.name}',
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  returns[index].book!.name,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  returns[index].book!.author,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  'Ngày mượn: ${DateFormat('dd/MM/yyyy').format(returns[index].borrowDate)}',
                                                  maxLines: 2,
                                                ),
                                                Text(
                                                  'Hạn trả: ${DateFormat('dd/MM/yyyy').format(returns[index].returnDate)}',
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ]),
                    ),
                  )),
      );
    });
  }
}
