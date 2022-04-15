import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lbpalert/screens/home/home_screen.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:lbpalert/services/database.dart';
import '/components/default_button.dart';
import '../../../size_config.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthService _auth = AuthService();
  int? painTarget;
  bool greyOutMax = false;
  bool greyOutMin = false;

  @override
  void initState() {
    super.initState();
    getUserTarget();
  }

  // greys out the add and subtract buttons when the limits have been reached
  void activateListeners() {
    if (painTarget == maxPainRating) {
      greyOutMax = true;
    } else {
      greyOutMax = false;
    }
    if (painTarget == minPainRating) {
      greyOutMin = true;
    } else {
      greyOutMin = false;
    }
  }

  void getUserTarget() async {
    final uid = _auth.getUserID;
    final UserDatabaseService _users = UserDatabaseService(uid: uid);

    DatabaseReference child = _users.getUser;
    final userData = await child.get();
    if (userData.exists) {
      setState(() {
        painTarget = (userData.value as dynamic)["pain_target"];
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      if (painTarget == maxPainRating) {
        painTarget = maxPainRating;
      } else {
        painTarget = (painTarget! + 1);
      }
      activateListeners();
    });
  }

  void _decrementCounter() {
    setState(() {
      if (painTarget == minPainRating) {
        painTarget = minPainRating;
      } else {
        painTarget = (painTarget! - 1);
      }
      activateListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: getProportionateScreenHeight(50)),
        const Text(
          'Set your target to determine when to be notified about injury risk. This can be changed anytime.',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: getProportionateScreenHeight(150)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              backgroundColor: greyOutMin ? Colors.grey : kPrimaryColor,
              splashColor: kSecondaryColor,
              onPressed: _decrementCounter,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            SizedBox(width: 50),
            Text(
              '$painTarget',
              style: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(28),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 50),
            FloatingActionButton(
              backgroundColor: greyOutMax ? Colors.grey : kPrimaryColor,
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
            press: () async {
              final user_id = _auth.getUserID;
              await UserDatabaseService(uid: user_id)
                  .updatePainTarget(painTarget!);
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
        ),
      ],
    );
  }
}
