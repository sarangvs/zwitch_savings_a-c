import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CreateSavingsAccountController extends GetxController {
  String onboardingToken = '';

  bool _isTokenLoading = false;

  bool get isTokenLoading => _isTokenLoading;
  set isTokenLoading(bool val) {
    _isTokenLoading = val;
    update();
  }

  void onBoardSavingsAccount() async {
    isTokenLoading = true;
    String url = "https://api.zwitch.io/v1/tokens";

    final body = {"type": "onboarding", "metadata": {}};

    final headers = {
      "Authorization":
          "Bearer ak_test_HiaCFNftK9eyofj04dxhj8UdGs5j3wNCyC8L:sk_test_1hppxiMZtkalxThTrHyStJprBDladhptcz4G",
      'content-type': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: headers);
    final jsonMap = json.decode(response.body);
    // log("onBoardSavingsAccount res " + jsonMap.toString());
    // log("onBoardSavingsAccount Token " + jsonMap["session"]);

    onboardingToken = jsonMap["session"];
    isTokenLoading = false;
    update();
    // log(onboardingToken);
  }
}
