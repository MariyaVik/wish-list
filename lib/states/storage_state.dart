import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageState extends ChangeNotifier {
  final storage = FirebaseStorage.instance;
  String? imageUrl;
  Future<void> getImageUrl() async {
    try {
      imageUrl = await storage.ref('candy.png').getDownloadURL();
      notifyListeners();
    } catch (error) {
      throw 'Something went wrong :(\n ${error.toString()}';
    }
  }
}
