import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  BuildContext context;

  FirebaseNotifications({this.context});

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() async {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
//      print('TOKEN MESSAGE: $token');
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String idUser = sharedPreferences.getString("idUser");
//    print('ID USER $idUser');
    _firebaseMessaging.subscribeToTopic(idUser);
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
