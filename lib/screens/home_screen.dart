import 'package:bookshop/models/product_model.dart';
import 'package:bookshop/providers/cart_provider.dart';
import 'package:bookshop/providers/product_provider.dart';
import 'package:bookshop/screens/details_product.dart';
import 'package:bookshop/widgets/drawer_widgets.dart';
import 'package:bookshop/widgets/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<ProductProvider>().getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final products = provider.productList;
        return Scaffold(
          drawer: DrawerWidgets(),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'Home',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: IconButton(
                  onPressed: () {
                    Get.to(() => CartScreen());
                  },
                  icon: Consumer<CartProvider>(
                      builder: (context, provider, child) {
                    return Badge.count(
                      count: provider.cartList.length,
                      child: Icon(Icons.shopping_bag_outlined),
                    );
                  }),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/book.jpg'),
                  ),
                ),
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 130, bottom: 10),
                          child: SizedBox(
                            height: 50,
                            width: 100,
                          ),
                        ),
                        Text(
                          '"There is no friend as loyal as a book"',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'See All',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 300,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ItemBook(
                        product: products[index],
                      );
                    }),
              ),
            ]),
          ),
        );
      },
    );
  }
}

class ItemBook extends StatelessWidget {
  final ProductModel product;
  const ItemBook({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DetailProduct(product));
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              product.productName,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
                "Rs. "
                "${product.productPrice}", //price
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.productImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/book.jpg', fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 10),
          ])),
    );
  }
}
