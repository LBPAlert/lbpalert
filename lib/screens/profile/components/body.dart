import 'package:firebase_database/firebase_database.dart';
import 'package:lbpalert/screens/notifications/notifications_screen.dart';
import 'package:lbpalert/screens/settings/settings_screen.dart';
import 'package:lbpalert/screens/splash/splash_screen.dart';
import 'package:lbpalert/screens/update_account/update_account_screen.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:lbpalert/services/database.dart';
import '../../../size_config.dart';
import 'package:flutter/material.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthService _auth = AuthService();
  String user_name = "John Doe";
  String user_email = "johndoe@yahooboys.com";

  @override
  void initState() {
    super.initState();
    getUserFullName();
  }

  String updateEmail() {
    user_email = _auth.getUserEmail!;
    return user_email;
  }

  void getUserFullName() {
    final uid = _auth.getUserID;
    final DatabaseService _users = DatabaseService(uid: uid);

    DatabaseReference child = _users.getChild;
    Stream<DatabaseEvent> dailyStream = child.onValue;

    // Subscribe to the stream!
    dailyStream.listen((DatabaseEvent event) {
      setState(() {
        user_name = _users.getFullName(event);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 10),
          Text(
            user_name,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(25),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            user_email = updateEmail(),
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
              Navigator.pushNamed(context, SplashScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
