import 'package:firebase_database/firebase_database.dart';
import 'package:lbpalert/screens/notifications/notifications_screen.dart';
import 'package:lbpalert/screens/settings/settings_screen.dart';
import 'package:lbpalert/screens/splash/splash_screen.dart';
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
  String? firstName;
  String? lastName;
  String? userEmail;
  bool showFullName = false;
  bool showEmail = false;

  @override
  void initState() {
    super.initState();
    getUserFullName();
    updateEmail();
  }

  void updateEmail() {
    setState(() {
      userEmail = _auth.getUserEmail!;
    });
    showEmail = true;
  }

  void getUserFullName() async {
    final uid = _auth.getUserID;
    final DatabaseService _users = DatabaseService(uid: uid);

    DatabaseReference child = _users.getChild;
    final userData = await child.get();
    if (userData.exists) {
      setState(() {
        firstName = (userData.value as dynamic)["firstname"];
        lastName = (userData.value as dynamic)["lastname"];
      });
      showFullName = true;
    } else {
      showFullName = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 10),
          Text(
            showFullName ? firstName! + " " + lastName! : "John Doe",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(25),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            showEmail ? userEmail! : "johndoe@yahooboys.com",
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
