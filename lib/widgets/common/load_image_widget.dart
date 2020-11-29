import 'package:flutter/material.dart';

class LoadImage extends StatelessWidget {
  const LoadImage({Key key, @required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/images/jar-loading.gif'),
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: AssetImage('assets/images/no-image.png'),
        fit: BoxFit.cover,
      );
    }
  }
}
