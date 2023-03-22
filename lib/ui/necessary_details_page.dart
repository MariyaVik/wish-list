import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filters.dart';
import '../models/thing.dart';
import '../states/auth_state.dart';
import '../states/details_state.dart';
import 'theme/theme.dart';
import 'widgets/filter_button.dart';
import 'widgets/necessary_details_widget.dart';

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
          FilterButton(),
        ],
      ),
      body: NecessaryDetailsWidget(),
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
