import 'package:flutter/widgets.dart';
import 'package:lbpalert/screens/await_verification/await_verification_screen.dart';
import 'package:lbpalert/screens/change_password/change_password_screen.dart';
import 'package:lbpalert/screens/notifications/notifications_screen.dart';
import 'package:lbpalert/screens/pair_device/pair_device_screen.dart';
import 'package:lbpalert/screens/set_target/set_target_screen.dart';
import 'package:lbpalert/screens/settings/settings_screen.dart';
import 'package:lbpalert/screens/update_account/update_account_screen.dart';
import 'package:lbpalert/screens/wrapper.dart';
import 'screens/trend/trend_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  WrapperScreen.routeName: (context) => WrapperScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  AwaitVerificationScreen.routeName: (context) => AwaitVerificationScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  TrendScreen.routeName: (context) => TrendScreen(),
  SettingsScreen.routeName: (context) => SettingsScreen(),
  UpdateAccountScreen.routeName: (context) => UpdateAccountScreen(),
  PairDeviceScreen.routeName: (context) => PairDeviceScreen(),
  SetTargetScreen.routeName: (context) => SetTargetScreen(),
  ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
  NotificationScreen.routeName: (context) => NotificationScreen(),
};
