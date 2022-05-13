import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _passKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  static const Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt Reader"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xffdfdfdc),
      body: Form(
        key: _passKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Register", style: TextStyle(color: textColor, fontSize: 30),),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor)),
                  border: OutlineInputBorder(),
                  hintText: "Email",
                  hintStyle: TextStyle(color: textColor),
                ),
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextFormField(
                controller: passwordController,
                obscureText: true, 
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor)),
                  border: OutlineInputBorder(),
                  hintText: "Password",
                  hintStyle: TextStyle(color: textColor),
                ),
                validator: (value) {
                  if (value == confirmPasswordController.text && value != null) {
                    return null;
                  }
                  else {
                    return "Passwords don't match or has no text";
                  }
                },
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor)),
                  border: OutlineInputBorder(),
                  hintText: "Confirm Password",
                  hintStyle: TextStyle(color: textColor),
                ),
                obscureText: true
              ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text("Sign up"),
                    onPressed: () async {
                      if (_passKey.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          Navigator.pop(context);
                        }
                        on FirebaseAuthException catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Something went wrong")),
                          );
                        }
                      }
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
            ],
          ),
        ),
      ),
    );
  }
}