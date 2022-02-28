import 'package:flutter/widgets.dart';
import 'package:lbpalert/screens/change_password/change_password_screen.dart';
import 'package:lbpalert/screens/notifications/notifications_screen.dart';
import 'package:lbpalert/screens/set_target/set_target_screen.dart';
import 'package:lbpalert/screens/settings/settings_screen.dart';
import 'package:lbpalert/screens/update_account/update_account_screen.dart';
import 'screens/trend/trend_screen.dart';
import 'screens/complete_profile/complete_profile_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/otp/otp_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/splash/splash_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  TrendScreen.routeName: (context) => TrendScreen(),
  SettingsScreen.routeName: (context) => SettingsScreen(),
  UpdateAccountScreen.routeName: (context) => UpdateAccountScreen(),
  SetTargetScreen.routeName: (context) => SetTargetScreen(),
  ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
  NotificationScreen.routeName: (context) => NotificationScreen(),
};
