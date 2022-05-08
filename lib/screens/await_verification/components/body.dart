import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lbpalert/screens/sign_in/sign_in_screen.dart';
import 'package:lbpalert/services/auth.dart';
import '/components/default_button.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthService _auth = AuthService();
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = _auth.getCurrentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future sendVerificationEmail() async {
    try {
      await _auth.getCurrentUser!.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future checkEmailVerified() async {
    await _auth.getCurrentUser!.reload();

    setState(() {
      isEmailVerified = _auth.getCurrentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      _auth.signOut();
      Navigator.pushNamed(context, SignInScreen.routeName);
    }
  }

  @override
  void dispose() {
    timer?.cancel;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: const Text(
            'A verification email has been sent to the email address you provided. If not received after some time, click on the resend email button',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(50)),
        SizedBox(
            width: 200,
            child: DefaultButton(
                text: 'Resend Email',
                press: () {
                  canResendEmail ? sendVerificationEmail() : null;
                })),
      ],
    );
  }
}
