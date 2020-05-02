import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swd301/api/account_api_service.dart';
import 'package:swd301/screens/account_screen.dart';
import 'package:swd301/values/colors.dart';

class ProfileTab extends StatefulWidget {
  final String username;
  final String photoUrl;

  ProfileTab({this.photoUrl, this.username});

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String _idUser;
  String _tokenJWT;
  double _totalBalance = 0;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    getIdUser().whenComplete(() {
      _fetchAccount().whenComplete(() {
        setState(() {
          _isFetching = false;
        });
      });
    });
  }

  var menuItems = [
    MenuItem(
        icon: Icon(CupertinoIcons.group_solid),
        name: 'Invite friends',
        onClick: () {}),
    MenuItem(
        icon: Icon(Icons.credit_card),
        name: 'Payment accounts',
        onClick: () {}),
    MenuItem(icon: Icon(Icons.security), name: 'User policy', onClick: () {}),
    MenuItem(
        icon: Icon(CupertinoIcons.info), name: 'About now', onClick: () {}),
  ];

  Future<bool> getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getString('idUser');
      _tokenJWT = prefs.get('tokenJWT');
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
                child: Text('Me',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                radius: 60.0,
                backgroundColor: Colors.blueGrey,
                backgroundImage: AssetImage('assets/images/2.png'),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.username,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 10,
              ),
              _isFetching
                  ? Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey[300],
                      child: Container(
                        width: 150,
                        height: 10,
                        color: Colors.grey,
                      ))
                  : Text(
                      'Balance: ${FlutterMoneyFormatter(amount: _totalBalance).output.withoutFractionDigits}đ',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Alata'),
                    ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.blueGrey,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: menuItems.length,
                    itemBuilder: (BuildContext context, int i) {
                      return InkWell(
                        onTap: menuItems[i].onClick,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              menuItems[i].icon,
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                menuItems[i].name,
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'Alata'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: OutlineButton(
                      padding: EdgeInsets.all(10),
                      borderSide: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      splashColor: primaryColor.withOpacity(0.2),
                      onPressed: () {
                        GoogleSignIn().signOut();
                        navigationPage();
                      },
                      child: Container(
                        width: 250,
                        child: Center(
                          child: Text(
                            'Sign out',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Alata',
                                color: Colors.blueGrey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void navigationPage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear().whenComplete(() {
      Navigator.of(context).pushReplacementNamed('loginPage');
    });
  }

  void onClickPaymentAccount(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AccountScreen();
    }));
  }

  Future<bool> _fetchAccount() async {
    var myService = AccountApiService.create();
    var response = await myService.getAccountByUserID(_tokenJWT, _idUser);
//    print(response.body[0].balance);
    if (response.statusCode == 200) {
      response.body.forEach((account) {
        setState(() {
          _totalBalance += account.balance;
        });
      });
    }
    return true;
  }
}

class MenuItem {
  String name;
  Icon icon;
  var onClick;

  MenuItem({this.name, this.icon, this.onClick});
}
