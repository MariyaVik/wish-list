import 'package:skillbox_17_8/models/thing.dart';

class Purchase {
  final String name;
  final int id;
  List<Thing> things;
  Purchase({
    required this.name,
    required this.id,
    List<Thing>? things,
  }) : things = things ?? [];
}
