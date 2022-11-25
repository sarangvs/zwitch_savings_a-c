import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zwitch_sample/controllers/account_statement_controller.dart';

class AccountStatement extends StatefulWidget {
  const AccountStatement({Key? key}) : super(key: key);

  @override
  State<AccountStatement> createState() => _AccountStatementState();
}

class _AccountStatementState extends State<AccountStatement> {
  final accountStatementController = Get.put(AccountStatementController());
  late InAppWebViewController inAppWebViewController;
    final storage = GetStorage();

  @override
  void initState() {
    super.initState();

    String customerId = storage.read('customer_id') ?? '';
    log("cusId from balance check : " + customerId);
    String accountId = storage.read('account_id') ?? '';
    log("accountId from balance check : " + accountId);
    accountStatementController.getCustomerTokenForAccountStatement(
        customerId: customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Statement"),
      ),
      body: Center(
        child: InAppWebView(
          onLoadStart: (controller, url) {
            inAppWebViewController = controller;
            inAppWebViewController.addJavaScriptHandler(
                handlerName: 'handlerName',
                callback: (args) {
                  log(args.toString());

                  return {"token": accountStatementController.customerToken,
                  "accountId": storage.read('account_id'),
                  };
                });
          },
          initialFile: 'assets/account_statement.html',
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

            return null;
          },
          onWebViewCreated: (controller) {
            inAppWebViewController = controller;
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
      ),
    );
  }
}
