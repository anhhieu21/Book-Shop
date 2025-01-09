import 'package:bookshop/providers/auth_provider.dart';
import 'package:bookshop/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BorrowedBookScreen extends StatefulWidget {
  const BorrowedBookScreen({super.key});

  @override
  State<BorrowedBookScreen> createState() => _BorrowedBookScreenState();
}

class _BorrowedBookScreenState extends State<BorrowedBookScreen> {
  late int count = 0;

  late List<String> itemsToOrder = [];

  bool isBool = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context
          .read<BookProvider>()
          .getBorrowedBooks(context.read<AuthProvider>().user!.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(builder: (context, provider, child) {
      final borrows = provider.borrowedBookList;
      return Scaffold(
          appBar: AppBar(
            title: Text('Sách đã mượn'),
          ),
          body: borrows.isEmpty
              ? Center(
                  child: Text("No data"),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: borrows.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      borrows[index].book!.image,
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 90,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                borrows[index].book!.name,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                borrows[index].book!.author,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                'Hạn trả: ${DateFormat('dd/MM/yyyy').format(borrows[index].returnDate)}',
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  FilledButton.tonalIcon(
                                      onPressed:() async{
                                        context
                                            .read<BookProvider>()
                                            .returnBook(borrows[index]);
                                      } ,
                                      label: Text("Trả"),
                                      icon: Icon(
                                        Icons.library_add_check_rounded,
                                      ))
                                ],
                              ),
                            ),
                            Container()
                          ],
                        ),
                      );
                    },
                  ),
                ));
    });
  }
}
