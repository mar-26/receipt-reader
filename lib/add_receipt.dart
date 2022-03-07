import 'package:flutter/material.dart';

class AddReceipt extends StatelessWidget {
  const AddReceipt({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Add Receipt"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                  Text("Add Receipt"),
              ],
            ),
          ),
      );
  }
}