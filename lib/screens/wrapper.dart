import 'package:flutter/material.dart';
import 'package:lbpalert/models/user.dart';
import 'package:lbpalert/screens/home/home_screen.dart';
import 'package:lbpalert/screens/sign_in/sign_in_screen.dart';
import 'package:lbpalert/size_config.dart';
import 'package:provider/provider.dart';

class WrapperScreen extends StatelessWidget {
  static String routeName = "/wrapper";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);

    final uid = Provider.of<FirebaseUser>(context).uid;

    if (uid == "") {
      return SignInScreen();
    } else {
      return HomeScreen();
    }
  }
}
