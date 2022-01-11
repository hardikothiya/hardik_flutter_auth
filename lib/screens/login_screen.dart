import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hardik_flutter_auth/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password.dart';
import 'home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'LoginPage';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with InputValidationMixin {
  final formGlobalKey = GlobalKey<FormState>();

  final storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  final textEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  late String _password;
  late String _email;

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
                'Welcome Back!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: TextFormField(
                  controller: textEditingController,
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
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: TextFormField(
                  controller: passwordEditingController,
                  onChanged: (value) {
                    _password = value.trim();
                  },
                  maxLength: 6,
                  validator: (password) {
                    if (isPasswordValid(password!)) {
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (formGlobalKey.currentState!.validate()) {
                    try {
                      UserCredential credentials =
                          await auth.signInWithEmailAndPassword(
                              email: _email, password: _password);
                      await storage.write(
                          key: 'userID',
                          value: credentials.user?.uid.toString());

                      await storage.write(
                          key: 'email',
                          value: credentials.user?.email.toString());
                      print(credentials.user?.email);

                      Navigator.pushNamed(context, HomeScreen.id);
                      textEditingController.clear();

                      passwordEditingController.clear();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        Fluttertoast.showToast(msg: 'No user found ');
                      } else if (e.code == 'wrong-password') {
                        Fluttertoast.showToast(msg: 'Wrong password ');
                      }
                    } catch (e) {
                      print(e);
                    }
                    // print("user name ${_email} and password $_password");
                  }
                },
                child: Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, ForgotPassword.id);
                },
                child: const Text(
                  'Forgot Password ?',
                  style: TextStyle(
                      color: Colors.blue, letterSpacing: 0.8, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: GestureDetector(
          child: Container(
            child: const Center(
              child: Text(
                'New user ? Sign UP!',
                style: TextStyle(
                    letterSpacing: 1.2,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
            alignment: Alignment.bottomCenter,
            height: 60,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.pushNamed(context, SignUpScreen.id);
          }),
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
