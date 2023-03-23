import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PurchasesState extends ChangeNotifier {
  final CollectionReference collectionUsers =
      FirebaseFirestore.instance.collection('users');
  List listPurchases = [];
  String? message;

  Future<void> getPurchase(User? user) async {
    if (user != null) {
      message = null;
      final userDoc = collectionUsers.doc(user.email);
      userDoc.get().then(
        (DocumentSnapshot doc) {
          print(doc.data().toString());
          if (doc.data() != null) {
            final data = doc.data() as Map<String, dynamic>;
            listPurchases = data['purchases'];
            message = listPurchases.isEmpty ? 'Добавьте список' : '';
          }
          notifyListeners();
        },
        onError: (e) => throw 'Error getting document: $e',
      );
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<Map> addPurchase(User? user, String name) async {
    if (user != null) {
      int currentId = 0;
      if (listPurchases.isNotEmpty) {
        currentId = listPurchases.last['id'] + 1;
      }

      listPurchases.add({'id': currentId, 'name': name});
      final userDoc = collectionUsers.doc(user.email);
      userDoc.update({'purchases': listPurchases});
      message = '';

      notifyListeners();
      return {'id': currentId, 'name': name};
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> deletePurchase(User? user, int index) async {
    if (user != null) {
      int id = listPurchases[index]['id'];

      listPurchases.removeWhere((element) => element['id'] == id);
      if (listPurchases.isEmpty) message = 'Добавьте список';

      final userDoc = collectionUsers.doc(user.email);
      final purchaseDoc = collectionUsers
          .doc(user.email)
          .collection('Purchases')
          .doc(id.toString());

      purchaseDoc.delete();
      userDoc.update({'purchases': listPurchases});

      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }
}
