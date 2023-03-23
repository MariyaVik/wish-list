import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../widgets/head.dart';
import '../widgets/purchases_list_widget.dart';

class MainPage extends StatelessWidget {
  final Function(BuildContext, int) onPurchaseTap;
  final Function(BuildContext) addPurchase;
  const MainPage(
      {required this.onPurchaseTap, required this.addPurchase, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: AppColor.mainColor,
      body: Column(
        children: [
          const Head(),
          PurchasesListWidget(onPurchaseTap: (index) {
            onPurchaseTap(context, index);
          }),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: FloatingActionButton(
          onPressed: () {
            addPurchase(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
