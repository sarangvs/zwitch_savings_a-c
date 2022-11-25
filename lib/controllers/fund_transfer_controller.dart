import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class FundTransferController extends GetxController {
  String customerToken = '';
  String transferToken = '';

  void getCustomerTokenForFundTransfer({required String customerId}) async {
    String url = "https://api.zwitch.io/v1/tokens";

    print("customer Id: " + customerId);

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
    print("getCustomerTokenForFundTransfer" + customerToken);
    getTransferToken(customerId: customerId);
  }

  void getTransferToken({required String customerId}) async {
    var rndnumber = "";
    var rnd = Random();
    for (var i = 0; i < 6; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    print("Randum_num" + rndnumber);

    String url = "https://api.zwitch.io/v1/tokens";

    final body = {
      "type": "transfer",
      "customer_id": customerId,
      "merchant_reference_id": rndnumber,
      "metadata": {"hello": "world"}
    };

    final headers = {
      "Authorization":
          "Bearer ak_test_HiaCFNftK9eyofj04dxhj8UdGs5j3wNCyC8L:sk_test_1hppxiMZtkalxThTrHyStJprBDladhptcz4G",
      'content-type': 'application/json',
    };

    final response = await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: headers,
    );

    print(response.body);

    final jsonMap = json.decode(response.body);
    transferToken = jsonMap["session"];
    print("transferToken " + transferToken);
  }
}
