import 'package:bookshop/providers/borrowed_provider.dart';
import 'package:flutter/material.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowedBookProvider>(builder: (context, provider, child) {
      final cartItems = provider.cartList;
      return Scaffold(
          appBar: AppBar(
            title: Text('Độc giả mượn sách'),
          ),
          body: provider.cartList.isEmpty
              ? Center(
                  child: Text("No data"),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: provider.cartList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 90,
                                      child: Center(
                                        child: Image.network(
                                          cartItems[index].cartImage,
                                        ),
                                      ),
                                    ),
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
                                                cartItems[index].cartName,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                '${cartItems[index].totalPrice}\$',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Quantity: ${cartItems[index].cartQuantity}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 90,
                                      padding: EdgeInsets.only(right: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: InkWell(
                                          onTap: () async {
                                            await provider.removeCartItem(
                                                cartId:
                                                    cartItems[index].cartId);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            size: 30,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
