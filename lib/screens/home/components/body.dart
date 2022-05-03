import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lbpalert/components/default_button.dart';
import 'package:lbpalert/screens/home/components/date.dart';
import 'package:lbpalert/screens/home/components/greetings.dart';
import 'package:lbpalert/screens/home/components/section_title.dart';
import 'package:lbpalert/screens/pair_device/pair_device_screen.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:lbpalert/services/database.dart';
import '../../../size_config.dart';
import 'read_sensor_data.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthService _auth = AuthService();
  bool deviceInDB = false;
  bool hasPastPredictions = false;
  String? deviceID;

  @override
  void initState() {
    super.initState();
    checkDeviceInDb();
  }

  void checkDeviceInDb() async {
    final uid = _auth.getUserID;
    final UserDatabaseService _users = UserDatabaseService(uid: uid);
    final DatabaseReference _aveRef =
        FirebaseDatabase.instance.ref("users/$uid/daily_averages");
    final _aveRefSnap = await _aveRef.get();
    DatabaseReference child = _users.getUser;
    final userData = await child.get();

    if (_aveRefSnap.children.isNotEmpty) {
      hasPastPredictions = true;
    }

    if (userData.exists) {
      setState(() {
        deviceID = (userData.value as dynamic)["device_id"];
      });
      if (deviceID != "") {
        deviceInDB = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: hasPastPredictions || deviceInDB
              ? [
                  SizedBox(height: getProportionateScreenWidth(10)),
                  DateSection(today: DateTime.now()),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  Greetings(),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  SectionTitle(title: 'Activity'),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  ReadSensorData(),
                ]
              : [
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
