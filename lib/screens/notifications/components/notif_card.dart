import 'package:flutter/material.dart';
import 'package:lbpalert/models/notif_item.dart';
import 'package:lbpalert/models/notifications.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class NotifCard extends StatelessWidget {
  const NotifCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final Notif notification;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: CircleAvatar(
                radius: getProportionateScreenWidth(85),
                backgroundColor: notification.item.color,
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.item.title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: notification.item.description,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
              ),
            )
          ],
        )
      ],
    );
  }
}
