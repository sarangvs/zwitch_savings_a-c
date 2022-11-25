import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CheckBalanceController extends GetxController {
  String customerToken = '';

  void getCustomerTokenForBalance({required String customerId}) async {
    String url = "https://api.zwitch.io/v1/tokens";

    log("customer Id: " + customerId);

    final body = {
      "type": "customer",
      "customer_id": customerId,
      "metadata": {}
    };

    final headers = {
      "Authorization":
          "Bearer ak_test_HiaCFNftK9eyofj04dxhj8UdGs5j3wNCyC8L:sk_test_1hppxiMZtkalxThTrHyStJprBDladhptcz4G",
      'content-type': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: headers);
    final jsonMap = json.decode(response.body);
    customerToken = jsonMap["session"];
    log("getCustomerTokenForBalance" + customerToken);
  }
}
