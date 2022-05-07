import 'package:flutter/material.dart';
import 'package:lbpalert/models/user.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    final newUserData = Provider.of<FirebaseUserData>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Body(newUserData.firstname, newUserData.lastname, newUserData.email,
          newUserData.profilePic),
    );
  }
}
