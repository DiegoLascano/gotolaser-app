import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_to_laser_store/screens/store/products_screen.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(
      {Key key,
      @required this.title,
      this.description,
      this.linkText,
      this.tagId})
      : super(key: key);

  final String title;
  final String description;
  final String linkText;
  final String tagId;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: Colors.amberAccent),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.subtitle1),
              linkText != null
                  ? InkWell(
                      child: Text(
                        linkText,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductsScreen.create(context,
                              tagId: tagId, title: title),
                        ),
                      ),
                    )
                  : SizedBox(width: 0),
            ],
          ),
          SizedBox(height: 5),
          description != null
              ? Text(
                  description,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              : SizedBox(height: 0),
        ],
      ),
    );
  }
}
