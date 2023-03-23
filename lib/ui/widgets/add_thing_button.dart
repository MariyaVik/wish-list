import 'package:flutter/material.dart';

import 'add_thing_widget.dart';

class AddThingButton extends StatelessWidget {
  const AddThingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        addThingDialog(context);
      },
      child: const Icon(Icons.add),
    );
  }

  void addThingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const AddThingWidget();
        });
  }
}
