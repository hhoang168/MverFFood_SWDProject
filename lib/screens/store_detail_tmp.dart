import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd301/api/order_api_service.dart';
import 'package:swd301/models/orderdetail_model.dart';
import 'package:swd301/models/product_model.dart';
import 'package:swd301/models/requestorder_model.dart';
import 'package:swd301/models/store_model.dart';
import 'package:swd301/screens/product_page.dart';
import 'package:swd301/values/colors.dart';

// Day la mot screen not tab

class StoreDetailTmp extends StatefulWidget {
  final StoreModel store;

  StoreDetailTmp({this.store});

  @override
  _StoreDetailTmpState createState() => _StoreDetailTmpState();
}

class _StoreDetailTmpState extends State<StoreDetailTmp> {
  bool _isProcessing = false;
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
  final snackBarDelete = SnackBar(
      content: Text(
    'Deleted !',
    style: TextStyle(fontSize: 20.0, fontFamily: 'Alata'),
  ));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Offset state <-------------------------------------
  double offset = 0.0;

  List<ProductModel> _products = [];

  //A map with key:idProduct -  value:list
  Map<String, OrderDetailModel> _cart = Map();
  int _totalItems = 0;

  String _idUser = '';
  String _tokenJWT = '';

  @override
  void initState() {
    _products = widget.store.productsByIdStore;
    getIdUser();
    super.initState();
  }

