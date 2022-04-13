import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lbpalert/services/database.dart';
import '../../../size_config.dart';
import 'package:lbpalert/services/auth.dart';

class Greetings extends StatefulWidget {
  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  String? name;
  bool showName = false;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    getUserFirstName();
  }

  void getUserFirstName() async {
    final uid = _auth.getUserID;
    final DatabaseService _users = DatabaseService(uid: uid);

    DatabaseReference child = _users.getChild;
    final userData = await child.get();
    if (userData.exists) {
      setState(() {
        name = (userData.value as dynamic)["firstname"];
      });
      showName = true;
    } else {
      showName = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          showName ? "Hello, " + name! + "!" : "Hello there!",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
