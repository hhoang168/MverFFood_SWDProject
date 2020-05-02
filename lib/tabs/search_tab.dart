import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd301/api/category_api_service.dart';
import 'package:swd301/api/store_api_service.dart';
import 'package:swd301/models/category_model.dart';
import 'package:swd301/models/store_model.dart';
import 'package:swd301/screens/store_detail_tmp.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String _tokenJWT = '';

  int _selectedChipIndex = 0;
  Future<List<CategoryModel>> categories;
  Future<List<StoreModel>> stores;
  final TextEditingController _controller = new TextEditingController();
  bool editing = false;

  @override
  void initState() {
    super.initState();
    getIdUser().whenComplete(() {
      stores = _fetchAllStores();
      categories = _fetchCategories();
    });
  }

  Future<bool> getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tokenJWT = prefs.get('tokenJWT');
    });
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        //Search bar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Theme(
              data:
                  ThemeData(primaryColor: Colors.blueGrey, fontFamily: 'Mont'),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 8.0,
                shadowColor: Colors.grey,
                child: TextField(
                  controller: _controller,
                  onTap: () {
                    setState(() {
                      editing = true;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: editing
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () =>
                                Future.delayed(Duration(milliseconds: 50))
                                    .then((_) {
                              _controller.clear();
                            }),
                          )
                        : Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'What are you looking for?',
                  ),
                  onSubmitted: (searchValue) {
                    setState(() {
                      if (searchValue.isEmpty) {
                        stores = _fetchAllStores();
                      } else {
                        stores = _fetchStoresByName(searchValue);
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        FutureBuilder(
            future: categories,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<CategoryModel> data = snapshot.data;
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: _buildCategories(data),
                  ),
                );
                // ignore: missing_return
              } else {
                return Container();
              }
            }),
        FutureBuilder(
          future: stores,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<StoreModel> data = snapshot.data;
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: _buildListStore(data),
                ),
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
          },
        ),
      ],
    );
  }

  List<Widget> _buildListStore(List<StoreModel> data) {
    List<Widget> result = [];
    for (int i = 0; i < data.length; i++) {
      result.add(_buildStore(data[i]));
    }
    return result;
  }

  Widget _buildStore(StoreModel store) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        child: ListTile(
          leading: store.imageUrl != null
              ? CachedNetworkImage(
                  width: 80,
                  imageUrl: store.imageUrl,
                  fit: BoxFit.cover,
                )
              : SizedBox(
                  width: 80,
                  child: Image.asset(
                    'assets/images/4.png',
                    fit: BoxFit.cover,
                  )),
          title: Text(
            store.name,
            style: TextStyle(fontFamily: 'Mont', fontWeight: FontWeight.w600),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.blueGrey,
            size: 15,
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return StoreDetailTmp(
                store: store,
              );
            }));
          },
        ),
      ),
    );
  }

  List<Widget> _buildCategories(List<CategoryModel> data) {
    List<Widget> result = [];
    for (int i = 0; i < data.length; i++) {
      if (i == 0) {
        result.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ChoiceChip(
            selected: _selectedChipIndex == i,
            onSelected: (selected) {
              setState(() {
                stores = _fetchAllStores();
                _selectedChipIndex = i;
              });
            },
            label: Text(
              'All',
              style: TextStyle(
                  fontFamily: 'Mont',
                  color:
                      _selectedChipIndex == i ? Colors.white : Colors.black87),
            ),
            selectedColor: Colors.deepOrange,
            padding: EdgeInsets.all(5),
          ),
        ));
      } else {
        result.add(_buildCategory(data[i], i));
      }
    }
    return result;
  }

  Widget _buildCategory(CategoryModel category, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ChoiceChip(
        selected: _selectedChipIndex == index,
        onSelected: (selected) {
          setState(() {
            stores = _fetchStoreByCate(category.idCategory);
            _selectedChipIndex = index;
          });
        },
        label: Text(
          '${category.name}',
          style: TextStyle(
              fontFamily: 'Mont',
              color:
                  _selectedChipIndex == index ? Colors.white : Colors.black87),
        ),
        selectedColor: Colors.deepOrange,
        padding: EdgeInsets.all(5),
      ),
    );
  }

  Future<List<CategoryModel>> _fetchCategories() async {
    final myService = CategoryApiService.create();
    final response = await myService.getCategories(_tokenJWT);
    return response.body;
  }

  Future<List<StoreModel>> _fetchStoresByName(String searchValue) async {
    final myService = StoreApiService.create();
    final response = await myService.getStoreByName(_tokenJWT, searchValue);
    return response.body;
  }

  Future<List<StoreModel>> _fetchAllStores() async {
    final myService = StoreApiService.create();
    final response = await myService.getStores(_tokenJWT, true);
    return response.body;
  }

  Future<List<StoreModel>> _fetchStoreByCate(String idCate) async {
    final myService = StoreApiService.create();
    final response = await myService.getStoreByCategory(_tokenJWT, idCate);
    return response.body;
  }
}
