import 'package:flutter/material.dart';
import '/components/coustom_bottom_nav_bar.dart';
import 'components/body.dart';
import '/enums.dart';

class NotificationScreen extends StatelessWidget {
  static String routeName = "/notifications";
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
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
