import 'package:flutter/material.dart';
import 'package:lbpalert/screens/pair_device/components/unpair_body.dart';
import '/components/coustom_bottom_nav_bar.dart';
import 'components/pair_body.dart';
import '/enums.dart';

class PairDeviceScreen extends StatefulWidget {
  static String routeName = "/pair_device";

  @override
  State<PairDeviceScreen> createState() => _PairDeviceScreenState();
}

class _PairDeviceScreenState extends State<PairDeviceScreen> {
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
      body: Pair(),
    );
  }
}
