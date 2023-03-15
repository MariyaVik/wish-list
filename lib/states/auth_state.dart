import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/purchase.dart';

class AuthState extends ChangeNotifier {
  final FirebaseAuth authInst = FirebaseAuth.instance;
  User? user;
  List listPurchases = [];

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
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(account.email);
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
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user?.email);
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
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user?.email);
      userDoc.update({'purchases': listPurchases});
      getPurchase();
      notifyListeners();
    } else {
      throw 'Войдите в аккаунт';
    }
  }
}
