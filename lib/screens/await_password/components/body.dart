import 'package:flutter/material.dart';
import 'package:lbpalert/services/auth.dart';
import '/components/default_button.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: const Text(
            'An email has been sent to your email address, click on the link to change your password. If not received after some time, click on the resend email button',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(50)),
        SizedBox(
            width: 200,
            child: DefaultButton(text: 'Resend Email', press: () {})),
      ],
    );
  }
}
