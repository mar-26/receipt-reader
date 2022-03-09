import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receipt_reader/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';

class FormStorage {
  bool _initialized = false;

  Future<void> initializeDefault() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseConfig.platformOptions);
    _initialized = true;
  }

  FormStorage() {
    initializeDefault();
  }

  Future<bool> write(String collection, String doc, String key, String name) async {
    if (!_initialized) {
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
      .collection(collection)
      .doc(doc)
      .set({
          key: name,
      })
      .then((value) => print("Data Added"))
      .catchError((error) => print("Failed to update: $error"));
    return true;
  }

  Future<String> read(String collection, String doc, String key) async {
    if (!_initialized) {
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot value =
      await firestore
        .collection(collection)
        .doc(doc).get();
    Map<String, dynamic>? data = (value.data()) as Map<String, dynamic>?;
    return data![key];
  }
}