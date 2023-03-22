import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html';
import 'dart:ui' as ui;

import '../../states/auth_state.dart';
import '../../states/details_state.dart';
import '../../states/purchases_state.dart';
import '../../states/storage_state.dart';
import '../necessary_details_page.dart';
import '../theme/theme.dart';
import '../widgets/filter_button.dart';
import '../widgets/head.dart';
import '../widgets/necessary_details_widget.dart';
import '../widgets/purchases_list_widget.dart';
import 'phone_version.dart';

class PurchaseListPageWeb extends StatefulWidget {
  PurchaseListPageWeb({Key? key}) : super(key: key);

  @override
  State<PurchaseListPageWeb> createState() => _PurchaseListPageWebState();
}

class _PurchaseListPageWebState extends State<PurchaseListPageWeb> {
  int? currentId;

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
        Consumer<StorageState>(builder: (context, storage, _) {
          return Expanded(
              flex: 4,
              child: currentId == null
                  ? storage.imageUrl == null
                      ? const SizedBox()
                      : Center(
                          child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox.square(dimension: 300, child: MyImage()),
                            const SizedBox(height: 24),
                            const Material(
                                child: Text(
                                    'Выберите покупку или создайте новую')),
                          ],
                        ))
                  : ColoredBox(
                      color: Colors.white,
                      child: Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: false,
                          title: Consumer<DetailsState>(
                              builder: (context, details, _) {
                            return Text(details.purchaseDetails['name'] ?? '');
                          }),
                          actions: [
                            FilterButton(),
                          ],
                        ),
                        body: Column(
                          children: [
                            Expanded(child: NecessaryDetailsWidget()),
                          ],
                        ),
                        floatingActionButton: currentId == null
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
    // floatingActionButton: FloatingActionButton(
    //         onPressed: addThingDialog,
    //         child: const Icon(Icons.add),
    //       ),
    // );
  }

  void onTap(BuildContext context, int index) {
    print(
        'id списка ${context.read<PurchasesState>().listPurchases[index]['id']} И ПОКАЗЫВАЕМ');
    currentId = index;
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
    print(
        'ПОКАЗ ПРИ СОЗДАНИИ ID ${context.read<DetailsState>().purchaseDetails['id']}');
    context.read<DetailsState>().getPurchaseDetails(
        context.read<AuthState>().user,
        context.read<DetailsState>().purchaseDetails['id']); // НЕ РАБОТАЕТ
    currentId = context.read<PurchasesState>().listPurchases.length - 1;
    setState(() {});
  }

  void addThingDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AddThingWidget();
        });
  }
}

class MyImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String imageUrl = context.read<StorageState>().imageUrl!;
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      imageUrl,
      (int _) => ImageElement()
        ..src = imageUrl
        ..style.width = '100%'
        ..style.height = '100%',
    );
    return HtmlElementView(
      viewType: imageUrl,
    );
  }
}
