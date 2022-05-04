import 'package:flutter/material.dart';
import 'components/body.dart';
import '/enums.dart';

class ChangeForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/change_forgot_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Body(),
    );
  }
}
