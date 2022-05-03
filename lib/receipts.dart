import 'package:flutter/material.dart';
import 'package:receipt_reader/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Receipts extends StatefulWidget {
  const Receipts({Key? key, required this.storage}) : super(key: key);

  final Storage storage;

  @override
  _ReceiptsState createState() => _ReceiptsState();
}

class _ReceiptsState extends State<Receipts> {

  late Map<String, dynamic> receiptData;

  Future<void> getData() async {
    Future<Map<String, dynamic>>? data = widget.storage.read("users", FirebaseAuth.instance.currentUser!.uid);
    receiptData = await data;
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(20),
                  child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Table(
                            defaultColumnWidth: const FixedColumnWidth(120),
                            border: TableBorder.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            children: [
                              TableRow(
                                children: [
                                  Column(children: const [Text("Place", style: TextStyle(fontSize: 20))],),
                                  Column(children: const [Text("Date", style: TextStyle(fontSize: 20))],),
                                  Column(children: const [Text("Total", style: TextStyle(fontSize: 20))],),
                                ],
                              ),
                              for (String k in receiptData.keys) TableRow(
                                children: [
                                  Column(children: [Text("${receiptData[k]["place"]}", style: const TextStyle(fontSize: 20),)],),
                                  Column(children: [Text("${receiptData[k]["date"]}", style: const TextStyle(fontSize: 20),)],),
                                  Column(children: [Text("${receiptData[k]["total"]}", style: const TextStyle(fontSize: 20),)],),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      else {
                        return const CircularProgressIndicator();
                      }
                    }
                  ),
                )
              ],
            ),
          ),
      );
  }
}