// To parse this JSON data, do
//
//     final image = imageFromJson(jsonString);

import 'dart:convert';

Image imageFromJson(String str) => Image.fromJson(json.decode(str));

String imageToJson(Image data) => json.encode(data.toJson());

class Image {
  Image({
    this.url,
  });

  String url;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        url: json["src"],
      );

  Map<String, dynamic> toJson() => {
        "src": url,
      };
}
