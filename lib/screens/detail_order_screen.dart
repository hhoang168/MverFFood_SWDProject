import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:swd301/models/orderdetail_model.dart';
import 'package:swd301/values/colors.dart';

class DetailOrderScreen extends StatefulWidget {
  static const String tag = 'detailOrderScreen';
  List<OrderDetailModel> data;

  DetailOrderScreen({this.data});

  @override
  _DetailOrderScreenState createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    widget.data.forEach((value) {
      setState(() {
        _totalPrice += value.unitPrice * value.quantity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'My cart',
          style: TextStyle(fontFamily: 'Mont'),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.only(top: 10.0),
//                  child: Row(
//                    mainAxisSize: MainAxisSize.max,
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Container(
//                        decoration: BoxDecoration(
//                          border: Border(
//                            bottom: BorderSide(width: 1.0, color: Colors.black),
//                          ),
//                        ),
//                        child: Text('My Cart',
//                            style: TextStyle(
//                                fontSize: 30,
//                                fontWeight: FontWeight.w300,
//                                fontFamily: 'Alata')),
//                      ),
//                    ],
//                  ),
//                ),
                Expanded(
                  child: widget.data.length > 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            shrinkWrap: true,
                            itemCount: widget.data.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.all(5),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 70,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        widget.data[index].productImageLink !=
                                                null
                                            ? CachedNetworkImage(
                                                imageUrl: widget.data[index]
                                                    .productImageLink,
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/images/4.png'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                                '${widget.data[index].productName}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 20.0)),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                    '${widget.data[index].quantity} ${widget.data[index].quantity > 1 ? 'items' : 'item'} - ',
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w300)),
                                                Text(
                                                    '${FlutterMoneyFormatter(amount: widget.data[index].quantity * widget.data[index].unitPrice).output.withoutFractionDigits}đ',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Text('No Items!'),
                ),
                Container(
                  height: 80,
                  color: primaryColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontFamily: 'Alata',
                              fontSize: 25,
                              color: Colors.white),
                          text: 'Total: ',
                          children: [
                            TextSpan(
                                text:
                                    '${FlutterMoneyFormatter(amount: _totalPrice).output.withoutFractionDigits}đ',
                                style: TextStyle(color: white,fontWeight: FontWeight.w600))
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
