import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../states/auth_state.dart';
import '../../states/purchases_state.dart';
import '../theme/theme.dart';

class PurchasesListWidget extends StatefulWidget {
  final void Function(int index) onPurchaseTap;
  PurchasesListWidget({required this.onPurchaseTap, super.key});

  @override
  State<PurchasesListWidget> createState() => _PurchasesListWidgetState();
}

class _PurchasesListWidgetState extends State<PurchasesListWidget> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    print('PurchasesListWidget : INIT');
    currentUser = context.read<AuthState>().user;
    context.read<PurchasesState>().getPurchase(currentUser);
  }

  @override
  void dispose() {
    print('PurchasesListWidget : DISPOSE');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PurchasesState purchasesProvider = context.read<PurchasesState>();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.backColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Consumer<PurchasesState>(builder: (context, purch, _) {
            return ListView.builder(
              itemCount: purch.listPurchases.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  endActionPane:
                      ActionPane(motion: const StretchMotion(), children: [
                    SlidableAction(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                      onPressed: (context) {
                        purchasesProvider.deletePurchase(currentUser, index);
                      },
                      icon: Icons.delete,
                      backgroundColor: AppColor.error,
                    )
                  ]),
                  child: ListTile(
                    onTap: () {
                      widget.onPurchaseTap(index);
                    },
                    title: Text(purch.listPurchases[index]['name']),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
