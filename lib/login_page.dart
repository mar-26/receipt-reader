import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receipt_reader/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Form(
        key: _passKey,
        child: Center(
          child: Column(
            children: <Widget>[
              const Text("Login", style: TextStyle(fontSize: 30)),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(hintText: "Email"),
                validator: (value) {
                  if (value != null) {
                    return null;
                  }
                  else {
                    return "Email has no text";
                  }
                },
              ),
              TextFormField(
               controller: passwordController,
               obscureText: true, 
               decoration: const InputDecoration(hintText: "Password"),
               validator: (value) {
                 if (value != null) {
                   return null;
                 }
                 else {
                   return "Password has no text";
                 }
               },
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: <Widget>[
                 ElevatedButton(
                   child: const Text("Login"),
                   onPressed: () async {
                     if (_passKey.currentState!.validate()) {
                       try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text
                          );
                          Navigator.pop(context);
                        }
                        on FirebaseAuthException catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User not found. Please try again or sign up")),
                          );
                        }
                     }
                   },
                 ),
                 ElevatedButton(
                   child: const Text("Sign up"),
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => const RegisterPage())
                     );
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