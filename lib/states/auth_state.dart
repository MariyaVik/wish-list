import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
        await saveUser(user);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> signIn() async {
    if (kIsWeb) {
      await signInWithGoogleWeb();
    } else {
      await signInWithGoogle();
    }
  }

  Future<void> signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    try {
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      final us = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      user = us.user;
      print(user?.displayName);
      print('ВОШЛИ');
      await saveUser(user);
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

  Future<void> saveUser(User? user) async {
    if (user != null) {
      final userDoc = collectionUsers.doc(user.email);
      DocumentSnapshot doc = await userDoc.get();
      if (!doc.exists) {
        userDoc.set({
          'email': user.email,
          'name': user.displayName,
          'photoUrl': user.photoURL,
          'purchases': []
        });
        print('СОХРАНИЛИ ЮЗЕРА');
      }
    }
    notifyListeners();
  }
}
