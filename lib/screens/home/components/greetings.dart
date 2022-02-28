import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../size_config.dart';

class Greetings extends StatefulWidget {
  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  String name = 'there';
  DatabaseReference ref = FirebaseDatabase.instance.ref('users');

  @override
  void initState() {
    super.initState();
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
