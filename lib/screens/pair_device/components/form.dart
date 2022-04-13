import 'package:lbpalert/helper/keyboard.dart';
import 'package:flutter/material.dart';
import 'package:lbpalert/screens/settings/settings_screen.dart';
import '../../../services/auth.dart';
import '/components/custom_surfix_icon.dart';
import '/components/default_button.dart';
import '/components/form_error.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../pair_device_screen.dart';

class PairForm extends StatefulWidget {
  @override
  _PairFormState createState() => _PairFormState();
}

class _PairFormState extends State<PairForm> {
  String error = "";
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? id;
  bool toggle = true;

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  void togglePair() {
    setState(() {
      toggle = !toggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return toggle
        ? Form(
            key: _formKey,
            child: Column(
              children: [
                buildUIDFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                DefaultButton(
                  text: "Pair",
                  press: togglePair,
                ),
              ],
            ),
          )
        : SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/images/wearable.png'),
                      Text('Wearable Connected'),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      SizedBox(height: SizeConfig.screenHeight * 0.06),
                      DefaultButton(text: "Unpair", press: togglePair),
                      SizedBox(height: getProportionateScreenHeight(30)),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  TextFormField buildUIDFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => id = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        id = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "UID",
        hintText: "Enter Device ID",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}
