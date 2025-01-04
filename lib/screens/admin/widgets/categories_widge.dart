import 'package:bookshop/models/book.dart';
import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.5,
      children: List.generate(
        CategoryEnum.values.length,
        (index) {
          return SizedBox(
            child: Card(
              elevation: 1.0,
              color: Color.fromRGBO(204, 211, 202, 1),
              child: Center(
                child: Text(
                  CategoryEnum.values[index].title,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
