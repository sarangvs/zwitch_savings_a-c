import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zwitch_sample/controllers/create_account_controller.dart';

class SavingsAccountCreation extends StatefulWidget {
  const SavingsAccountCreation({Key? key}) : super(key: key);

  @override
  State<SavingsAccountCreation> createState() => _SavingsAccountCreationState();
}

class _SavingsAccountCreationState extends State<SavingsAccountCreation> {
  final savingsAccountController = Get.put(CreateSavingsAccountController());
  late WebViewController controller;
  late InAppWebViewController inAppWebViewController;
  final storage = GetStorage();
  @override
  void initState() {
    // inAppWebViewController = InAppWebViewController();
    super.initState();
    savingsAccountController.onBoardSavingsAccount();
    // controller = WebViewController();
  }

  var name = "testId";

  Future webViewMethodForCamera() async {
    print('In Camera permission method');
    //WidgetsFlutterBinding.ensureInitialized();
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.photos.request();
    await Permission.location.request();
    await Permission.locationAlways.request();
  }

  @override
  Widget build(BuildContext context) {
    const asset = 'assets/payment.html';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: SafeArea(
        child:
            GetBuilder<CreateSavingsAccountController>(builder: (controller) {
          return Center(
            child: savingsAccountController.isTokenLoading
                ? const CircularProgressIndicator()
                : InAppWebView(
                    onLoadStart: (controller, url) {
                      inAppWebViewController = controller;
                      inAppWebViewController.addJavaScriptHandler(
                          handlerName: 'handlerName',
                          callback: (args) {
                            if (args.isNotEmpty) {
                              final customerId = args[0]['data']['data']
                                      ['customer_id']
                                  .toString();

                              storage
                                  .write('customer_id', customerId)
                                  .then((value) {
                                log("Hey bro ur customer id is: " + customerId);
                              });

                              if (args[0]['data']['data']
                                  .toString()
                                  .contains("account_id")) {
                                final accountId = args[0]['data']['data']
                                        ['account_id']
                                    .toString();
                                storage.write('account_id', accountId);
                              }
                            }
                            // final value = args[0];
                            // log(value);
                            // final value = args[0]["customer_id"];
                            // log("valueeeee" + value);

                            return {
                              "token": savingsAccountController.onboardingToken,
                            
                            };
                          });
                    },
                    // initialFile: 'assets/check_balance.html',
                    initialFile: asset,
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

                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      inAppWebViewController = controller;
                      log('message');

                      return null;
                    },

                    onWebViewCreated: (controller) {
                      inAppWebViewController = controller;
                      controller.addJavaScriptHandler(
                          handlerName: 'handlerName',
                          callback: (args) {
                            log('heyyuuuuy$args');
                            // final value = args[0]["account_id"];
                            final value = args[0]["customer_id"];
                            log("valueeeee" + value);
                            return {
                              "token": savingsAccountController.onboardingToken
                            };
                          });
                    },

                    androidOnGeolocationPermissionsShowPrompt:
                        (InAppWebViewController controller,
                            String origin) async {
                      return GeolocationPermissionShowPromptResponse(
                          origin: origin, allow: true, retain: true);
                    },
                    androidOnPermissionRequest:
                        (InAppWebViewController controller, String origin,
                            List<String> resources) async {
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
