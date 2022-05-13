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
  static const Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold (
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
              const Text("Login", style: TextStyle(color: textColor, fontSize: 30)),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 4),
                child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor)),
                  border: OutlineInputBorder(),
                  hintText: "Email",
                  hintStyle: TextStyle(color: textColor)
                ),
                validator: (value) {
                  if (value != null) {
                    return null;
                  }
                  else {
                    return "Email has no text";
                  }
                },
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor)),
                  border: OutlineInputBorder(),
                  hintText: "Password",
                  hintStyle: TextStyle(color: textColor)
                ),
                validator: (value) {
                  if (value != null) {
                    return null;
                  }
                  else {
                    return "Password has no text";
                  }
                },
              ),
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

                            Navigator.restorablePushReplacementNamed(context, "home");
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
          )
       ),
      ),
    );
  }
}