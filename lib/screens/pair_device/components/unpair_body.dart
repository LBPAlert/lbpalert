import 'package:flutter/material.dart';
import 'package:lbpalert/components/default_button.dart';
import 'package:lbpalert/helper/keyboard.dart';
import 'package:lbpalert/screens/home/home_screen.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:lbpalert/services/database.dart';
import '/size_config.dart';

class Unpair extends StatefulWidget {
  @override
  State<Unpair> createState() => _UnpairState();
}

class _UnpairState extends State<Unpair> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.getUserID;
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/wearable.png'),
                Text('Wearable Connected'),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                DefaultButton(
                    text: "Unpair",
                    press: () async {
                      await UserDatabaseService(uid).updateDeviceID("");
                      KeyboardUtil.hideKeyboard(context);
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    }),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
