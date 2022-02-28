import 'package:flutter/material.dart';
import 'package:lbpalert/screens/change_password/change_password_screen.dart';
import '../../../size_config.dart';
import '../../profile/components/profile_pic.dart';
import 'settings_menu.dart';
import 'package:lbpalert/screens/set_target/set_target_screen.dart';
//import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
          top: getProportionateScreenWidth(10),
          bottom: getProportionateScreenWidth(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //ProfilePic(),
          //SizedBox(height: 20),
          SettingsMenu(
            text: "Change Password",
            icon: "assets/icons/change-password.svg",
            press: () {
              Navigator.pushNamed(context, ChangePasswordScreen.routeName);
            },
          ),
          SettingsMenu(
            text: "View Paired Device",
            icon: "assets/icons/device.svg",
            press: () {},
          ),
          SettingsMenu(
            text: "Set Target",
            icon: "assets/icons/target.svg",
            press: () {
              Navigator.pushNamed(context, SetTargetScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
