// To parse this JSON data, do
//
//     final customerModel = customerModelFromJson(jsonString);

import 'dart:convert';

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  CustomerModel({
    this.email,
    this.firstName,
    this.lastName,
    this.password,
  });

  String email;
  String firstName;
  String lastName;
  String password;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "password": password,
        "username": email
      };
}
