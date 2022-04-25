import 'package:flutter/material.dart';
import 'package:lbpalert/screens/home/components/date.dart';
import 'package:lbpalert/screens/home/components/greetings.dart';
import 'package:lbpalert/screens/home/components/section_title.dart';
import '../../../size_config.dart';
import 'read_sensor_data.dart';
import 'averages.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenWidth(10)),
            DateSection(today: DateTime.now()),
            SizedBox(height: getProportionateScreenWidth(10)),
            Greetings(),
            SizedBox(height: getProportionateScreenWidth(20)),
            SectionTitle(title: 'Activity'),
            SizedBox(height: getProportionateScreenWidth(10)),
            ReadSensorData(),
            // SizedBox(height: getProportionateScreenWidth(30)),
            // SectionTitle(title: 'Summary'),
            // SizedBox(height: getProportionateScreenWidth(10)),
            // Averages(),
          ],
        ),
      ),
    );
  }
}
