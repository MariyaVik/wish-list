import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:skillbox_17_8/models/purchase.dart';
import 'package:skillbox_17_8/ui/navigation/main_navigation.dart';
import 'package:skillbox_17_8/ui/theme/theme.dart';

import '../states/auth_state.dart';
import '../data/fake_data.dart';

class PurchasesListPage extends StatefulWidget {
  const PurchasesListPage({super.key});

  @override
  State<PurchasesListPage> createState() => _PurchasesListPageState();
}

class _PurchasesListPageState extends State<PurchasesListPage> {
  final double avatarRadius = 40;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthState>();
    print('на экрпне юзер ${authProvider.user?.displayName}');
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      backgroundColor: AppColor.mainColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AppColor.orange,
                  backgroundImage: NetworkImage(
                      authProvider.user?.photoURL ?? 'assets/no_user.jpg'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Добро пожаловать,',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppColor.backColor),
                      ),
                      Text(
                        authProvider.user?.displayName ?? 'Пользователь',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontSize: 20),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: avatarRadius * 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: authProvider.getPurchase,
                            icon: Icon(
                              Icons.notifications,
                              color: AppColor.backColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authProvider.signOut();
                              print('ВЫШЛИ');
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRouteName.login);
                            },
                            icon: Icon(
                              Icons.exit_to_app_outlined,
                              color: AppColor.backColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.backColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: context.watch<AuthState>().listPurchases.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Slidable(
                      endActionPane:
                          ActionPane(motion: StretchMotion(), children: [
                        SlidableAction(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8)),
                          onPressed: (context) {
                            // purchases.removeAt(index);
                            // setState(() {});
                          },
                          icon: Icons.delete,
                          backgroundColor: AppColor.error,
                        )
                      ]),
                      child: ListTile(
                        onTap: () {
                          print(
                              'id списка ${authProvider.listPurchases[index]['id']}');
                          // Navigator.of(context).pushNamed(
                          //     AppRouteName.necDetails,
                          //     arguments: purchases[index].id);
                        },
                        title: Text(context
                            .watch<AuthState>()
                            .listPurchases[index]['name']),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // mini: true,
        onPressed: addPurchaseDialog,
        child: Icon(Icons.add),
      ),
    ));
  }

  void addPurchaseDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AddPuchaseWidget(purchases: purchases);
        });
    // print('ПЕРЕХОД');
    // Navigator.of(context)
    //     .pushNamed(AppRouteName.necDetails, arguments: purchases.last.id);
  }
}

class AddPuchaseWidget extends StatefulWidget {
  List<Purchase> purchases;
  AddPuchaseWidget({required this.purchases, super.key});

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
        decoration: BoxDecoration(),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          TextField(
            controller: nameController,
            cursorColor: AppColor.mainColor,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Название'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: addPurchase, child: Text('Добавить')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Отмена')),
            ],
          )
        ]),
      ),
    );
  }

  void addPurchase() {
    final authProvider = context.read<AuthState>();
    authProvider.addPurchase(nameController.text);
    Navigator.of(context).pop();
  }
}
