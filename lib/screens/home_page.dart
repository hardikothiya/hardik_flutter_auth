import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Text('You are loggen in'),
      ),
    );
  }
}
