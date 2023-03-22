import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'image_phone.dart' if (dart.library.html) 'image_web.dart';

import '../../states/auth_state.dart';
import '../../states/details_state.dart';
import '../../states/purchases_state.dart';
import '../../states/storage_state.dart';
import '../theme/theme.dart';
import '../widgets/add_purchase_widget.dart';
import '../widgets/add_thing_widget.dart';
import '../widgets/filter_button.dart';
import '../widgets/head.dart';
import '../widgets/necessary_details_widget.dart';
import '../widgets/purchases_list_widget.dart';

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
          child: Scaffold(
            backgroundColor: AppColor.mainColor,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Column(
              children: [
                const Head(),
                PurchasesListWidget(onPurchaseTap: (index) {
                  onTap(context, index);
                }),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                addPurchaseDialog();
              },
              child: const Icon(Icons.add),
            ),
          ),
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
                            : FloatingActionButton(
                                heroTag: null,
                                onPressed: addThingDialog,
                                child: const Icon(Icons.add),
                              ),
                      ),
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

  void addPurchaseDialog() async {
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

  void addThingDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return const AddThingWidget();
        });
  }
}
