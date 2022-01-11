import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_page.dart';

class SignUpScreen extends StatefulWidget {
  static const id = 'SignUpScreen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with InputValidationMixin {
  final formGlobalKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = FlutterSecureStorage();

  String _password = '';
  String _email = '';
  String _confirmPassword = '';

  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formGlobalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Hello',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    _email = value;
                  },
                  validator: (_email) {
                    if (isEmailValid(_email!)) {
                      return null;
                    } else {
                      return 'Enter a valid email address';
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    prefixIcon: const Icon(
                      Icons.account_box,
                      size: 30,
                    ),
                    border: OutlineInputBorder(
                      // borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: TextFormField(
                  onChanged: (value) {
                    _password = value;
                  },
                  maxLength: 6,
                  validator: (_password) {
                    if (isPasswordValid(_password!)) {
                      return null;
                    } else {
                      return 'Enter a valid password';
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 30,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                      // borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: !_passwordVisible,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: TextFormField(
                  onChanged: (value) {
                    _confirmPassword = value;
                  },
                  maxLength: 6,
                  validator: (_confirmPassword) {
                    if (_password != _confirmPassword) {
                      return "Password does not match";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 30,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                      // borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: !_passwordVisible,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (formGlobalKey.currentState!.validate()) {
                    try {
                      UserCredential credential =
                          await _auth.createUserWithEmailAndPassword(
                              email: _email, password: _confirmPassword);
                      // print(credential.user?.uid);

                      await storage.write(
                          key: 'userID', value: credential.user?.uid);
                      await storage.write(
                          key: 'email',
                          value: credential.user?.email.toString());

                      Navigator.pushNamed(context, HomeScreen.id);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        Fluttertoast.showToast(
                            msg: 'The account already exists ');
                      }
                    } catch (e) {
                      print(e);
                    }
                    print("user name $_email and password $_password");
                  }
                },
                child: const Text("Sign UP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isPasswordValid(String password) => password.length == 6;

  bool isEmailValid(String email) {
    Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }
}