  void getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getString('idUser');
      _tokenJWT = prefs.getString('tokenJWT');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: _idUser != widget.store.idUser
            ? Stack(
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        iconTheme: IconThemeData(color: Colors.white),
                        backgroundColor: Colors.deepOrange,
                        pinned: true,
                        floating: false,
                        expandedHeight: 160.0,
                        flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              widget.store.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Mont',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            background: widget.store.imageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: widget.store.imageUrl,
                                    fit: BoxFit.cover,
                                    color: Colors.black.withOpacity(0.4),
                                    colorBlendMode: BlendMode.darken,
                                  )
                                : Image.asset(
                                    'assets/images/3.jpg',
                                    fit: BoxFit.cover,
                                    color: Colors.black.withOpacity(0.35),
                                    colorBlendMode: BlendMode.darken,
                                  )),
                      ),
                      _products.length != 0
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return _product(_products[index]);
                                },
                                childCount: _products.length,
                              ),
                            )
                          : SliverFillRemaining(
                              child: Text(
                                'It will be available soon !',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Alata',
                                    color: Colors.blueGrey),
                              ),
                            ),
                    ],
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
                                              color: Colors.black,
                                              fontFamily: 'Mont'),
                                          children: [
                                            TextSpan(text: '$_totalItems '),
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
                      : SizedBox.shrink(),
                ],
              )
            : Center(
                child: Container(
                  child: Text('You cannot purchased your own store'),
                ),
              ));
  }

  Widget _product(ProductModel productModel) {
    return InkWell(
      onTap: () async {
        int quantity = 1;
        if (_cart.length > 0 && _cart.containsKey(productModel.idProduct)) {
          quantity = _cart[productModel.idProduct].quantity;
        }
        Map results =
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductPage(productData: productModel, quantity: quantity);
        }));
        if (results != null && results.containsKey('quantity')) {
          _createOrderDetail(productModel, results['quantity']);
        }
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Stack(children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  child: CachedNetworkImage(
                    imageUrl: productModel.imageLink,
                    placeholder: (context, snapshot) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                  height: 120,
                  width: 120,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
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
                          fontSize: 19,
                          color: primaryColor,
                          fontFamily: 'Alata'),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 55,
              right: 0,
              child: InkWell(
                onTap: () {
                  _createOrderDetail(productModel, 1);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: primaryColor,
                      size: 18,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: primaryColor, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                splashColor: primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                highlightColor: primaryColor,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  _createOrderDetail(ProductModel productModel, int quantity) {
    OrderDetailModel orderDetailModel = OrderDetailModel(
        idProduct: productModel.idProduct,
        productName: productModel.name,
        quantity: quantity,
        unitPrice: productModel.price);

    if (_cart.containsKey(productModel.idProduct)) {
//      print('2nd TIME');
      if (quantity == 1) {
        _cart[productModel.idProduct].quantity += 1;
      } else {
        _cart[productModel.idProduct].quantity = quantity;
      }
    } else {
      setState(() {
//        print('1ST TIME');
        _cart[productModel.idProduct] = orderDetailModel;
      });
    }
    _calculateItems();
  }

  _calculateItems() {
    _totalItems = 0;
    List<OrderDetailModel> orderData =
        _cart.entries.map((entry) => entry.value).toList();
    orderData.forEach((element) {
      setState(() {
        _totalItems += element.quantity;
      });
    });
  }

  _buildBottomSheet(BuildContext contexts) {
    List<OrderDetailModel> orderData =
        _cart.entries.map((entry) => entry.value).toList();
    double totalPrice = 0;
    orderData.forEach((element) {
      totalPrice += element.unitPrice * element.quantity;
    });
    return StatefulBuilder(
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            Container(
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
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.black),
                            ),
                          ),
                          child: Text('My Cart',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Alata')),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: _cart.length > 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              shrinkWrap: true,
                              itemCount: _cart.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Card(
                                  child: SizedBox(
                                    height: 70,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                                '${orderData[index].productName}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 20.0)),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                    '${orderData[index].quantity} ${orderData[index].quantity > 1 ? 'items' : 'item'} - ',
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w300)),
                                                Text(
                                                    '${FlutterMoneyFormatter(amount: orderData[index].quantity * orderData[index].unitPrice).output.withoutFractionDigits}đ',
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
                                );
                              },
                            ),
                          )
                        : Text('No Items!'),
                  ),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontFamily: 'Alata',
                                fontSize: 18,
                                color: Colors.black),
                            text: 'Total: ',
                            children: [
                              TextSpan(
                                  text:
                                      '${FlutterMoneyFormatter(amount: totalPrice).output.withoutFractionDigits}đ',
                                  style: TextStyle(color: Colors.red))
                            ],
                          ),
                        ),
                        Spacer(),
                        //Check out
                        FlatButton(
                          color: Colors.deepOrange,
                          textColor: Colors.white,
                          onPressed: !_isProcessing
                              ? () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) => _buildDialog(
                                          context, state, orderData));
                                  totalPrice = 0;
                                }
                              : () {},
                          child: SizedBox(
                              width: 100,
                              height: 50,
                              child: Center(
                                  child: Text(
                                'Check-out',
                                style: TextStyle(
                                    fontFamily: 'Alata', fontSize: 18.0),
                              ))),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Center(child: _isProcessing ? CircularProgressIndicator() : null),
            Positioned(
              top: 15,
              right: 20,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _cart.clear();
                  });
                  Navigator.pop(context);
                  _scaffoldKey.currentState.showSnackBar(snackBarDelete);
                },
                child: Container(
                  height: 30,
                  width: 50,
                  child: Center(
                    child: Icon(
                      CupertinoIcons.delete_simple,
                      color: primaryColor,
                      size: 18,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: primaryColor, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                splashColor: primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialog(BuildContext context, StateSetter state,
      List<OrderDetailModel> orderData) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text('Do you want to check-out ?'),
      actions: <Widget>[
        FlatButton(
          textColor: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        SizedBox(
          width: 10,
        ),
        FlatButton(
          textColor: Colors.green,
          onPressed: () async {
            //Processing
            updated(state);
            _checkOut(orderData).whenComplete(() {
              Navigator.pop(context);
              setState(() {
                _cart.clear();
              });
              Navigator.pop(context);
            }).then((success) {
              //process done
              updated(state);
              _scaffoldKey.currentState
                  .showSnackBar(success ? snackBar : snackBarFail);
            });
          },
          child: Text('Check-out'),
        )
      ],
    );
  }

  Future<Null> updated(StateSetter updateState) async {
    updateState(() {
      _isProcessing = _isProcessing ? false : true;
    });
  }

  Future<bool> _checkOut(List<OrderDetailModel> data) async {
    bool result = false;
    if (data != null && data.length > 0) {
      final myService = OrderApiService.create();
      final response = await myService.createOrder(
          _tokenJWT,
          RequestOrderModel(
            idStore: widget.store.idStore,
            idUser: _idUser,
            notes: '',
            orderDetailDTOList: data,
          ));
      if (response.body != null) {
        result = true;
//        print('Success');
      }
    }
    return result;
  }
}
