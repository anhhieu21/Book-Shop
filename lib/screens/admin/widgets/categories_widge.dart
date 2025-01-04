import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  final List<String> categories = [
    'Science Fiction',
    'Romance',
    'Mystery',
    'Fantasy',
    'Biography',
    'History'
  ];

  CategoriesWidget({super.key});

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
        categories.length,
        (index) {
          return SizedBox(
            child: Card(
              elevation: 1.0,
              child: Center(
                child: Text(
                  categories[index],
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
