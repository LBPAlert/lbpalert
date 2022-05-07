import 'package:flutter/material.dart';
import 'package:lbpalert/models/user.dart';
import 'package:lbpalert/screens/profile/profile_screen.dart';
import 'package:lbpalert/screens/trend/trend_screen.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:lbpalert/services/database.dart';
import 'package:provider/provider.dart';
import '/constants.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color inActiveIconColor = Color(0xFFB6B6B6);

  List pages = [Body(), TrendScreen(), ProfileScreen()];
  int currentIndex = 0;
  List titleText = ["Home", "Trends", "Profile"];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final uid = _auth.getUserID;

    return StreamProvider<FirebaseUserData>.value(
      value: UserDatabaseService(uid).userData,
      initialData: FirebaseUserData(
        '',
        '',
        '',
        '',
        '',
        0,
        '',
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          title: Text(
            titleText[currentIndex],
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: pages[currentIndex],
        //bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 63, 62, 62),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Color.fromARGB(255, 63, 62, 62),
            onTap: onTap,
            currentIndex: currentIndex,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: inActiveIconColor,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up), label: "Trend"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}
