import 'package:flutter/material.dart';
import 'package:lbpalert/screens/await_verification/components/body.dart';

class AwaitVerificationScreen extends StatelessWidget {
  static String routeName = "/await_verification";

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
          "Verify Email",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Body(),
    );
  }
}
