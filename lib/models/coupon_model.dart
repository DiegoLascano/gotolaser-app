// To parse this JSON data, do
//
//     final coupon = couponFromJson(jsonString);

import 'dart:convert';

Coupon couponFromJson(String str) => Coupon.fromJson(json.decode(str));

String couponToJson(Coupon data) => json.encode(data.toJson());

class Coupon {
  Coupon({
    this.id,
    this.code,
    this.amount,
    this.discountType,
    this.description,
    this.dateExpires,
    this.usageLimit,
    this.productIds,
    this.productCategories,
    this.minimumAmount,
  });

  int id;
  String code;
  String amount;
  String discountType;
  String description;
  String dateExpires;
  int usageLimit;
  List<int> productIds;
  List<int> productCategories;
  String minimumAmount;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        code: json["code"],
        amount: json["amount"],
        discountType: json["discount_type"],
        description: json["description"],
        dateExpires: json["date_expires"],
        usageLimit: json["usage_limit"],
        productIds: List<int>.from(json["product_ids"].map((x) => x)),
        productCategories:
            List<int>.from(json["product_categories"].map((x) => x)),
        minimumAmount: json["minimum_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "amount": amount,
        "discount_type": discountType,
        "description": description,
        "date_expires": dateExpires,
        "usage_limit": usageLimit,
        "product_ids": List<dynamic>.from(productIds.map((x) => x)),
        "product_categories":
            List<dynamic>.from(productCategories.map((x) => x)),
        "minimum_amount": minimumAmount,
      };
}
