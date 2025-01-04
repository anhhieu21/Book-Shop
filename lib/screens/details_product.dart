import 'package:bookshop/models/book.dart';
import 'package:bookshop/providers/cart_provider.dart';
import 'package:bookshop/screens/student/book_mg_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:provider/provider.dart';

class DetailProduct extends StatelessWidget {
  final Book product;
  const DetailProduct(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Consumer<CartProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => BorrowedBookScreen());
              },
              icon: Consumer<CartProvider>(builder: (context, provider, child) {
                return Badge.count(
                    count: provider.cartList.length,
                    child: Icon(Icons.shopping_bag_outlined));
              }),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  product.name,
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
                  product.author,
                ),
                Text(
                  'Category: ${product.category}',
                  style: TextStyle(fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.orange.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '\$ ${product.productPrice}',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  return SizedBox(
                    height: 50,
                    child:
                        Consumer<CartProvider>(builder: (context, ref, child) {
                      return FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await provider.addToCart(
                            product.id!,
                            product.productPrice,
                            1,
                            (product.productPrice).toString(),
                            product.name,
                            product.image,
                          );
                        },
                        icon: Icon(Icons.add_shopping_cart,
                            color: Theme.of(context).primaryColor),
                        label: Text(
                          'Add to Cart',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      );
                    }),
                  );
                }),
              )
            ],
          ),
        ),
      );
    });
  }
}
