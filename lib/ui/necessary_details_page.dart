import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:skillbox_17_8/models/thing.dart';
import 'package:skillbox_17_8/ui/theme/theme.dart';

import '../data/fake_data.dart';

class NecessaryDetailsPage extends StatefulWidget {
  final int id;
  const NecessaryDetailsPage({required this.id, super.key});

  @override
  State<NecessaryDetailsPage> createState() => _NecessaryDetailsPageState();
}

class _NecessaryDetailsPageState extends State<NecessaryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      appBar: AppBar(
        title: Text(purchases[widget.id].name),
      ),
      body: ListView.builder(
          itemCount: purchases[widget.id].things.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                purchases[widget.id].things[index].done =
                    !purchases[widget.id].things[index].done;
                setState(() {});
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
                        editThingDialog(
                            index); // ОБНОВЛЯТЬ-----------------------------------------------------------------------
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
                        purchases[widget.id].things.removeAt(index);
                        setState(() {});
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
                          color: purchases[widget.id].things[index].done
                              ? AppColor.green
                              : null,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColor.greyLight)),
                      child: ListTile(
                        title: Text(
                          purchases[widget.id].things[index].name,
                          style: purchases[widget.id].things[index].done
                              ? TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                )
                              : null,
                        ),
                        subtitle: Text(
                            purchases[widget.id].things[index].description),
                        trailing: CircleAvatar(
                          child: Text(purchases[widget.id].things[index].who),
                        ),
                      )),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        // mini: true,
        onPressed:
            addThingDialog, // ОБНОВЛЯТЬ--------------------------------------------------------------------------------
        child: Icon(Icons.add),
      ),
    ));
  }

  void addThingDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AddThingWidget(things: purchases[widget.id].things);
        });
  }

  void editThingDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return EditThingWidget(thing: purchases[widget.id].things[index]);
        });
  }
}

class EditThingWidget extends StatefulWidget {
  final Thing thing;
  const EditThingWidget({required this.thing, super.key});

  @override
  State<EditThingWidget> createState() => _EditThingWidgetState();
}

class _EditThingWidgetState extends State<EditThingWidget> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController commentController = TextEditingController();

  final TextEditingController whoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.thing.name;
    commentController.text = widget.thing.description;
    whoController.text = widget.thing.who;
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
    widget.thing
      ..name = nameController.text
      ..description = commentController.text
      ..who = whoController.text;
    Navigator.of(context).pop();
  }
}

class AddThingWidget extends StatefulWidget {
  List<Thing> things;
  AddThingWidget({required this.things, super.key});

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
    widget.things.add(Thing(
        name: nameController.text,
        description: commentController.text,
        who: whoController.text));
    Navigator.of(context).pop();
  }
}
