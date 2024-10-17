import 'package:bookshop/providers/cart_provider.dart';
import 'package:bookshop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'main_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  final addressController = TextEditingController();

  final provinceController = TextEditingController();

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    nameController.text = context.read<UserProvider>().user?.userName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Checkout'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _keyForm,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration:
                        InputDecoration(labelText: 'Firts and last name'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'name is required';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(labelText: 'Number phone'),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'phone is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'address is required';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: provinceController,
                      decoration: InputDecoration(labelText: 'Province/City'),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'province/city is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_rounded),
                          const SizedBox(width: 8.0),
                          Text('Payment : '),
                          Text('Cash on delivery (Default)'),
                          Spacer(),
                          Icon(Icons.check, color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.local_shipping_rounded),
                          const SizedBox(width: 8.0),
                          Text('Shipping : '),
                          Text('Free'),
                          Spacer(),
                          Icon(Icons.check, color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Order: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '${provider.totalPrice}\$',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () async {
                      if (!_keyForm.currentState!.validate()) {
                        return;
                      }

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                  title: Text('Confirm order'),
                                  content: Text(
                                    'Please confirm your order by clicking on the button below',
                                  ),
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () => Get.back(),
                                        child: Text('Cancel')),
                                    OutlinedButton(
                                        onPressed: () async {
                                          final result = await Get.showOverlay(
                                            asyncFunction: () =>
                                                provider.addOrder(
                                              name: nameController.text,
                                              numberPhone: phoneController.text,
                                              address: addressController.text,
                                              provinceCity:
                                                  provinceController.text,
                                            ),
                                            loadingWidget: Center(
                                                child:
                                                    const CircularProgressIndicator()),
                                          );

                                          if (result == true) {
                                            Get.snackbar('Order Placed',
                                                'Your order has been placed');
                                            Get.offAll(
                                                () => const MainScreen());
                                          } else {
                                            Get.snackbar('Order Failed',
                                                'Please add item to cart');
                                          }
                                        },
                                        child: Text('Confirm')),
                                  ]));
                    },
                    child: Text('Checkout')),
              )
            ],
          ),
        ),
      );
    });
  }
}
