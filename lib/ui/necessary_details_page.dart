import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/filters.dart';
import '../models/thing.dart';
import '../states/auth_state.dart';
import '../states/details_state.dart';
import 'theme/theme.dart';

class NecessaryDetailsPage extends StatefulWidget {
  final int currentId;
  const NecessaryDetailsPage({required this.currentId, super.key});

  @override
  State<NecessaryDetailsPage> createState() => _NecessaryDetailsPageState();
}

class _NecessaryDetailsPageState extends State<NecessaryDetailsPage> {
  User? currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = context.read<AuthState>().user;
    context
        .read<DetailsState>()
        .getPurchaseDetails(currentUser, widget.currentId);
    print('NecessaryDetailsPage : INIT');
  }

  @override
  void dispose() {
    print('NecessaryDetailsPage : DISPOSE');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailsProvider = context.read<DetailsState>();
    print(detailsProvider.purchaseDetails);
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              detailsProvider.currentFilter = Filter.all;
              detailsProvider.filtredThings = [];
              detailsProvider.purchaseDetails = {};
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Consumer<DetailsState>(builder: (context, details, _) {
          return Text(details.purchaseDetails['name'] ?? '');
        }),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.filter_alt),
            itemBuilder: (BuildContext context) => <PopupMenuItem<Filter>>[
              PopupMenuItem(
                value: Filter.all,
                child: const Text('Все'),
                onTap: () {
                  if (detailsProvider.currentFilter != Filter.all) {
                    detailsProvider.currentFilter = Filter.all;
                    detailsProvider.filteringThings(currentUser);
                  }
                },
              ),
              PopupMenuItem(
                value: Filter.done,
                child: const Text('Куплено'),
                onTap: () {
                  if (detailsProvider.currentFilter != Filter.done) {
                    detailsProvider.currentFilter = Filter.done;
                    detailsProvider.filteringThings(currentUser);
                  }
                },
              ),
              PopupMenuItem(
                value: Filter.undone,
                child: const Text('Нужно купить'),
                onTap: () {
                  if (detailsProvider.currentFilter != Filter.undone) {
                    detailsProvider.currentFilter = Filter.undone;
                    detailsProvider.filteringThings(currentUser);
                  }
                },
              ),
            ],
          )
        ],
      ),
      body: Consumer<DetailsState>(builder: (context, details, _) {
        return ListView.builder(
            itemCount: details.filtredThings.length,
            // context.watch<AuthState>().purchaseDetails['things']?.length ?? 0,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print('ВЫПОЛНИЛИ ИЛИ НЕТ');
                  detailsProvider.doneThing(currentUser, index);
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

                          detailsProvider.deleteThing(currentUser, index);
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
      }),
      floatingActionButton: FloatingActionButton(
        // mini: true,
        onPressed: addThingDialog,
        child: const Icon(Icons.add),
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
    final detailsProvider = context.read<DetailsState>();

    final thing = detailsProvider.filtredThings[widget.index];
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
        decoration: const BoxDecoration(),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          TextField(
            controller: nameController,
            cursorColor: AppColor.mainColor,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Что добавить?'),
          ),
          TextField(
            controller: commentController,
            cursorColor: AppColor.mainColor,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Комментарий'),
          ),
          TextField(
            controller: whoController,
            cursorColor: AppColor.mainColor,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Кто купит?'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: editThing, child: const Text('Сохранить')),
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

  void editThing() {
    final currentUser = context.read<AuthState>().user;
    final thing = Thing(
        name: nameController.text,
        description: commentController.text,
        who: whoController.text == '' ? null : whoController.text);
    context.read<DetailsState>().editThing(currentUser, thing, thingId);

    print('ИЗМЕНИЛИ');
    Navigator.of(context).pop();
  }
}

class AddThingWidget extends StatefulWidget {
  const AddThingWidget({super.key});

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
        decoration: const BoxDecoration(),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          TextField(
            controller: nameController,
            cursorColor: AppColor.mainColor,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Что добавить?'),
          ),
          TextField(
            controller: commentController,
            cursorColor: AppColor.mainColor,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Комментарий'),
          ),
          TextField(
            controller: whoController,
            cursorColor: AppColor.mainColor,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Кто купит?'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: addThing, child: const Text('Добавить')),
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

  void addThing() {
    final currentUser = context.read<AuthState>().user;
    final detailsProvider = context.read<DetailsState>();
    detailsProvider.addPurchaseDetails(
        currentUser,
        Thing(
            name: nameController.text,
            description: commentController.text,
            who: whoController.text == '' ? null : whoController.text),
        detailsProvider.purchaseDetails['id']);
    Navigator.of(context).pop();
  }
}
