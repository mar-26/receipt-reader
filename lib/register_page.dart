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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _passKey,
        child: Center(
          child: Column(
            children: <Widget>[
              const Text("Sign Up", style: TextStyle(fontSize: 20)),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true, 
                decoration: const InputDecoration(hintText: "Password"),
                validator: (value) {
                  if (value == confirmPasswordController.text && value != null) {
                    return null;
                  }
                  else {
                    return "Passwords don't match or has no text";
                  }
                },
              ),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(hintText: "Confirm Password"),
                obscureText: true
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