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
  String name = 'there!';

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    getUserFirstName();
  }

  void getUserFirstName() {
    final uid = _auth.getUserID;
    final DatabaseService _users = DatabaseService(uid: uid);

    DatabaseReference child = _users.getChild;
    Stream<DatabaseEvent> dailyStream = child.onValue;

    // Subscribe to the stream!
    dailyStream.listen((DatabaseEvent event) {
      setState(() {
        name = _users.getFirstName(event);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Hello " + name,
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
