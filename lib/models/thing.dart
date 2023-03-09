class Thing {
  String name;
  String description;
  String who;
  bool done;
  Thing(
      {required this.name,
      this.done = false,
      this.description = '',
      this.who = 'Это буду я'});
}
