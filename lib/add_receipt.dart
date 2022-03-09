import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:receipt_reader/storage.dart';

class AddReceipt extends StatefulWidget {
  const AddReceipt({Key? key, required this.camera, required this.storage}) : super(key: key);

  final CameraDescription camera;
  final FormStorage storage;

  @override
  _AddReceiptState createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(child: CameraPreview(_controller));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPic(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DisplayPic extends StatelessWidget {
  final String imagePath;
  const DisplayPic({Key? key, required this.imagePath}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Display Pic")),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}