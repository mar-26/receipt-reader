import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:receipt_reader/storage.dart';
import 'package:receipt_reader/receipts.dart';
import 'package:receipt_reader/settings.dart';
import 'package:receipt_reader/home_page.dart';
import 'package:receipt_reader/login_page.dart';
import 'package:receipt_reader/add_receipt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receipt Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Receipt Reader'),
      routes: <String, WidgetBuilder> {
        "login" : (BuildContext context) => const LoginPage(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
      const HomePage(),
      AddReceipt(camera: cameras!.first, storage: Storage()),
      Receipts(storage: Storage()),
      const Settings(),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance
      .userChanges()
      .listen((User? user) {
        if (user == null) {
          Future(() {
            Navigator.of(context).pushNamed('login');
          });
        } else {
          print('User is signed in!');
        }
    });
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add Reciept',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Receipts',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTap
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
