import 'package:flutter/material.dart';
import 'package:lbpalert/components/default_button.dart';
import 'package:lbpalert/models/user.dart';
import 'package:lbpalert/screens/home/components/date.dart';
import 'package:lbpalert/screens/home/components/greetings.dart';
import 'package:lbpalert/screens/home/components/section_title.dart';
import 'package:lbpalert/screens/pair_device/pair_device_screen.dart';
import 'package:provider/provider.dart';
import '../../../size_config.dart';
import 'read_sensor_data.dart';

class Body extends StatelessWidget {
  bool deviceInDB = false;

  @override
  Widget build(BuildContext context) {
    final newUserData = Provider.of<FirebaseUserData>(context);
    if (newUserData.deviceID != "") {
      deviceInDB = true;
    }

    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
          children: deviceInDB
              ? [
                  SizedBox(height: getProportionateScreenWidth(10)),
                  DateSection(today: DateTime.now()),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  Greetings(newUserData.firstname),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  SectionTitle(title: 'Activity'),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  ReadSensorData(newUserData.painTarget, newUserData.deviceID),
                ]
              : [
                  SizedBox(height: getProportionateScreenWidth(10)),
                  Image.asset(
                    "assets/images/inactiveness.gif",
                    height: getProportionateScreenWidth(300),
                  ),
                  Text.rich(
                    TextSpan(
                      text: "No wearable found",
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
                ]),
    ));
  }
}
