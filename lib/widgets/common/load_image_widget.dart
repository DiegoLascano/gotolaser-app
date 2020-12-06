import 'package:flutter/material.dart';
import 'package:go_to_laser_store/styles/app_images.dart';

class LoadImage extends StatelessWidget {
  const LoadImage({Key key, @required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return FadeInImage(
        placeholder: AssetImage(animatedPlaceholder),
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: AssetImage(placeholder),
        fit: BoxFit.cover,
      );
    }
  }
}
