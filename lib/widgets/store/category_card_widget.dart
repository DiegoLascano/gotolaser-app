import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/screens/store/products_screen.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({@required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        // height: 100,
        width: 150,
        // margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Text(category.name),
            // Text(category.description),
          ],
        ),
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ProductsScreen.create(context, category.id.toString()),
        ),
      ),
    );
  }
}
