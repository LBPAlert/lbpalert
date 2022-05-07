import 'package:flutter/material.dart';
import 'package:lbpalert/screens/change_password/change_password_screen.dart';
import 'package:lbpalert/screens/pair_device/pair_device_screen.dart';
import '../../../size_config.dart';
import 'settings_menu.dart';
import 'package:lbpalert/screens/set_target/set_target_screen.dart';
import 'package:lbpalert/screens/update_account/update_account_screen.dart';

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
          SettingsMenu(
            text: "Edit Profile",
            icon: "assets/icons/User Icon.svg",
            press: () {
              Navigator.pushNamed(context, UpdateAccountScreen.routeName);
            },
          ),
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
            press: () {
              Navigator.pushNamed(context, PairDeviceScreen.routeName);
            },
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
