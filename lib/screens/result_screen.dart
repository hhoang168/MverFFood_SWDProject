import 'package:flutter/material.dart';
import 'package:swd301/api/store_api_service.dart';
import 'package:swd301/models/store_model.dart';
import 'package:swd301/screens/store_detail_tmp.dart';
import 'package:swd301/values/colors.dart';

class ViewStore extends StatefulWidget {
  final String token;
  final String cateID;
  final String cateName;

  ViewStore({this.token, this.cateID, this.cateName});

  @override
  _ViewStoreState createState() => _ViewStoreState();
}

class _ViewStoreState extends State<ViewStore> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('${widget.cateName}'),
      ),
      body: FutureBuilder(
        future: loadStoreByCate(widget.cateID, widget.token),
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(
                    child: Text(
                  'No stores available !',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blueGrey,
                  ),
                ));
              if (snapshot.data != null) {
                List<StoreModel> stores = snapshot.data;
                return ListView.separated(
                  separatorBuilder: (context, value) => Divider(
                    thickness: 1,
                  ),
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () => goStoreDetail(stores[index]),
                          child: _buildStore(stores[index])),
                    );
                  },
                  itemCount: stores.length,
                );
              }
          }
          ;
        },
      ),
    );
  }

  Widget _buildStore(StoreModel store) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(5),
                bottomLeft: Radius.circular(20),
              ),
              image: DecorationImage(
                  image: store.imageUrl != null
                      ? NetworkImage(store.imageUrl)
                      : AssetImage('assets/images/4.png'),
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              store.name,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mont',
                  fontSize: 20.0),
            ),
          )
        ],
      ),
    );
  }

  Future<List<StoreModel>> loadStoreByCate(String idCate, String token) async {
    List<StoreModel> rs = [];
    final myService = StoreApiService.create();
    final response = await myService.getStoreByCategory(token, idCate);
    if (response.statusCode == 200) {
      return response.body;
    }
    return rs;
  }

  void goStoreDetail(StoreModel storeModel) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StoreDetailTmp(store: storeModel);
    }));
  }
}
