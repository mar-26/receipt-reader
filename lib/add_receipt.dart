import 'package:uuid/uuid.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:receipt_reader/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_ml_kit/google_ml_kit.dart';


class AddReceipt extends StatefulWidget {
  const AddReceipt({Key? key, required this.camera, required this.storage}) : super(key: key);
  final CameraDescription camera;
  final Storage storage;

  @override
  _AddReceiptState createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {
  final _picker = ImagePicker();
  late String _imagePath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, home: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                child: Text("Please select an image by taking a picture or by selecting one from the gallery.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ),
            ),
            ElevatedButton(
              child: const Text("Take Picture"),
              onPressed: () async {
                _imagePath = (await _picker.pickImage(source: ImageSource.camera))!.path;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Review(storage: widget.storage, imagePath: _imagePath))
                );
              },
            ),
            ElevatedButton(
              child: const Text("Gallery"),
              onPressed: () async {
                _imagePath = (await _picker.pickImage(source: ImageSource.gallery))!.path;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Review(storage: widget.storage, imagePath: _imagePath))
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Review extends StatefulWidget {
  const Review({Key? key, required this.storage, required this.imagePath}) : super(key: key);
  final Storage storage;
  final String imagePath;

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
    // main data structor
    Map<String, dynamic> data = {};
    late TextEditingController placeController;
    late TextEditingController dateController;
    late TextEditingController totalController;

  Future<Map<String, dynamic>> processImage() async {
    // supporting data structors
    var dateRegex = RegExp(r"^\d{1,2}\/\d{1,2}\/\d{2,4}.*");
    var amountRegex = RegExp(r"^\d*\.\d*");
    List<dynamic> amountList = [];

    final textDetector = GoogleMlKit.vision.textDetectorV2();

    final RecognisedText recognisedText = await textDetector.processImage(InputImage.fromFilePath(widget.imagePath));

    // GET PLACE
    data["place"] = recognisedText.blocks[0].text;

    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          // GET DATE
          if (dateRegex.firstMatch(element.text) != null) {
            data["date"] = element.text;
          }
          if (amountRegex.firstMatch(element.text) != null) {
            amountList.add(element.text);
          }
        }
      }
    }
    // GET RECEIPT TOTAL
    double max = 0.0;
    for (var s in amountList) {
      if (isDouble(s)) {
        if (double.parse(s) > max) {
          max = double.parse(s);
        }
      }
    }
    data["total"] = max;

    amountList.clear();

    placeController = TextEditingController(text: data["place"].toString());
    dateController = TextEditingController(text: data["date"].toString());
    totalController = TextEditingController(text: data["total"].toString());

    return data;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: processImage(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        const Text("Does the information look correct?", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.only(top:25.0),
                          child: TextFormField(
                            maxLength: null,
                            controller: placeController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:25.0),
                          child: TextFormField(
                            maxLength: null,
                            controller: dateController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:25.0),
                          child: TextFormField(
                            maxLength: null,
                            controller: totalController,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else {
                  return Column(
                    children: const <Widget>[
                      Text("Please wait a moment while we process your image."),
                      CircularProgressIndicator()
                    ],
                  );
                }
              }
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () {
                data.update("place", (value) => placeController.text);
                data.update("date", (value) => dateController.text);
                data.update("total", (value) => totalController.text);
//  DEBUG
//                print("!!MAP!!");
//                for (String k in data.keys) {
//                  print(data[k]);
//                }

                widget.storage.write("users", FirebaseAuth.instance.currentUser!.uid, data);
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

bool isDouble(String s) {
 return double.tryParse(s) != null;
}