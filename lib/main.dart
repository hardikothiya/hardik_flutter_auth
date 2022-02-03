import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hardik_flutter_auth/screens/forgot_password.dart';
import 'package:hardik_flutter_auth/screens/home_page.dart';
import 'package:hardik_flutter_auth/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hardik_flutter_auth/screens/profile_screen.dart';
import 'package:hardik_flutter_auth/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = FlutterSecureStorage();

  Widget currentPage = LoginScreen();

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  Future<void> checkLogin() async {
    String? uid = await storage.read(key: 'userID');
    if (uid != null) {
      setState(() {
        currentPage = HomeScreen();
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: currentPage,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        ForgotPassword.id: (context) => ForgotPassword(),
        HomeScreen.id: (context) => HomeScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
      },
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
