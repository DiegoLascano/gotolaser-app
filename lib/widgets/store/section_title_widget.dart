import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    @required this.title,
    this.description,
    this.linkText,
  }) : super(key: key);

  final String title;
  final String description;
  final String linkText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.amberAccent),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              linkText != null
                  ? InkWell(
                      child: Text(linkText),
                      onTap: () {},
                    )
                  : SizedBox(width: 0),
            ],
          ),
          SizedBox(height: 5),
          description != null ? Text(description) : SizedBox(height: 0),
        ],
      ),
    );
  }
}
