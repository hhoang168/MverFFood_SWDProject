import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:swd301/models/product_model.dart';
import 'package:swd301/values/colors.dart';
import 'package:swd301/values/styles.dart';
import 'package:swd301/widgets/food_item.dart';

class ProductPage extends StatefulWidget {
  final ProductModel productData;
  final int quantity;

  ProductPage({Key key, this.productData, this.quantity}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _quantity = 1;
  double _totalPrice = 0;
  FlutterMoneyFormatter fmm = FlutterMoneyFormatter(amount: 0);

  @override
  void initState() {
    fmm = FlutterMoneyFormatter(amount: _quantity * widget.productData.price);
    setState(() {
      _quantity = widget.quantity;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: bgColor,
            centerTitle: true,
            leading: BackButton(
              color: darkText,
            ),
            title: Text(widget.productData.name, style: h4),
          ),
          body: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(top: 100, bottom: 100),
                          padding: EdgeInsets.only(top: 80, bottom: 50),
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  FlutterMoneyFormatter(
                                          amount: (widget.productData.price)
                                              .toDouble())
                                      .output
                                      .withoutFractionDigits,
                                  style: h3),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 25),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text('Quantity', style: h6),
                                      margin: EdgeInsets.only(bottom: 15),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 55,
                                          height: 55,
                                          child: OutlineButton(
                                            onPressed: () {
                                              setState(() {
                                                if (_quantity == 1) return;
                                                _quantity -= 1;
                                                _totalPrice = _quantity
                                                        .toDouble() *
                                                    widget.productData.price;
                                                fmm = FlutterMoneyFormatter(
                                                    amount: _totalPrice);
                                              });
                                            },
                                            child: Icon(Icons.remove),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(_quantity.toString(),
                                              style: h3),
                                        ),
                                        Container(
                                          width: 55,
                                          height: 55,
                                          child: OutlineButton(
                                            onPressed: () {
                                              setState(() {
                                                if (_quantity == 10) return;
                                                _quantity += 1;
                                                _totalPrice = _quantity
                                                        .toDouble() *
                                                    widget.productData.price;
                                                fmm = FlutterMoneyFormatter(
                                                    amount: _totalPrice);
                                              });
                                            },
                                            child: Icon(Icons.add),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 50.0, left: 10, right: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    //Total price
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontFamily: 'Alata',
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(text: 'Total price: \n'),
                                          TextSpan(
                                              text:
                                                  '${fmm.output.withoutFractionDigits}đ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: primaryColor)),
                                        ],
                                      ),
                                    ),
                                    //Add to cart
                                    RaisedButton(
                                      color: primaryColor,
                                      //produce a order detail
                                      onPressed: () {
                                        _selectItem(_quantity, context);
                                      },
                                      child: Text(
                                        'Add to cart',
                                        style: TextStyle(
                                            fontFamily: 'Alata', fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                    color: Color.fromRGBO(0, 0, 0, .05))
                              ]),
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 200,
                            height: 160,
                            child: foodItem(
                              widget.productData,
                              isProductPage: true,
                              onTapped: () {},
                              imgWidth: 250,
                            ),
                          )),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  void _selectItem(int value, BuildContext context) {
    Navigator.of(context).pop({'quantity': value});
  }
}
