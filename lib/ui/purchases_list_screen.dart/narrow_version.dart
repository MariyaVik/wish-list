import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/details_state.dart';
import '../../states/purchases_state.dart';
import '../navigation/main_navigation.dart';
import '../widgets/add_purchase_widget.dart';
import 'main_view.dart';

class PurchaseListPagePhone extends StatelessWidget {
  const PurchaseListPagePhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainPage(onPurchaseTap: onTap, addPurchase: addPurchaseDialog);
  }

  void onTap(BuildContext context, int index) {
    Navigator.of(context).pushNamed(AppRouteName.necDetails,
        arguments: context.read<PurchasesState>().listPurchases[index]['id']);
  }

  void addPurchaseDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return const AddPuchaseWidget();
        });
    if (context.mounted) {
      Navigator.of(context).pushNamed(AppRouteName.necDetails,
          arguments: context.read<DetailsState>().purchaseDetails['id']);
    }
  }
}
