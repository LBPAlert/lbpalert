import 'package:flutter/material.dart';
import '../../../size_config.dart';

class Greetings extends StatelessWidget {
  final String firstname;
  Greetings(this.firstname);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Hello, " + firstname + "!",
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
