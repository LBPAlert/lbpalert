import 'package:flutter/material.dart';

import '../../../size_config.dart';

class DateSection extends StatelessWidget {
  DateSection({Key? key, required this.today}) : super(key: key);

  final DateTime today;
  final MONTHS = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC",
  ];
  final DAYS = [
    "NULL",
    "MONDAY",
    "TUESDAY",
    "WEDNESDAY",
    "THURSDAY",
    "FRIDAY",
    "SATURDAY",
    "SUNDAY",
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DAYS[today.weekday] +
              ', ' +
              MONTHS[today.month - 1] +
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
