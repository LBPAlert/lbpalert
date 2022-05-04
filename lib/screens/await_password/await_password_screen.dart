import 'package:flutter/material.dart';
import 'package:lbpalert/screens/await_password/components/body.dart';

class AwaitPasswordScreen extends StatelessWidget {
  static String routeName = "/await_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "Verify Password Change",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Body(),
    );
  }
}
