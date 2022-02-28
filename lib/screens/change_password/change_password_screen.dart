import 'package:flutter/material.dart';
import '/components/coustom_bottom_nav_bar.dart';
import 'components/body.dart';
import '/enums.dart';

class ChangePasswordScreen extends StatelessWidget {
  static String routeName = "/change_password";
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
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
