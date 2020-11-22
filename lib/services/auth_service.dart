import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:go_to_laser_store/config.dart';
import 'package:go_to_laser_store/models/customer_model.dart';

abstract class AuthBase {
  Future<bool> createCustomer(CustomerModel model);
}

class Auth extends AuthBase {
  @override
  Future<bool> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode(Config.consumerKey + ":" + Config.consumerSecret),
    );
    bool ret = false;

    try {
      var response = await Dio().post(Config.baseUrl + Config.customerUrl,
          data: model.toJson(),
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Basic $authToken",
            HttpHeaders.contentTypeHeader: "application/json"
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        /// duplicate user
        ret = false;
      } else {
        ret = false;
      }
    }
    return ret;
  }
}
