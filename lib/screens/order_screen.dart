import 'package:bookshop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Order transaction (${provider.orders.length})'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Amount: Rs.'
                                '${provider.orders[index].products.length}'),
                            Text(
                                ' Total price: Rs. ${provider.orders[index].totalPrice}'),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Column(
                              children: [
                                Text(
                                  'Products',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      children: [
                                        ...provider.orders[index].products
                                            .map(
                                          (e) => Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      child: Image.network(
                                                          e.cartImage)),
                                                  Text(e.cartName),
                                                  Text('Rs. ${e.cartPrice}'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_drop_down_circle_outlined),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
