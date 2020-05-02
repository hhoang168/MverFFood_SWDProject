import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swd301/api/store_api_service.dart';
import 'package:swd301/models/store_model.dart';
import 'package:swd301/screens/result_screen.dart';
import 'package:swd301/screens/store_detail_tmp.dart';
import 'package:swd301/screens/view_all_store_screen.dart';
import 'package:swd301/values/strings.dart';
import 'package:swd301/widgets/store_item.dart';

import '../values/colors.dart';
import '../values/fryo_icon.dart';
import '../values/styles.dart';

class FoodTab extends StatefulWidget {
  @override
  _FoodTabState createState() => _FoodTabState();
}

class _FoodTabState extends State<FoodTab> {
  String _tokenJWT;
  List<StoreModel> storeRating;
  List<StoreModel> storeBeverage;

  @override
  void initState() {
//    getStores();
    super.initState();
    getTokenJWT();
  }

  void getTokenJWT() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _tokenJWT = sharedPreferences.getString('tokenJWT');
    });
//    print('Sharepreferences $_tokenJWT');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 200.0,
            width: MediaQuery.of(context).size.width,
            child: Carousel(
              showIndicator: true,
              autoplay: true,
              images: [
                CachedNetworkImage(
                  imageUrl:
                      'https://images.foody.vn/biz_banner/foody-upload-api-food-biz-191125102915.jpg',
                  fit: BoxFit.cover,
                ),
                CachedNetworkImage(
                  imageUrl:
                      'https://images.foody.vn/biz_banner/foody-upload-api-food-biz-191202091238.jpg',
                  fit: BoxFit.cover,
                ),
                CachedNetworkImage(
                  imageUrl:
                      'https://images.foody.vn/biz_banner/foody-upload-api-food-biz-191202164116.jpg',
                  fit: BoxFit.cover,
                ),
              ],
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotIncreasedColor: highlightColor,
              dotColor: Colors.black.withOpacity(0.2),
              dotPosition: DotPosition.bottomRight,
              indicatorBgPadding: 5.0,
            ),
          ),
          headerTopCategories(_tokenJWT, context),
          deals('Best Choice', onViewMore: () {
            clickToViewMore(storeRating);
          }, listItem: _buildBestChoice(false)),
          deals('Beverage', onViewMore: () {
            clickToViewMore(storeBeverage);
          }, listItem: _buildBestChoice(true)),
        ],
      ),
    );
  }

  void goStoreDetail(StoreModel storeModel) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StoreDetailTmp(store: storeModel);
    }));
  }

  void clickToViewMore(List<StoreModel> stores) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewAllStore(
        stores: stores,
      );
    }));
  }

  Widget _buildBestChoice(bool drink) {
    return FutureBuilder(
      future: !drink ? getStores() : getDrinks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<StoreModel> stores = snapshot.data;
          return ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: stores.length,
              itemBuilder: (context, index) {
                return storeItem(stores[index], onTapped: () {
                  goStoreDetail(stores[index]);
                });
              });
        } else {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey[300],
                child: _buildShimmerLayout(),
              );
            },
            itemCount: 3,
          );
        }
      },
    );
  }

  Container _buildShimmerLayout() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Container(
              color: Colors.grey,
              width: 180,
              height: 180,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.grey,
            width: 150,
            height: 10,
          ),
        ],
      ),
    );
  }

  Future<List<StoreModel>> getStores() async {
    final myService = StoreApiService.create();
    final response = await myService.getStoresByRating(_tokenJWT);
    storeRating = response.body;
    return response.body;
  }

  Future<List<StoreModel>> getDrinks() async {
    final myService = StoreApiService.create();
    final response = await myService.getStoresHaveDrink(_tokenJWT);
    storeBeverage = response.body;
    return response.body;
  }
}

Widget sectionHeader(String headerTitle, bool isCate, {onViewMore}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10),
        child: Text(
          headerTitle,
          style: TextStyle(
              letterSpacing: 0.2,
              fontSize: 22,
              color: Colors.blueGrey,
              fontFamily: 'Alata',
              fontWeight: FontWeight.w600),
        ),
      ),
      isCate
          ? Container(
              child: SizedBox(
                height: 45,
              ),
            )
          : Container(
              margin: EdgeInsets.only(left: 15, top: 2),
              child: FlatButton(
                onPressed: onViewMore,
                child: Text('View all ›', style: contrastText),
              ),
            )
    ],
  );
}

// wrap the horizontal listview inside a sizedBox..
Widget headerTopCategories(String tokenJWT, BuildContext context) {
  return Card(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        sectionHeader('Categories', true, onViewMore: () {}),
        SizedBox(
          height: 130,
          child: ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              headerCategoryItem('Frieds', Fryo.dinner, onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewStore(
                    cateID: Category.frieds,
                    token: tokenJWT,
                    cateName: 'Frieds',
                  );
                }));
              }),
              headerCategoryItem('Fast Food', Fryo.food, onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewStore(
                    cateID: Category.fastFood,
                    token: tokenJWT,
                    cateName: 'Fast Food',
                  );
                }));
              }),
              headerCategoryItem('Creamery', Fryo.poop, onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewStore(
                    cateID: Category.creamery,
                    token: tokenJWT,
                    cateName: 'Creamery',
                  );
                }));
              }),
              headerCategoryItem('Drinks', Fryo.cup, onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewStore(
                    cateID: Category.drinks,
                    token: tokenJWT,
                    cateName: 'Drinks',
                  );
                }));
              }),
              headerCategoryItem('Vegetables', Fryo.leaf, onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewStore(
                    cateID: Category.vegetable,
                    token: tokenJWT,
                    cateName: 'Vegetables',
                  );
                }));
              }),
            ],
          ),
        )
      ],
    ),
  );
}

Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
  return Container(
    margin: EdgeInsets.only(left: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 8),
            width: 90,
            height: 90,
            child: FloatingActionButton(
              shape: CircleBorder(),
              heroTag: name,
              onPressed: onPressed,
              backgroundColor: white,
              child: Icon(icon, size: 35, color: primaryColor),
            )),
        Text(name + ' ›', style: categoryText)
      ],
    ),
  );
}

Widget deals(String dealTitle, {onViewMore, Widget listItem}) {
  return Container(
    margin: EdgeInsets.only(top: 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        sectionHeader(dealTitle, false, onViewMore: onViewMore),
        SizedBox(
          height: 250,
          child: listItem,
        )
      ],
    ),
  );
}
