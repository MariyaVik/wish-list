import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/auth_state.dart';
import '../../states/details_state.dart';
import '../../states/purchases_state.dart';
import '../navigation/main_navigation.dart';
import '../theme/theme.dart';
import '../widgets/head.dart';
import '../widgets/purchases_list_widget.dart';

class PurchaseListPagePhone extends StatelessWidget {
  const PurchaseListPagePhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      backgroundColor: AppColor.mainColor,
      body: Column(
        children: [
          const Head(),
          PurchasesListWidget(onPurchaseTap: (index) {
            onTap(context, index);
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addPurchaseDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void onTap(BuildContext context, int index) {
    print(
        'id списка ${context.read<PurchasesState>().listPurchases[index]['id']} И ПЕРЕХОД СЮДА');
    Navigator.of(context).pushNamed(AppRouteName.necDetails,
        arguments: context.read<PurchasesState>().listPurchases[index]['id']);
  }

  void addPurchaseDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return const AddPuchaseWidget();
        });
    print(
        'ПЕРЕХОД ПРИ СОЗДАНИИ В ID ${context.read<DetailsState>().purchaseDetails['id']}');
    Navigator.of(context).pushNamed(AppRouteName.necDetails,
        arguments: context.read<DetailsState>().purchaseDetails['id']);
  }
}

class AddPuchaseWidget extends StatefulWidget {
  const AddPuchaseWidget({super.key});

  @override
  State<AddPuchaseWidget> createState() => _AddPuchaseWidgetState();
}

class _AddPuchaseWidgetState extends State<AddPuchaseWidget> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColor.orangeLight,
      content: Container(
        height: 300,
        decoration: const BoxDecoration(),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          TextField(
            controller: nameController,
            cursorColor: AppColor.mainColor,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Название'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: addPurchase, child: const Text('Добавить')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена')),
            ],
          )
        ]),
      ),
    );
  }

  void addPurchase() async {
    final purchasesProvider = context.read<PurchasesState>();
    final detailsProvider = context.read<DetailsState>();
    final currentUser = context.read<AuthState>().user;
    final info =
        await purchasesProvider.addPurchase(currentUser, nameController.text);
    detailsProvider.setPurchaseDetails(currentUser, info);
    Navigator.of(context).pop();
  }
}
