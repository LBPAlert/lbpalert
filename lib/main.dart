import 'package:lbpalert/screens/sign_in/sign_in_screen.dart';
import 'package:lbpalert/screens/splash/splash_screen.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'routes.dart';
import 'theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lbpalert/constants.dart';
import 'firebase_options.dart';
import '../../../size_config.dart';
//import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      initialData: FirebaseUser(uid: ''),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme(),
        // We use routeName so that we dont need to remember the name
        initialRoute: SignInScreen.routeName,
        routes: routes,
      ),
    );
  }
}
