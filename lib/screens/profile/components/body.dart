import 'package:lbpalert/screens/notifications/notifications_screen.dart';
import 'package:lbpalert/screens/settings/settings_screen.dart';
import 'package:lbpalert/screens/sign_in/sign_in_screen.dart';
import 'package:lbpalert/services/auth.dart';
import '../../../size_config.dart';
import 'package:flutter/material.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  final AuthService _auth = AuthService();
  final String firstname;
  final String lastname;
  final String email;
  final String profilePic;
  Body(this.firstname, this.lastname, this.email, this.profilePic);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfilePic(profilePic),
          SizedBox(height: 10),
          Text(
            firstname + " " + lastname,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(25),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            email,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(15),
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 40),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {
              Navigator.pushNamed(context, NotificationScreen.routeName);
            },
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async {
              await _auth.signOut();
              Navigator.pushNamed(context, SignInScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
