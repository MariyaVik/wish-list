import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth authInst = FirebaseAuth.instance;
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
}
