import 'package:flutter/material.dart';
import 'package:lbpalert/screens/settings/components/body.dart';

class SettingsScreen extends StatelessWidget {
  static String routeName = "/settings";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
