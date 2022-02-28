import 'package:flutter/material.dart';
import 'package:lbpalert/screens/settings/components/body.dart';
import '/components/coustom_bottom_nav_bar.dart';
import '/enums.dart';
import '/components/default_button.dart';
import 'package:lbpalert/screens/settings/settings_screen.dart';
import '../../../size_config.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _counter = 8;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter = _counter - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
            'Set your target to determine what value to be notified about injury risk. This can be changed anytime.'),
        SizedBox(height: getProportionateScreenHeight(200)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              backgroundColor: kPrimaryColor,
              splashColor: kSecondaryColor,
              onPressed: _decrementCounter,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            SizedBox(width: 50),
            Text(
              '$_counter',
              style: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(28),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 50),
            FloatingActionButton(
              backgroundColor: kPrimaryColor,
              splashColor: kSecondaryColor,
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ],
        ),
        SizedBox(height: getProportionateScreenHeight(200)),
        SizedBox(
          width: 100,
          child: DefaultButton(
            text: "Save",
            press: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
          ),
        ),
      ],
    );
  }
}
