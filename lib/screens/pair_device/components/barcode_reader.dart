import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lbpalert/components/default_button.dart';
import 'package:lbpalert/helper/keyboard.dart';
import 'package:lbpalert/screens/home/home_screen.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:lbpalert/services/database.dart';
import 'package:lbpalert/size_config.dart';

class PairBarcode extends StatefulWidget {
  @override
  State<PairBarcode> createState() => _PairBarcodeState();
}

class _PairBarcodeState extends State<PairBarcode> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  void readBarcode() async {
    String barcodeScanRes;
    final uid = _auth.getUserID;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '$Colors.black', "Cancel", true, ScanMode.QR);
      await UserDatabaseService(uid).updateDeviceID(barcodeScanRes);
      KeyboardUtil.hideKeyboard(context);
      Navigator.pushNamed(context, HomeScreen.routeName);
    } on PlatformException {
      barcodeScanRes = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                DefaultButton(
                    text: 'Scan QR code to pair wearable',
                    press: () async {
                      readBarcode();
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
