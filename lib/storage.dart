import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receipt_reader/firebase_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Storage {
  bool _initialized = false;

  Future<void> initializeDefault() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseConfig.platformOptions);
    _initialized = true;
  }

  Storage() {
    initializeDefault();
  }

  Future<bool> write(String collection, String doc, Map<String, dynamic> data) async {
    if (!_initialized) {
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String key = const Uuid().v1().toString();

    var checkDoc = await firestore.collection(collection).doc(doc).get();
    if (checkDoc.exists) {
      firestore
        .collection(collection)
        .doc(doc)
        .update({
            key: data,
        })
        .then((value) => print("Data Added"))
        .catchError((error) => print("Failed to update: $error"));
    }
    else {
      firestore
        .collection(collection)
        .doc(doc)
        .set({
            key: data,
        })
        .then((value) => print("Data Added"))
        .catchError((error) => print("Failed to update: $error"));
    }

    return true;
  }

  Future<Map<String, dynamic>> read() async {
    if (!_initialized) {
      await initializeDefault();
    }
    Map<String, dynamic> data;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot value =
      await firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (value.data() == null) {
      data = {};
    }
    else {
      data = (value.data()) as Map<String, dynamic>;
    }
    return data;
  }
}