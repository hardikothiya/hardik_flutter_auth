import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hardik_flutter_auth/screens/profile_screen.dart';
import 'package:hardik_flutter_auth/widgets/custom_drawer.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
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
      drawer: CustomDrawer(),
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
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.id);
              },
              icon: Icon(Icons.account_circle))
        ],
      ),
      body: Text('Hi $username'),
    );
  }
}
