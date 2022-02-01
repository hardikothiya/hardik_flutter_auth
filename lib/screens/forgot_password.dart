import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hardik_flutter_auth/screens/login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'home_page.dart';

class ForgotPassword extends StatefulWidget {
  static const id = 'ForgotPassword';
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with InputValidationMixin {
  final formGlobalKey = GlobalKey<FormState>();
  String _email = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: formGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      if (isEmailValid(email!)) {
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
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (formGlobalKey.currentState!.validate()) {
                      try {
                        setState(() {
                          showSpinner = true;
                        });
                        await auth.sendPasswordResetEmail(email: _email);
                        Navigator.pushReplacementNamed(context, LoginScreen.id);
                        Fluttertoast.showToast(
                            msg: ' Link has been set to your mail ');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Fluttertoast.showToast(msg: 'No user found ');
                          print(e.code);
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Text("Login"),
                ),
              ],
            ),
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
