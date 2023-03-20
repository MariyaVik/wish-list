import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/filters.dart';
import '../models/purchase.dart';
import '../models/thing.dart';

class AuthState extends ChangeNotifier {
  final FirebaseAuth authInst = FirebaseAuth.instance;
  final CollectionReference collectionUsers =
      FirebaseFirestore.instance.collection('users');
  User? user;
  List listPurchases = [];
  Map<String, dynamic> purchaseDetails = {};

  List filtredThings = [];

  Filter currentFilter = Filter.all;

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      print(account?.email);

      if (account != null) {
        final GoogleSignInAuthentication auth = await account.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );

        final us = await authInst.signInWithCredential(credential);
        user = us.user;
        print(user?.displayName);
        print('ВОШЛИ');
        getPurchase();
        await saveUser(account);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn()
        .signOut(); // для того, чтобы при следующем входе появилось диалоговое окно с вариантами входа
    user = null;
    notifyListeners();
  }

  Future<void> saveUser(GoogleSignInAccount account) async {
    final userDoc = collectionUsers.doc(account.email);
    DocumentSnapshot doc = await userDoc.get();
    if (!doc.exists) {
      userDoc.set({
        'email': account.email,
        'name': account.displayName,
        'photoUrl': account.photoUrl,
        'purchases': []
      });
      print('СОХРАНИЛИ ЮЗЕРА');
    }
    notifyListeners();
  }

  Future<void> getPurchase() async {
    if (user != null) {
      final userDoc = collectionUsers.doc(user?.email);
      userDoc.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          listPurchases = data['purchases'];
          print(listPurchases);
        },
        onError: (e) => print("Error getting document: $e"),
      );
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> addPurchase(String name) async {
    if (user != null) {
      int currentId = 0;
      if (listPurchases.isNotEmpty) {
        currentId = listPurchases.last['id'] + 1;
      }

      listPurchases.add({'id': currentId, 'name': name});
      final userDoc = collectionUsers.doc(user?.email);
      userDoc.update({'purchases': listPurchases});

      final purchaseDoc = collectionUsers
          .doc(user?.email)
          .collection('Purchases')
          .doc(currentId.toString());

      purchaseDetails = {
        'id': currentId,
        'name': name,
        'things': [],
      };
      filteringThings();

      purchaseDoc.set(purchaseDetails);

      // getPurchase();
      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> getPurchaseDetails(int id) async {
    if (user != null) {
      final purchaseDoc = collectionUsers
          .doc(user?.email)
          .collection('Purchases')
          .doc(id.toString());

      await purchaseDoc.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          purchaseDetails = data;
          filteringThings();
          print(purchaseDetails);
        },
        onError: (e) => print("Error getting document: $e"),
      );

      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> addPurchaseDetails(Thing thing, int purchaseId) async {
    if (user != null) {
      int currentId = 0;
      if (purchaseDetails['things'].isNotEmpty) {
        currentId = purchaseDetails['things'].last['id'] + 1;
      }

      purchaseDetails['things'].add({
        'id': collectionUsers,
        'name': thing.name,
        'description': thing.description,
        'who': thing.who,
        'done': thing.done
      });
      if (currentFilter == Filter.done) {
        currentFilter = Filter.all;
      }
      filteringThings();
      final userDoc = collectionUsers
          .doc(user?.email)
          .collection('Purchases')
          .doc(purchaseId.toString());
      userDoc.update({'things': purchaseDetails['things']});
      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> deleteThing(int index) async {
    if (user != null) {
      final id = purchaseDetails['id'].toString();
      Map curThing = filtredThings[index];
      print('ДЛЯ ПРОВЕРКИ' + purchaseDetails['things'].toString());

      purchaseDetails['things'].remove(curThing);
      print('ДЛЯ ПРОВЕРКИ' + purchaseDetails['things'].toString());
      filteringThings();
      final purchaseDoc =
          collectionUsers.doc(user?.email).collection('Purchases').doc(id);

      purchaseDoc.update({'things': purchaseDetails['things']});

      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> editThing(Thing thing, int thingId) async {
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
          collectionUsers.doc(user?.email).collection('Purchases').doc(id);
      userDoc.update({'things': purchaseDetails['things']});
      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> doneThing(int thingIndex) async {
    if (user != null) {
      purchaseDetails['things'][thingIndex]['done'] =
          !purchaseDetails['things'][thingIndex]['done'];

      filteringThings();

      final id = purchaseDetails['id'].toString();

      final userDoc =
          collectionUsers.doc(user?.email).collection('Purchases').doc(id);
      userDoc.update({'things': purchaseDetails['things']});
      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> deletePurchase(int index) async {
    if (user != null) {
      int id = listPurchases[index]['id'];

      listPurchases.removeWhere((element) => element['id'] == id);

      final userDoc = collectionUsers.doc(user?.email);
      final purchaseDoc = collectionUsers
          .doc(user?.email)
          .collection('Purchases')
          .doc(id.toString());

      purchaseDoc.delete();
      userDoc.update({'purchases': listPurchases});

      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  void filteringThings() {
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
