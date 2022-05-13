import 'package:flutter/material.dart';
import 'package:receipt_reader/storage.dart';

class Receipts extends StatefulWidget {
  const Receipts({Key? key, required this.storage}) : super(key: key);

  final Storage storage;

  @override
  _ReceiptsState createState() => _ReceiptsState();
}

class _ReceiptsState extends State<Receipts> {

  late Map<String, dynamic> receiptData;
  static const Color textColor = Colors.black;

  Future<void> getData() async {
    Future<Map<String, dynamic>>? data = widget.storage.read();
    receiptData = await data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffdfdfdc),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        defaultColumnWidth: const FixedColumnWidth(120),
                        border: TableBorder.all(
                          color: textColor,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        children: [
                          TableRow(
                            children: [
                              Column(children: const [Text("Place", style: TextStyle(color: textColor, fontSize: 20))],),
                              Column(children: const [Text("Date", style: TextStyle(color: textColor, fontSize: 20))],),
                              Column(children: const [Text("Total", style: TextStyle(color: textColor, fontSize: 20))],),
                            ],
                          ),
                          for (String k in receiptData.keys) TableRow(
                            children: [
                              Column(children: [Text("${receiptData[k]["place"]}", style: const TextStyle(color: textColor, fontSize: 20),)],),
                              Column(children: [Text(convertDate(receiptData[k]["date"]), style: const TextStyle(color: textColor, fontSize: 20),)],),
                              Column(children: [Text("\$${receiptData[k]["total"]}", style: const TextStyle(color: textColor, fontSize: 20),)],),
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

  String convertDate(String initDate) {
    String newDate = "";
    String day;
    String month;
    String year;

    var temp = initDate.split("/");

    month = temp[0];
    day = temp[1];
    year = temp[2];

    if (year.length == 2) {
      year = "20" + year;
    }
    if (month.length == 1) {
      month = "0" + month;
    }
    if (day.length == 1) {
      day = "0" + day;
    }

    newDate = month + "/" + day + "/" + year;

    return newDate;
  }
}