import 'package:flutter/material.dart';

class BooksWidget extends StatelessWidget {
  const BooksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Sách hiện có',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
