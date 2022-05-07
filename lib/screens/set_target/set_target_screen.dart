import 'package:flutter/material.dart';
import 'package:lbpalert/screens/set_target/components/body.dart';

class SetTargetScreen extends StatelessWidget {
  static String routeName = "/set_target";

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
          "Target",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
