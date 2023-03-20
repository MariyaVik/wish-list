import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../states/auth_state.dart';
import '../states/details_state.dart';
import '../states/purchases_state.dart';
import 'navigation/main_navigation.dart';
import 'theme/theme.dart';

class PurchasesListPage extends StatefulWidget {
  const PurchasesListPage({super.key});

  @override
  State<PurchasesListPage> createState() => _PurchasesListPageState();
}

class _PurchasesListPageState extends State<PurchasesListPage> {
  final double avatarRadius = 40;
  User? currentUser;
  @override
  void initState() {
    super.initState();
    print('PurchasesListPage : INIT');
    currentUser = context.read<AuthState>().user;
    context.read<PurchasesState>().getPurchase(currentUser);
  }

  @override
  void dispose() {
    print('PurchasesListPage : DISPOSE');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('PurchasesListPage : BUILD');
    final authProvider = context.read<AuthState>();
    final purchasesProvider = context.read<PurchasesState>();
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
                            onPressed: () {},
                            icon: const Icon(
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
                            icon: const Icon(
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
                child: Consumer<PurchasesState>(builder: (context, purch, _) {
                  return ListView.builder(
                    itemCount: purch.listPurchases.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Slidable(
                        endActionPane:
                            ActionPane(motion: StretchMotion(), children: [
                          SlidableAction(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            onPressed: (context) {
                              purchasesProvider.deletePurchase(
                                  currentUser, index);
                            },
                            icon: Icons.delete,
                            backgroundColor: AppColor.error,
                          )
                        ]),
                        child: ListTile(
                          onTap: () async {
                            print(
                                'id списка ${purchasesProvider.listPurchases[index]['id']} И ПЕРЕХОД СЮДА');
                            Navigator.of(context).pushNamed(
                                AppRouteName.necDetails,
                                arguments: purchasesProvider
                                    .listPurchases[index]['id']);
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // mini: true,
        onPressed: addPurchaseDialog,
        child: const Icon(Icons.add),
      ),
    ));
  }

  void addPurchaseDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AddPuchaseWidget();
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
