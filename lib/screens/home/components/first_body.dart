import 'package:flutter/material.dart';
import 'package:lbpalert/screens/home/components/date.dart';
import 'package:lbpalert/screens/home/components/greetings.dart';
import 'package:lbpalert/screens/home/components/section_title.dart';
import 'package:lbpalert/screens/pair_device/pair_device_screen.dart';
import '/components/default_button.dart';

import '../../../size_config.dart';
import 'read_sensor_data.dart';
import 'averages.dart';

class FirstBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenWidth(10)),
            Image.asset(
              "assets/images/inactiveness.gif",
              height: getProportionateScreenWidth(300),
            ),
            Text.rich(
              TextSpan(
                text: "No activity found",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(25),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(50)),
            Text.rich(
              TextSpan(
                text:
                    "It seems you have not connected a device yet. Go to pair your device now",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(50)),
            DefaultButton(
              text: "Go to Pair Device",
              press: () {
                Navigator.pushNamed(context, PairDeviceScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
