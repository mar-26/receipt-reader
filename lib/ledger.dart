import 'package:flutter/material.dart';

class Ledger extends StatelessWidget {
  const Ledger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Ledger"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                  Text("Ledger"),
              ],
            ),
          ),
      );
  }
}