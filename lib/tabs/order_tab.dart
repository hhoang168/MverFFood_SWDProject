import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd301/api/order_api_service.dart';
import 'package:swd301/models/orderdetail_model.dart';
import 'package:swd301/models/requestorder_model.dart';
import 'package:swd301/models/responseorder_model.dart';
import 'package:swd301/screens/detail_order_screen.dart';
import 'package:swd301/values/colors.dart';

class OrderTab extends StatefulWidget {
  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  String _idUser = '';
  bool _isRating = false;
  String _tokenJWT = '';
  Future<List<ResponseOrderModel>> orders;
  List<ResponseOrderModel> responseOrderList = [];

  @override
  void initState() {
    super.initState();
    getIdUser().whenComplete(() {
      orders = _fetchOrders();
    });
  }

  Future<bool> getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getString('idUser');
      _tokenJWT = prefs.get('tokenJWT');
    });
    return true;
  }

  Future<List<ResponseOrderModel>> _fetchOrders() async {
    List<ResponseOrderModel> orderList = [];
    if (_idUser != null) {
      final myService = OrderApiService.create();
      var response = await myService.getOrder(_tokenJWT, _idUser);
      orderList = response.body;
    }
    return orderList;
  }

  int _value = 0;
  List<DropdownMenuItem> _items = [
    DropdownMenuItem(
      value: 0,
      child: Text('Status: All'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Status: Pending'),
    ),
    DropdownMenuItem(
      value: 2,
      child: Text('Status: Done'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ResponseOrderModel> data = snapshot.data;
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  backgroundColor: white,
//                  centerTitle: true,
                  title: Text(
                    'Order History',
                    style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'Alata',
                        fontSize: 20.0),
                  ),
                  actions: <Widget>[
                    DropdownButton(
                      iconSize: 20.0,
                      iconEnabledColor: _value == 0
                          ? Colors.black87
                          : _value == 1 ? Colors.green : Colors.orangeAccent,
                      style: TextStyle(
                          fontFamily: 'Alata',
                          color: _value == 0
                              ? Colors.black87
                              : _value == 1
                                  ? Colors.green
                                  : Colors.orangeAccent,
                          fontSize: 15.0),
                      items: _items,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                          buildList(data, value);
//                          print('CLICKED $_value');
                        });
                      },
                      value: _value,
                      icon: Icon(Icons.sort),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildOrder(
                        _value == 0 ? data[index] : responseOrderList[index]);
                  },
                      childCount:
                          _value == 0 ? data.length : responseOrderList.length),
                )
              ],
            );
          } else {
            return Center(
              child: Container(
                height: 300,
                width: 300,
                child: FlareActor("assets/flare/loading.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "loading"),
              ),
            );
          }
        });
  }

  void buildList(List<ResponseOrderModel> data, int value) {
    switch (value) {
      case 1:
        responseOrderList =
            data.where((e) => e.status.toLowerCase() == 'pending').toList();
        break;
      case 2:
        responseOrderList =
            data.where((e) => e.status.toLowerCase() == 'done').toList();
        break;
    }
  }

  Widget _buildOrder(ResponseOrderModel data) {
    int totalItems = 0;
    List<OrderDetailModel> items = data.orderDetail;
    items.forEach((element) {
      totalItems += element.quantity;
    });

    return GestureDetector(
      onTap: () => _viewDetailOrder(data.orderDetail),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Card(
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Food| ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.blueGrey)),
                              TextSpan(
                                  text: '${data.status}',
                                  style: TextStyle(
                                      color: data.status == 'PENDING'
                                          ? Colors.green
                                          : Colors.orangeAccent)),
                            ],
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                      ),
                      Spacer(),
                      Text('${data.createAt}'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 80.0,
                          height: 80.0,
                          foregroundDecoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                              image: DecorationImage(
                                image: data.storeImageUrl != null
                                    ? CachedNetworkImageProvider(
                                        data.storeImageUrl)
                                    : AssetImage('assets/images/4.png'),
                                fit: BoxFit.cover,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('${data.storeName} \n',
                                  style: TextStyle(
                                      fontFamily: 'Mont',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600)),
                              Spacer(),
                              Text(
                                  '${FlutterMoneyFormatter(amount: data.totalPrice).output.withoutFractionDigits}đ - $totalItems ${totalItems > 1 ? 'items' : 'item'}',
                                  style: TextStyle(fontSize: 18.0)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                data.status == 'PENDING'
                    ? SizedBox(
                        height: 5,
                      )
                    : Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: _isRating
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                          children: <Widget>[
                            OutlineButton(
                              borderSide: BorderSide(color: primaryColor),
                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => buildDialog(data));
                              },
                              child: Text(
                                'Re-Order',
                                style: TextStyle(
                                    color: Colors.red, fontFamily: 'Mont'),
                              ),
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDialog(ResponseOrderModel order) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text('Do you want to Re-Order?'),
      actions: <Widget>[
        FlatButton(
          textColor: Colors.blueGrey,
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
          onPressed: () {
            print('Click');
            _checkOut(order).whenComplete(() {
              setState(() {
                orders = _fetchOrders();
              });
              Navigator.pop(context);
            });
          },
          child: Text('OK'),
        )
      ],
    );
  }

  void _viewDetailOrder(List<OrderDetailModel> listOrder) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailOrderScreen(
        data: listOrder,
      );
    }));
  }

  Future<bool> _checkOut(ResponseOrderModel orderModel) async {
    bool result = false;
    print('ordering');
    if (orderModel.orderDetail != null && orderModel.orderDetail.length > 0) {
      final myService = OrderApiService.create();
      final response = await myService.createOrder(
          _tokenJWT,
          RequestOrderModel(
            idStore: orderModel.idStore,
            idUser: _idUser,
            notes: '',
            orderDetailDTOList: orderModel.orderDetail,
          ));
      if (response.body != null) {
        result = true;
        print('Success');
      }
    }
    return result;
  }
}
