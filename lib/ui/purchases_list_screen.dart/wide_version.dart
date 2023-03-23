import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/add_thing_button.dart';
import 'image_phone.dart' if (dart.library.html) 'image_web.dart';

import '../../states/auth_state.dart';
import '../../states/details_state.dart';
import '../../states/purchases_state.dart';
import '../../states/storage_state.dart';
import '../widgets/add_purchase_widget.dart';
import '../widgets/filter_button.dart';
import '../widgets/necessary_details_widget.dart';
import 'main_view.dart';

class PurchaseListPageWeb extends StatefulWidget {
  const PurchaseListPageWeb({Key? key}) : super(key: key);

  @override
  State<PurchaseListPageWeb> createState() => _PurchaseListPageWebState();
}

class _PurchaseListPageWebState extends State<PurchaseListPageWeb> {
  // int? currentId;

  @override
  void initState() {
    super.initState();
    context.read<StorageState>().getImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body:
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: MainPage(onPurchaseTap: onTap, addPurchase: addPurchaseDialog),
        ),
        Consumer2<StorageState, DetailsState>(
            builder: (context, storage, details, _) {
          return Expanded(
              flex: 4,
              child: details.purchaseDetails.isEmpty // НЕ РАБОТАЕТ :( почему?
                  ? storage.imageUrl == null
                      ? const SizedBox()
                      : Center(
                          child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox.square(
                                dimension: 300, child: NoSelectImage()),
                            SizedBox(height: 24),
                            Material(
                                child: Text(
                                    'Выберите покупку или создайте новую')),
                          ],
                        ))
                  : ColoredBox(
                      color: Colors.white,
                      child: Scaffold(
                          appBar: AppBar(
                            automaticallyImplyLeading: false,
                            title: Text(details.purchaseDetails['name'] ?? ''),
                            actions: const [
                              FilterButton(),
                            ],
                          ),
                          body: const NecessaryDetailsWidget(),
                          floatingActionButton: details.purchaseDetails.isEmpty
                              ? null
                              : const AddThingButton()),
                    ));
        }),
      ],
    );
  }

  void onTap(BuildContext context, int index) {
    // currentId = index;
    context.read<DetailsState>().getPurchaseDetails(
        context.read<AuthState>().user,
        context.read<PurchasesState>().listPurchases[index]['id']);
    setState(() {});
  }

  void addPurchaseDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return const AddPuchaseWidget();
        });
    if (context.mounted) {
      context.read<DetailsState>().getPurchaseDetails(
          context.read<AuthState>().user,
          context.read<DetailsState>().purchaseDetails['id']);
      // currentId = context.read<PurchasesState>().listPurchases.length - 1;
    }
    setState(() {});
  }
}
