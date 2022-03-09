import 'package:flutter/material.dart';
import 'package:receipt_reader/storage.dart';

class Ledger extends StatefulWidget {
  const Ledger({Key? key, required this.storage}) : super(key: key);

  final FormStorage storage;

  @override
  _LedgerState createState() => _LedgerState();
}

class _LedgerState extends State<Ledger> {

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