import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({@required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
