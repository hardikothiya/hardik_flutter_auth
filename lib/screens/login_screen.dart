import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hardik_flutter_auth/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password.dart';
import 'home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'LoginPage';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with InputValidationMixin {
  final formGlobalKey = GlobalKey<FormState>();
  bool showSpinner = false;

  final storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final textEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  late String _password;
  late String _email;

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SizedBox(
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
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
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
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
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
                          setState(() {
                            showSpinner = true;
                          });
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

                          Navigator.pushReplacementNamed(
                              context, HomeScreen.id);
                          textEditingController.clear();

                          passwordEditingController.clear();
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
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
                  ),
                  Container(
                    height: 54,
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueAccent,
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          // Image.network(
                          //   "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/crypto%2Fsearch%20(2).png?alt=media&token=24a918f7-3564-4290-b7e4-08ff54b3c94c",
                          //   width: 20,
                          // ),
                          SizedBox(
                            width: 10,
                          ),

                          Text(
                            "Google",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        try {
                          setState(() {
                            showSpinner = true;
                          });
                          GoogleSignInAccount? usercredentials =
                              await googleSignIn.signIn();

                          await storage.write(
                              key: 'userID', value: usercredentials?.id);
                          await storage.write(
                              key: 'email', value: usercredentials?.email);

                          print(usercredentials);
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.id);
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          if (e.code ==
                              'account-exists-with-different-credential') {
                            Fluttertoast.showToast(msg: 'User exist');
                          } else if (e.code == 'invalid-credential') {
                            Fluttertoast.showToast(msg: 'Invalid credentials');
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
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
