import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = FlutterSecureStorage();
  String username = '';

  @override
  void initState() {
    UserName();
    // TODO: implement initState
    super.initState();
  }

  Future<void> UserName() async {
    String? userEmail = await storage.read(key: 'email');

    if (userEmail != null) {
      setState(() {
        username = userEmail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                print(storage.read(key: 'userID'));
                storage.delete(key: 'userID');
                Navigator.pushNamed(context, LoginScreen.id);
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () async {
                print(await storage.read(key: 'email'));
              },
              icon: const Icon(Icons.ac_unit))
        ],
      ),
      body: Text('Hi $username'),
    );
  }
}
