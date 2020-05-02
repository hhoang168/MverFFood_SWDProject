import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linear_gradient/linear_gradient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd301/models/user_model.dart';
import 'package:swd301/utils/login_utils.dart';
import 'package:swd301/values/colors.dart';

class LoginScreen extends StatefulWidget {
  static const String tag = 'loginPage';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool _isLogging = false;
  List<int> gradients = [
    LinearGradientStyle.GRADIENT_TYPE_GREEN_BEACH,
    LinearGradientStyle.GRADIENT_TYPE_KYE_MEH,
    LinearGradientStyle.GRADIENT_TYPE_AMIN
  ];

  int index = 0;

  @override
  void initState() {
    changeIndex();
    super.initState();
  }

  void changeIndex() {
    Random random = new Random();
    setState(() => index = random.nextInt(3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradientStyle.linearGradient(
                    gradientType: gradients[index],
                    orientation: LinearGradientStyle.ORIENTATION_HORIZONTAL)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                !_isLogging
                    ? Padding(
                        padding: const EdgeInsets.only(top: 150.0),
                        child: Image.asset('assets/images/1.png'),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alata',
                                fontStyle: FontStyle.italic),
                            children: <TextSpan>[
                              TextSpan(text: 'Quick \n'),
                              TextSpan(text: 'Tasty'),
                            ]),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 40.0, bottom: 40.0),
                        child: RaisedButton(
                          onPressed: _isLogging
                              ? () {}
                              : () async {
                                  setState(() {
                                    _isLogging = true;
                                  });
                                  bool res = await signIn();
                                  if (res) {
                                    navigationPage();
                                  }
                                },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          splashColor: Colors.deepOrange.withOpacity(0.2),
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image(
                                image:
                                    AssetImage("assets/images/google_logo.png"),
                                height: 35,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150.0, left: 40.0),
            child: Container(
              height: 300,
              width: 300,
              child: _isLogging
                  ? FlareActor("assets/flare/loading.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "loading")
                  : null,
            ),
          )
        ],
      ),
    );
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('homePage');
  }

  Future<bool> signIn() async {
    bool result = false;
    UserModel userModel;
    userModel = await LoginUtils.signInWithGmail(_googleSignIn, firebaseAuth);
    if (userModel != null) {
      result = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('idUser') == null)
        await prefs.setString('idUser', userModel.idUser);
        await prefs.setString('tokenJWT', userModel.tokenJWT);
    }
    setState(() {
      _isLogging = false;
    });
    return result;
  }
}
