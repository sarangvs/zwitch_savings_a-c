import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zwitch_sample/account_statement.dart';
import 'package:zwitch_sample/check_balance.dart';
import 'package:zwitch_sample/fund_transfer.dart';
import 'package:zwitch_sample/web_viewer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
              title: const Text("Savings A/C creation"),
              onTap: () {
                Get.to(() => const SavingsAccountCreation());
              },
            ),
            ListTile(
              title: const Text("Check Your A/c balance"),
              onTap: () {
                Get.to(() => const CheckBalance());
              },
              leading: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
            ),
            ListTile(
              title: const Text("Bank Statement"),
              onTap: () {
                Get.to(() => const AccountStatement());
              },
              leading: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
            ),
            ListTile(
              title: const Text("Fund Transfer"),
              onTap: () {
                Get.to(() => const FundTransfer());
              },
              leading: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
