import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lbpalert/models/user.dart';
import 'package:lbpalert/services/database.dart';
import '../../../size_config.dart';
import 'package:lbpalert/services/auth.dart';

class Greetings extends StatefulWidget {
  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  String name = 'there!';

  DatabaseReference ref = FirebaseDatabase.instance.ref('users');
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  void getUserName() {
    final uid = _auth.getUserID;

    DatabaseReference child = ref.child(uid);
    Stream<DatabaseEvent> dailyStream = child.onValue;

    // Subscribe to the stream!
    dailyStream.listen((DatabaseEvent event) {
      setState(() {
        name = '${(event.snapshot.value as dynamic)['firstname']}!';
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
