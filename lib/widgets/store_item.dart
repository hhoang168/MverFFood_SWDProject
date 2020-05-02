import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swd301/models/store_model.dart';
import 'package:swd301/values/colors.dart';
import 'package:swd301/values/styles.dart';

Widget storeItem(StoreModel store, {onTapped, bool isProductPage = false}) {
  return Container(
    width: 180,
    height: 180,
    margin: EdgeInsets.only(left: 20),
    child: Stack(
      children: <Widget>[
        Container(
          width: 180,
          height: 180,
          child: RaisedButton(
            color: white,
            elevation: (isProductPage) ? 20 : 9,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: onTapped,
            child: store.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: store.imageUrl,
                    fit: BoxFit.cover,
                  )
                : Image.asset('assets/images/3.jpg'),
          ),
        ),
        Positioned(
          bottom: 35,
          left: 10,
          child: (!isProductPage)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(store.name.length < 18 ? store.name : '${store.name.substring(0,15)}...', style: foodNameText),
                  ],
                )
              : Text(' '),
        ),
      ],
    ),
  );
}
