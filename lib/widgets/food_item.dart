import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swd301/models/product_model.dart';
import 'package:swd301/values/colors.dart';
import 'package:swd301/values/styles.dart';

Widget foodItem(ProductModel food,
    {double imgWidth, onTapped, bool isProductPage = false}) {
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
                elevation: (isProductPage) ? 20 : 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: onTapped,
                child: Hero(
                  transitionOnUserGestures: true,
                  tag: food.idProduct,
                  child: food.imageLink != null
                      ? CachedNetworkImage(
                          imageUrl: food.imageLink,
                          fit: BoxFit.cover,
                        )
                      : Image.asset('assets/images/1.png'),
                ))),
        Positioned(
          bottom: 0,
          left: 0,
          child: (!isProductPage)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${food.price}', style: priceText),
                  ],
                )
              : Text(' '),
        ),
      ],
    ),
  );
}
