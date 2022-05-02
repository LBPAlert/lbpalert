import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lbpalert/screens/pair_device/components/barcode_reader.dart';
import 'package:lbpalert/screens/pair_device/components/unpair_body.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:lbpalert/services/database.dart';

class PairDeviceScreen extends StatefulWidget {
  static String routeName = "/pair_device";

  @override
  State<PairDeviceScreen> createState() => _PairDeviceScreenState();
}

class _PairDeviceScreenState extends State<PairDeviceScreen> {
  final AuthService _auth = AuthService();
  bool _deviceInDB = false;
  String? deviceID;

  @override
  void initState() {
    super.initState();
    checkDeviceInDb();
  }

  void checkDeviceInDb() async {
    final uid = _auth.getUserID;
    final UserDatabaseService _users = UserDatabaseService(uid: uid);

    DatabaseReference child = _users.getUser;
    final userData = await child.get();
    if (userData.exists) {
      setState(() {
        deviceID = (userData.value as dynamic)["device_id"];
      });
      if (deviceID != "") {
        _deviceInDB = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "Device Pairing",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _deviceInDB ? Unpair() : PairBarcode(),
    );
  }
}
