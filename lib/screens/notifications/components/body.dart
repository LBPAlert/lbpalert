import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lbpalert/models/notif_item.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'notif_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: NotifCard(
            notification: notifications[index],
          ),
        ),
      ),
    );
  }
}
