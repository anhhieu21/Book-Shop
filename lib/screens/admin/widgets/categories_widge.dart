import 'package:bookshop/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(builder: (context, provider, child) {
      final categories = provider.categoryList;
      return categories.isEmpty
          ? Center(
              child: Text('Chưa có thể loại nào'),
            )
          : GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 0.3,
              children: List.generate(
                categories.length,
                (index) {
                  return SizedBox(
                    child: Card.outlined(
                      child: Center(
                        child: Text(
                          categories[index].name,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
    });
  }
}
