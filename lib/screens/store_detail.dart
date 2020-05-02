import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:swd301/models/orderdetail_model.dart';
import 'package:swd301/models/product_model.dart';
import 'package:swd301/models/store_model.dart';
import 'package:swd301/screens/product_page.dart';
import 'package:swd301/values/colors.dart';
import 'package:swd301/values/styles.dart';

// Day la mot screen not tab

class StoreDetail extends StatefulWidget {
  final StoreModel store;

  StoreDetail({this.store});

  @override
  _StoreDetailState createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  bool _favor = false;
  List<ProductModel> _products = [];
  Map<String, OrderDetailModel> _cart = Map();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _products = widget.store.productsByIdStore;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          //Store product
          Padding(
            padding: EdgeInsets.only(top: 280),
            child: _products.length != 0
                ? ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return _product(_products[index]);
                    },
                  )
                : Center(
                    child: Text(
                      'It will be available soon !',
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Alata',
                          color: Colors.blueGrey),
                    ),
                  ),
          ),
          //Store info
          Container(
            height: 300,
            child: Material(
              // <----------------------------- Outer Material
              elevation: 6.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  image: widget.store.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(widget.store.imageUrl),
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.35), BlendMode.darken),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: AssetImage('assets/images/1.png')),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Material(
                      //Action Bar
                      type: MaterialType.transparency,
                      elevation: 6.0,
                      color: Colors.transparent,
                      shadowColor: Colors.grey[50],
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              _onBack(context);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Icon(
                              Icons.arrow_back,
                              size: 25.0,
                              color: widget.store.imageUrl != null
                                  ? white
                                  : Colors.black,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _favor = _favor ? false : true;
                              });
                            },
                            child: Icon(
                              _favor ? Icons.favorite : Icons.favorite_border,
                              color: white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    //Store Name
                    Text(
                      widget.store.name,
                      style: TextStyle(
                        color: widget.store.imageUrl != null
                            ? white
                            : Colors.blueGrey,
                        fontSize: 30,
                        fontFamily: 'Mont',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _cart.length != 0
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: RaisedButton(
                      onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (ctx) => _buildBottomSheet(ctx)),
                      color: white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      splashColor: Colors.greenAccent.withOpacity(0.2),
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Icon(
                              Icons.shopping_basket,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontFamily: 'Mont'),
                                  children: [
                                    TextSpan(text: '${_cart.length} '),
                                    _cart.length <= 1
                                        ? TextSpan(text: 'item')
                                        : TextSpan(text: 'items')
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              'View your cart',
                              style: TextStyle(
                                fontFamily: 'Alata',
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                            ),
                          ]),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _product(ProductModel productModel) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductPage(
            productData: productModel,
          );
        }));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  child: CachedNetworkImage(
                    imageUrl: productModel.imageLink,
                    placeholder: (context, snapshot) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    fit: BoxFit.scaleDown,
                  ),
                  height: 150,
                  width: 150,
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${productModel.name}',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Alata',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${FlutterMoneyFormatter(amount: productModel.price).output.withoutFractionDigits}đ',
                        style: TextStyle(
                            fontSize: 17,
                            color: primaryColor,
                            fontFamily: 'Alata'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 55,
              right: 0,
              child: InkWell(
                onTap: () {
                  _createOrderDetail(productModel);
                },
                child: Icon(
                  Icons.plus_one,
                  color: primaryColor,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  _createOrderDetail(ProductModel productModel) {
    OrderDetailModel orderDetailModel = OrderDetailModel(
        idProduct: productModel.idProduct,
        productName: productModel.name,
        quantity: 1,
        unitPrice: productModel.price);
    if (_cart.containsKey(productModel.idProduct)) {
    } else {
      setState(() {
        _cart[productModel.idProduct] = orderDetailModel;
      });
    }
  }

  void _onBack(BuildContext context) {
    Navigator.of(context).pop(false);
  }

  _buildBottomSheet(BuildContext context) {
    List<OrderDetailModel> orderData =
        _cart.entries.map((entry) => entry.value).toList();

    double totalPrice = 0;
    orderData.forEach((element) {
      totalPrice += element.unitPrice * element.quantity;
    });
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.black),
                    ),
                  ),
                  child: Text('My Cart',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Alata')),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                shrinkWrap: true,
                itemCount: _cart.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 20.0,
                              ),
                              children: [
                                TextSpan(
                                    text: '${orderData[index].productName} - '),
                                TextSpan(
                                    text: '${orderData[index].quantity} - '),
                                TextSpan(
                                    text:
                                        '${FlutterMoneyFormatter(amount: orderData[index].quantity * orderData[index].unitPrice).output.withoutFractionDigits}đ'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
//              separatorBuilder: (context, index) {
//                return Divider(
//                  thickness: 1,
//                );
//              },
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Alata', fontSize: 18,color: Colors.black),
                  text: 'Total: ',
                  children: [
                    TextSpan(
                        text:
                            '${FlutterMoneyFormatter(amount: totalPrice).output.withoutFractionDigits}đ',
                        style: TextStyle(color: primaryColor))
                  ],
                ),
              ),
              Spacer(),
              RaisedButton(
                onPressed: () {},
                color: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                splashColor: Colors.greenAccent.withOpacity(0.2),
                child: Text(
                  'Check out',
                  style: TextStyle(fontSize: 15.0, fontFamily: 'Alata'),
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          )
        ],
      ),
    );
  }
}
