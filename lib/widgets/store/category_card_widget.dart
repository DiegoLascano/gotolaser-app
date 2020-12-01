import 'package:flutter/material.dart';
import 'package:go_to_laser_store/models/category_model.dart';
import 'package:go_to_laser_store/screens/store/products_screen.dart';
import 'package:go_to_laser_store/widgets/common/avatar.dart';
import 'package:go_to_laser_store/widgets/common/load_image_widget.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({@required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            // margin: EdgeInsets.symmetric(vertical: 5),
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              // color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: LoadImage(
              imageUrl: category.image?.url ?? null,
            ),
          ),
          SizedBox(height: 10),
          Text(
            category.name,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
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
