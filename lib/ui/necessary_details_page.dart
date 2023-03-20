import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:skillbox_17_8/models/thing.dart';
import 'package:skillbox_17_8/ui/theme/theme.dart';

import '../models/filters.dart';
import '../states/auth_state.dart';

class NecessaryDetailsPage extends StatefulWidget {
  final int currentId;
  const NecessaryDetailsPage({required this.currentId, super.key});

  @override
  State<NecessaryDetailsPage> createState() => _NecessaryDetailsPageState();
}

class _NecessaryDetailsPageState extends State<NecessaryDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthState>().getPurchaseDetails(widget.currentId);
    print('NecessaryDetailsPage : INIT');
  }

  @override
  void dispose() {
    print('NecessaryDetailsPage : DISPOSE');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthState>();
    print(authProvider.purchaseDetails);
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              authProvider.currentFilter = Filter.all;
              authProvider.filtredThings = [];
              authProvider.purchaseDetails = {};
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(context.watch<AuthState>().purchaseDetails['name'] ?? ''),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.filter_alt),
            itemBuilder: (BuildContext context) => <PopupMenuItem<Filter>>[
              PopupMenuItem(
                value: Filter.all,
                child: Text('Все'),
                onTap: () {
                  if (authProvider.currentFilter != Filter.all) {
                    authProvider.currentFilter = Filter.all;
                    authProvider.filteringThings();
                  }
                },
              ),
              PopupMenuItem(
                value: Filter.done,
                child: Text('Куплено'),
                onTap: () {
                  if (authProvider.currentFilter != Filter.done) {
                    authProvider.currentFilter = Filter.done;
                    authProvider.filteringThings();
                  }
                },
              ),
              PopupMenuItem(
                value: Filter.undone,
                child: Text('Нужно купить'),
                onTap: () {
                  if (authProvider.currentFilter != Filter.undone) {
                    authProvider.currentFilter = Filter.undone;
                    authProvider.filteringThings();
                  }
                },
              ),
            ],
          )
        ],
      ),
      body: ListView.builder(
          itemCount: context.watch<AuthState>().filtredThings.length,
          // context.watch<AuthState>().purchaseDetails['things']?.length ?? 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print('ВЫПОЛНИЛИ ИЛИ НЕТ');
                authProvider.doneThing(index);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Slidable(
                  endActionPane: ActionPane(motion: StretchMotion(), children: [
                    SlidableAction(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                      onPressed: (context) {
                        print('ДОЛЖНЫ ИЗМЕНИТЬ');
                        editThingDialog(index);
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

                        authProvider.deleteThing(index);
                      },
                      icon: Icons.delete,
                      backgroundColor: AppColor.error,
                      foregroundColor: Colors.black,
                    )
                  ]),
                  child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: context.watch<AuthState>().filtredThings[index]
                                  ['done']
                              ? AppColor.green
                              : null,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColor.greyLight)),
                      child: ListTile(
                        title: Text(
                          context.watch<AuthState>().filtredThings[index]
                              ['name'],
                          style: context.watch<AuthState>().filtredThings[index]
                                  ['done']
                              ? TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                )
                              : null,
                        ),
                        subtitle: Text(context
                            .watch<AuthState>()
                            .filtredThings[index]['description']),
                        trailing: CircleAvatar(
                          child: context.watch<AuthState>().filtredThings[index]
                                      ['who'] ==
                                  null
                              ? null
                              : Text(context
                                  .watch<AuthState>()
                                  .filtredThings[index]['who']),
                        ),
                      )),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        // mini: true,
        onPressed: addThingDialog,
        child: Icon(Icons.add),
      ),
    ));
  }

  void addThingDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AddThingWidget();
        });
  }

  void editThingDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return EditThingWidget(index: index);
        });
  }
}

class EditThingWidget extends StatefulWidget {
  final int index;
  const EditThingWidget({required this.index, super.key});

  @override
  State<EditThingWidget> createState() => _EditThingWidgetState();
}

class _EditThingWidgetState extends State<EditThingWidget> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController commentController = TextEditingController();

  final TextEditingController whoController = TextEditingController();
  int thingId = 0;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthState>();

    final thing = authProvider.filtredThings[widget.index];
    thingId = thing['id'];
    nameController.text = thing['name'];
    commentController.text = thing['description'];
    whoController.text = thing['who'] ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    commentController.dispose();
    whoController.dispose();
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
                border: OutlineInputBorder(), hintText: 'Что добавить?'),
          ),
          TextField(
            controller: commentController,
            cursorColor: AppColor.mainColor,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Комментарий'),
          ),
          TextField(
            controller: whoController,
            cursorColor: AppColor.mainColor,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Кто купит?'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: editThing, child: Text('Сохранить')),
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

  void editThing() {
    final thing = Thing(
        name: nameController.text,
        description: commentController.text,
        who: whoController.text == '' ? null : whoController.text);
    context.read<AuthState>().editThing(thing, thingId);

    print('ИЗМЕНИЛИ');
    Navigator.of(context).pop();
  }
}

class AddThingWidget extends StatefulWidget {
  AddThingWidget({super.key});

  @override
  State<AddThingWidget> createState() => _AddThingWidgetState();
}

class _AddThingWidgetState extends State<AddThingWidget> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController commentController = TextEditingController();

  final TextEditingController whoController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    commentController.dispose();
    whoController.dispose();
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
                border: OutlineInputBorder(), hintText: 'Что добавить?'),
          ),
          TextField(
            controller: commentController,
            cursorColor: AppColor.mainColor,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Комментарий'),
          ),
          TextField(
            controller: whoController,
            cursorColor: AppColor.mainColor,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Кто купит?'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: addThing, child: Text('Добавить')),
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

  void addThing() {
    final authProvider = context.read<AuthState>();
    authProvider.addPurchaseDetails(
        Thing(
            name: nameController.text,
            description: commentController.text,
            who: whoController.text == '' ? null : whoController.text),
        authProvider.purchaseDetails['id']);
    Navigator.of(context).pop();
  }
}
