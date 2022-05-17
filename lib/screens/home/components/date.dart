import 'package:flutter/material.dart';
import 'package:lbpalert/constants.dart';
import '../../../size_config.dart';

class DateSection extends StatelessWidget {
  DateSection({Key? key, required this.today}) : super(key: key);

  final DateTime today;
  final months = MONTHS;
  final days = DAYS;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          days[today.weekday] +
              ', ' +
              months[today.month - 1] +
              ' ' +
              today.day.toString(),
          style: TextStyle(
            fontSize: getProportionateScreenWidth(14),
            color: Color.fromARGB(255, 124, 122, 122),
          ),
        ),
      ],
    );
  }
}
