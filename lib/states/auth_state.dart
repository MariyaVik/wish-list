import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/purchase.dart';
import '../models/thing.dart';

class AuthState extends ChangeNotifier {
  final FirebaseAuth authInst = FirebaseAuth.instance;
  final CollectionReference collectionUsers =
      FirebaseFirestore.instance.collection('users');
  User? user;
  List listPurchases = [];
  Map<String, dynamic> purchaseDetails = {};

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
      //   int currentId = 0;
      //   if (listPurchases.isNotEmpty) {
      //     currentId = listPurchases.last['id'] + 1;
      //   }

      purchaseDetails['things'].add({
        'name': thing.name,
        'description': thing.description,
        'who': thing.who,
        'done': thing.done
      });
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
      purchaseDetails['things'].removeAt(index);
      final purchaseDoc =
          collectionUsers.doc(user?.email).collection('Purchases').doc(id);

      purchaseDoc.update({'things': purchaseDetails['things']});

      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }

  Future<void> editThing(Thing thing, int thingIndex) async {
    if (user != null) {
      purchaseDetails['things'][thingIndex]['name'] = thing.name;
      purchaseDetails['things'][thingIndex]['description'] = thing.description;
      purchaseDetails['things'][thingIndex]['who'] = thing.who;

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

      final id = purchaseDetails['id'].toString();

      final userDoc =
          collectionUsers.doc(user?.email).collection('Purchases').doc(id);
      userDoc.update({'things': purchaseDetails['things']});
      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }
}
