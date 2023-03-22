import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../states/auth_state.dart';
import '../../states/details_state.dart';
import '../necessary_details_page.dart';
import '../theme/theme.dart';

class NecessaryDetailsWidget extends StatelessWidget {
  const NecessaryDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsState>(builder: (context, details, ch) {
      return ListView.builder(
          itemCount: details.filtredThings.length,
          // context.watch<AuthState>().purchaseDetails['things']?.length ?? 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print('ВЫПОЛНИЛИ ИЛИ НЕТ');
                context
                    .read<DetailsState>()
                    .doneThing(context.read<AuthState>().user, index);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Slidable(
                  endActionPane:
                      ActionPane(motion: const StretchMotion(), children: [
                    SlidableAction(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                      onPressed: (context) {
                        print('ДОЛЖНЫ ИЗМЕНИТЬ');
                        editThingDialog(context, index);
                      },
                      icon: Icons.edit,
                      backgroundColor: AppColor.orangeLight,
                      // foregroundColor: Colors.white,
                    ),
                    SlidableAction(
                      // borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(8),
                      //     bottomLeft: Radius.circular(8)),
                      onPressed: (context) {
                        print('ДОЛЖНЫ УДАЛИТЬ');

                        context
                            .read<DetailsState>()
                            .deleteThing(context.read<AuthState>().user, index);
                      },
                      icon: Icons.delete,
                      backgroundColor: AppColor.error,
                      foregroundColor: Colors.black,
                    )
                  ]),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: details.filtredThings[index]['done']
                              ? AppColor.green
                              : null,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColor.greyLight)),
                      child: ListTile(
                        title: Text(
                          details.filtredThings[index]['name'],
                          style: details.filtredThings[index]['done']
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                )
                              : null,
                        ),
                        subtitle:
                            Text(details.filtredThings[index]['description']),
                        trailing: CircleAvatar(
                          child: details.filtredThings[index]['who'] == null
                              ? null
                              : Text(details.filtredThings[index]['who']),
                        ),
                      )),
                ),
              ),
            );
          });
    });
  }

  void editThingDialog(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return EditThingWidget(index: index);
        });
  }
}
