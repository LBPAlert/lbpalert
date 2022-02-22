import 'package:flutter/material.dart';
import 'package:lbpalert/screens/trend/components/body.dart';
import '/components/coustom_bottom_nav_bar.dart';
import '/enums.dart';

//import 'components/body.dart';

class TrendScreen extends StatelessWidget {
  static String routeName = "/trends";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trends"),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.trend),
    );
  }
}
