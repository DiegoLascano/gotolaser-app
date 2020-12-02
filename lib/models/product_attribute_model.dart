// To parse this JSON data, do
//
//     final attribute = attributeFromJson(jsonString);

import 'dart:convert';

ProductAttribute productAttributeFromJson(String str) => ProductAttribute.fromJson(json.decode(str));

String productAttributeToJson(ProductAttribute data) => json.encode(data.toJson());

class ProductAttribute {
  ProductAttribute({
    this.id,
    this.name,
    this.options,
  });

  int id;
  String name;
  List<String> options;

  factory ProductAttribute.fromJson(Map<String, dynamic> json) => ProductAttribute(
        id: json["id"],
        name: json["name"],
        options: List<String>.from(json["options"]?.map((x) => x)) ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "options": List<dynamic>.from(options.map((x) => x)),
      };
}
