import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/thing.dart';
import '../../states/auth_state.dart';
import '../../states/details_state.dart';
import '../theme/theme.dart';

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

    Navigator.of(context).pop();
  }
}
