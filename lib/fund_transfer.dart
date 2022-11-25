import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zwitch_sample/controllers/fund_transfer_controller.dart';

class FundTransfer extends StatefulWidget {
  const FundTransfer({Key? key}) : super(key: key);

  @override
  State<FundTransfer> createState() => _FundTransferState();
}

class _FundTransferState extends State<FundTransfer> {
  final fundTransferController = Get.put(FundTransferController());
  late InAppWebViewController inAppWebViewController;
    final storage = GetStorage();

  @override
  void initState() {
    super.initState();

    String customerId = storage.read('customer_id') ?? '';
    log("cusId from balance check : " + customerId);
    String accountId = storage.read('account_id') ?? '';
    log("accountId from balance check : " + accountId);
    fundTransferController.getCustomerTokenForFundTransfer(
        customerId: customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fund Transfer"),
      ),
      body: Center(
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
                    "token": fundTransferController.customerToken,
                    "transferToken": fundTransferController.transferToken,
                    "accountId": storage.read('account_id'),
                  };
                });
          },
          initialFile: 'assets/fund_transfer.html',
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
      ),
    );
  }
}
