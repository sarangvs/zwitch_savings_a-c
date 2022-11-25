import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zwitch_sample/controllers/check_balance_controller.dart';

class CheckBalance extends StatefulWidget {
  const CheckBalance({Key? key}) : super(key: key);

  @override
  State<CheckBalance> createState() => _CheckBalanceState();
}

class _CheckBalanceState extends State<CheckBalance> {
  final checkBalanceController = Get.put(CheckBalanceController());
    final storage = GetStorage();

  @override
  void initState() {
    super.initState();

    String customerId = storage.read('customer_id') ?? '';
    log("cusId from balance check : " + customerId);
    String accountId = storage.read('account_id') ?? '';
    log("accountId from balance check : " + accountId);

    checkBalanceController.getCustomerTokenForBalance(customerId: customerId);
  }

  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Balance"),
      ),
      body: SafeArea(
        child: GetBuilder<CheckBalanceController>(builder: (controller) {
          return Center(
            child: InAppWebView(
              onLoadStart: (controller, url) {
                inAppWebViewController = controller;
                inAppWebViewController.addJavaScriptHandler(
                    handlerName: 'handlerName',
                    callback: (args) {
                      log(args.toString());
                      // final value = args[0];
                      // log(value);
                      // final value = args[0]["customer_id"];
                      // log("valueeeee" + value);

                      return {
                        "token": checkBalanceController.customerToken,
                          "accountId": storage.read('account_id'),
                      };
                    });
              },
              initialFile: 'assets/check_balance.html',
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  clearCache: false,
                  cacheEnabled: true,
                ),
              ),
              onConsoleMessage: (controller, consoleMessage) {
                print("Heyya" + jsonDecode(consoleMessage.message));
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                inAppWebViewController = controller;
                log('message');
                // controller.addJavaScriptHandler(
                //     handlerName: 'handlerName',
                //     callback: (args) {
                //       log('heyyy$args');

                //       return {};
                //     });
                return null;
              },
              onWebViewCreated: (controller) {
                inAppWebViewController = controller;
                // controller.addJavaScriptHandler(
                //     handlerName: 'handlerName',
                //     callback: (args) {
                //       log('heyyy$args');

                //       return {};
                //     });
              },
              androidOnGeolocationPermissionsShowPrompt:
                  (InAppWebViewController controller, String origin) async {
                return GeolocationPermissionShowPromptResponse(
                    origin: origin, allow: true, retain: true);
              },
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
