import 'package:flutter/material.dart';
import 'package:lbpalert/components/default_button.dart';
import '/constants.dart';
import '/size_config.dart';

import 'form.dart';

class Unpair extends StatelessWidget {
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
                DefaultButton(text: "Unpair", press: () {}),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
