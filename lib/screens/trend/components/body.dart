import 'package:flutter/material.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
          top: getProportionateScreenWidth(100),
          bottom: getProportionateScreenWidth(5)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            height: getProportionateScreenWidth(350),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFECDF),
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }
}
