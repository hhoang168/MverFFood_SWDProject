import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  static const tag = 'userInfo';
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('User Info'),
    );
  }
}
