import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
        appId: "1:883850492474:web:485aa1e32afd8d83055303",
        apiKey: "AIzaSyConNf2UAymj07JjJudTm3GWE093Fswxto",
        projectId: "capstone-35a6c",
        authDomain: "capstone-35a6c.firebaseapp.com",
        storageBucket: "capstone-35a6c.appspot.com",
        messagingSenderId: "883850492474",
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:883850492474:ios:9f5033dfcf27f9c9055303',
        apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
        projectId: 'capstone-35a6c',
        messagingSenderId: '448618578101',
        storageBucket: 'capstone-35a6c.appspot.com',
        iosBundleId: 'com.rr.receiptReader',
      );
    }
    else {
      // Android
      return const FirebaseOptions(
        appId: '1:883850492474:android:a6c326faa0bf6524055303',
        apiKey: 'AIzaSyC0jFQxlmrNPqnS_0-fHn3f6kN6TGJnozY',
        projectId: 'capstone-35a6c',
        storageBucket: "capstone-35a6c.appspot.com",
        messagingSenderId: '883850492474',
      );
    }
  }
}
