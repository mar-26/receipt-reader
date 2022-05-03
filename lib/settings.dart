import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text("Sign out"),
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            await FirebaseAuth.instance.signOut();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      );
  }
}