import 'package:skillbox_17_8/models/thing.dart';

import '../models/purchase.dart';

List<Purchase> purchases = [
  Purchase(name: 'День рождения', id: 0),
  Purchase(
      name: 'Новый год и Рождество',
      id: 1,
      things: List<Thing>.generate(
          5,
          (index) => Thing(
              name: 'Вещь $index',
              done: index % 2 == 0.0,
              description: 'Что-то необычное 2 кг'))),
  Purchase(
      name: 'День благодарения',
      id: 2,
      things: List<Thing>.generate(
          20,
          (index) => Thing(
              name: 'Вещь $index',
              done: index % 2 != 0.0,
              who: 'Мистер Инглиш'))),
  ...List<Purchase>.generate(
      16,
      (index) => Purchase(
          name: 'Ещё $index',
          id: index,
          things: index % 2 == 1
              ? List<Thing>.generate(
                  18,
                  (index) => Thing(
                      name: 'Вещь $index',
                      done: index % 2 == 0.0,
                      description: 'Этого нужно $index кило'))
              : List.empty(growable: true))),
];
