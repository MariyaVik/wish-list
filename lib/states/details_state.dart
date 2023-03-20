import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/filters.dart';
import '../models/thing.dart';

class DetailsState extends ChangeNotifier {
  final CollectionReference collectionUsers =
      FirebaseFirestore.instance.collection('users');
  Map<String, dynamic> purchaseDetails = {};

  List filtredThings = [];

  Filter currentFilter = Filter.all;

  Future<void> getPurchaseDetails(User? user, int id) async {
    if (user != null) {
      final purchaseDoc = collectionUsers
          .doc(user.email)
          .collection('Purchases')
          .doc(id.toString());

      await purchaseDoc.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          purchaseDetails = data;
          filteringThings(user);
          print(purchaseDetails);
        },
        onError: (e) => print("Error getting document: $e"),
      );

      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> setPurchaseDetails(User? user, Map info) async {
    if (user != null) {
      final purchaseDoc = collectionUsers
          .doc(user.email)
          .collection('Purchases')
          .doc(info['id'].toString());

      purchaseDetails = {
        'id': info['id'],
        'name': info['name'],
        'things': [],
      };
      filteringThings(user);

      purchaseDoc.set(purchaseDetails);
      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> addPurchaseDetails(
      User? user, Thing thing, int purchaseId) async {
    if (user != null) {
      int currentId = 0;
      if (purchaseDetails['things'].isNotEmpty) {
        currentId = purchaseDetails['things'].last['id'] + 1;
      }

      purchaseDetails['things'].add({
        'id': currentId,
        'name': thing.name,
        'description': thing.description,
        'who': thing.who,
        'done': thing.done
      });
      if (currentFilter == Filter.done) {
        currentFilter = Filter.all;
      }
      filteringThings(user);
      final userDoc = collectionUsers
          .doc(user.email)
          .collection('Purchases')
          .doc(purchaseId.toString());
      userDoc.update({'things': purchaseDetails['things']});
      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> deleteThing(User? user, int index) async {
    if (user != null) {
      final id = purchaseDetails['id'].toString();
      Map curThing = filtredThings[index];
      purchaseDetails['things'].remove(curThing);
      filteringThings(user);
      final purchaseDoc =
          collectionUsers.doc(user.email).collection('Purchases').doc(id);

      purchaseDoc.update({'things': purchaseDetails['things']});

      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> editThing(User? user, Thing thing, int thingId) async {
    if (user != null) {
      Map curThing = purchaseDetails['things']
          .where((element) => element['id'] == thingId)
          .toList()[0];

      int index = purchaseDetails['things'].indexOf(curThing);

      curThing['name'] = thing.name;
      curThing['description'] = thing.description;
      curThing['who'] = thing.who;

      purchaseDetails['things'][index] = curThing;

      final id = purchaseDetails['id'].toString();

      final userDoc =
          collectionUsers.doc(user.email).collection('Purchases').doc(id);
      userDoc.update({'things': purchaseDetails['things']});
      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> doneThing(User? user, int thingIndex) async {
    if (user != null) {
      purchaseDetails['things'][thingIndex]['done'] =
          !purchaseDetails['things'][thingIndex]['done'];

      filteringThings(user);

      final id = purchaseDetails['id'].toString();

      final userDoc =
          collectionUsers.doc(user.email).collection('Purchases').doc(id);
      userDoc.update({'things': purchaseDetails['things']});
      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  void filteringThings(User? user) {
    if (user != null) {
      switch (currentFilter) {
        case Filter.all:
          filtredThings = purchaseDetails['things'];
          break;
        case Filter.done:
          filtredThings = purchaseDetails['things']
              .where((element) => element['done'] == true)
              .toList();
          break;
        case Filter.undone:
          filtredThings = purchaseDetails['things']
              .where((element) => element['done'] == false)
              .toList();
          break;
        default:
          filtredThings = purchaseDetails['things'];
      }

      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }
}
