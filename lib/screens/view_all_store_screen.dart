import 'package:flutter/material.dart';
import 'package:swd301/models/store_model.dart';
import 'package:swd301/screens/store_detail_tmp.dart';
import 'package:swd301/values/colors.dart';
import 'package:swd301/widgets/store_item.dart';

class ViewAllStore extends StatefulWidget {
  List<StoreModel> stores;

  ViewAllStore({this.stores});

  @override
  _ViewAllStoreState createState() => _ViewAllStoreState();
}

class _ViewAllStoreState extends State<ViewAllStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.stores != null
          ? CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(color: Colors.black),
                  backgroundColor: Colors.transparent,
                  title: Text(
                    'View all store',
                    style: TextStyle(color: Colors.black, fontFamily: 'Mont'),
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return SizedBox(
                      height: 250,
                      child: storeItem(widget.stores[index], onTapped: () {
                        goStoreDetail(widget.stores[index]);
                      }),
                    );
                  }, childCount: widget.stores.length),
                )
              ],
            )
          : Center(
              child: Container(
                child: Text('No item'),
              ),
            ),
    );
  }

  void goStoreDetail(StoreModel storeModel) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StoreDetailTmp(store: storeModel);
    }));
  }
}
