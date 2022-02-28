import 'package:flutter/material.dart';
import '/components/coustom_bottom_nav_bar.dart';
import 'components/body.dart';
import '/enums.dart';

class NotificationScreen extends StatelessWidget {
  static String routeName = "/notifications";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
