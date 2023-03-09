import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:skillbox_17_8/ui/navigation/main_navigation.dart';
import 'package:skillbox_17_8/ui/theme/theme.dart';

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
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      backgroundColor: AppColor.mainColor,
      // appBar: AppBar(
      //   backgroundColor: AppColor.mainColor,
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: Icon(
      //         Icons.notifications,
      //         color: AppColor.backColor,
      //       ),
      //     )
      //   ],
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AppColor.orange,
                ),
                SizedBox(width: 16),
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
                        'Пользователь',
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
                            icon: Icon(
                              Icons.notifications,
                              color: AppColor.backColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
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
                  itemCount: purchases.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Slidable(
                      endActionPane:
                          ActionPane(motion: StretchMotion(), children: [
                        SlidableAction(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8)),
                          onPressed: (context) {
                            purchases.removeAt(index);
                            setState(() {});
                          },
                          icon: Icons.delete,
                          backgroundColor: AppColor.error,
                        )
                      ]),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              AppRouteName.necDetails,
                              arguments: purchases[index].id);
                        },
                        title: Text(purchases[index].name),
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
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    ));
  }
}
