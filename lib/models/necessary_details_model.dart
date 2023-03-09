import 'package:flutter/material.dart';

import 'thing.dart';

class NecessaryDetailsModel extends ChangeNotifier {
  List<Thing> things = [];

  void add(Thing thing) {
    things.add(thing);
    notifyListeners();
  }

  void remove(Thing thing) {
    things.remove(thing);
    notifyListeners();
  }

  void mark(Thing thing) {
    thing.done = !thing.done;
  }
}
