import 'package:flutter/material.dart';
import 'package:lbpalert/screens/trend/components/body.dart';
import 'package:lbpalert/screens/trend/components/chart.dart';
import '/components/coustom_bottom_nav_bar.dart';
import '/enums.dart';

class TrendScreen extends StatelessWidget {
  static String routeName = "/trends";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        // title: Text(
        //   "Summary",
        //   style: TextStyle(color: Colors.white),
        // ),
      ),
      //body: TrendsChart.withSampleData(),
      body: Body(),
      //bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.trend),
    );
  }
}
