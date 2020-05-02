import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swd301/tabs/order_tab.dart';
import 'package:swd301/tabs/profile_tab.dart';
import 'package:swd301/tabs/search_tab.dart';
import 'package:swd301/utils/firebase_notification_handler.dart';

import '../tabs/food_tab.dart';

class HomePage extends StatefulWidget {
  static const String tag = 'homePage';
  final int tabIndex;

  HomePage({this.tabIndex = 0});

  @override
  _HomePageState createState() => _HomePageState(tabIndex);
}

class _HomePageState extends State<HomePage> {
  int _currentIndex;
  static FirebaseUser _user;
  static String photoUrl;
  static String username;
  List<Widget> _tab;
  FirebaseMessaging firebaseMessage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final snackBar = SnackBar(
      content: Text(
    'Order successful!',
    style: TextStyle(fontSize: 20.0, fontFamily: 'Alata'),
  ));
  final snackBarFail = SnackBar(
      content: Text(
    'Order failed! Out of money',
    style: TextStyle(fontSize: 20.0, fontFamily: 'Alata'),
  ));

  _HomePageState(this._currentIndex);

  @override
  void initState() {
    super.initState();
    getUser();
    new FirebaseNotifications().setUpFirebase();
    firebaseMessage = FirebaseMessaging();
    firebaseMessage.configure(
      onMessage: (Map<String, dynamic> message) async {
        String _message = message['notification']['title'];
        if (_message == 'Order successful') {
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else {
          _scaffoldKey.currentState.showSnackBar(snackBarFail);
        }
      },
      onResume: (Map<String, dynamic> message) async{
        print('$message');
//        Navigator.of(context).pushReplacementNamed('detailOrderScreen');
      },
      onLaunch: (Map<String, dynamic> message) async{
        print('$message');
//        Navigator.of(context).pushReplacementNamed('detailOrderScreen');
      },
    );
  }

  void getUser() async {
    _user = await FirebaseAuth.instance.currentUser();
    photoUrl = _user.photoUrl;
    username = _user.displayName;
//    print('providerid '+_user.uid);
    setState(() {
      _tab = [
        //Home
        FoodTab(),
        //Search
        SearchTab(),
        //Order
        OrderTab(),
        //Profile
        ProfileTab(
          photoUrl: photoUrl,
          username: username,
        ),
      ];
    });
  }

  _buildNoInternetWidget() {
    return Container(
      child: Center(child: Text('No internet!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          body: _tab == null ? _buildNoInternetWidget() : _tab[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() {
              _currentIndex = index;
            }),
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: Colors.blueGrey,
            elevation: 1,
            items: [
              BottomNavigationBarItem(
                  title: Text("Menu"),
                  icon: Icon(Icons.restaurant_menu),
                  activeIcon: Icon(Icons.restaurant_menu)),
              BottomNavigationBarItem(
                title: Text("Search"),
                icon: Icon(CupertinoIcons.search),
              ),
              BottomNavigationBarItem(
                title: Text("Order"),
                icon: Icon(CupertinoIcons.tags),
                activeIcon: Icon(CupertinoIcons.tags_solid),
              ),
              BottomNavigationBarItem(
                title: Text("Me"),
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
              )
            ],
          )),
    );
  }
}
