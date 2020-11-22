// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

import 'package:go_to_laser_store/models/image_model.dart';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    this.id,
    this.name,
    this.description,
    this.parent,
    this.image,
  });

  int id;
  String name;
  String description;
  int parent;
  Image image;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        parent: json["parent"],
        image: json["image"] != null ? Image.fromJson(json["image"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "parent": parent,
        "image": image.toJson(),
      };
}

// class Image {
//   Image({
//     this.url,
//   });
//
//   String url;
//
//   factory Image.fromJson(Map<String, dynamic> json) => Image(
//         url: json["src"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "src": url,
//       };
// }
