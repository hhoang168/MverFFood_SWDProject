import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swd301/screens/detail_order_screen.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _logged = false;

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  Future<bool> checkLogin() async {
    if (await GoogleSignIn().isSignedIn()) {
      setState(() {
        _logged = true;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      color: Colors.blueGrey,
      title: 'FFood',
      home: _logged ? HomePage() : LoginScreen(),
      onGenerateRoute: (RouteSettings routeSettings) {
        return new PageRouteBuilder<dynamic>(
            settings: routeSettings,
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              switch (routeSettings.name) {
                case HomePage.tag:
                  return HomePage();
                case LoginScreen.tag:
                  return LoginScreen();
                case DetailOrderScreen.tag:
                  return DetailOrderScreen();
                case 'notification':
                  return HomePage(tabIndex: 2);
                default:
                  return Container();
              }
            },
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return effectMap[PageTransitionType.slideParallaxLeft](
                  Curves.easeInOut, animation, secondaryAnimation, child);
            });
      },
    );
  }
}
