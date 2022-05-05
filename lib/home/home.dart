import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glam0/localizations.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/cat.dart';
import '../models/item.dart';
import 'drawer.dart';
import 'slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  saveItem(String prd_id,String prd_name ,String prd_price,String prd_image,
      String prd_description,String prd_quantity,String prd_color,String prd_size,String prd_date,String catid) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("pid",prd_id);
    preferences.setString("pname",prd_name);
    preferences.setString("pprice",prd_price);
    preferences.setString("pimage",prd_image);
    preferences.setString("pdescription",prd_description);
    preferences.setString("pquantity",prd_quantity);
    preferences.setString("pcolor",prd_color);
    preferences.setString("psize",prd_size);
    preferences.setString("pdate",prd_date);
    preferences.setString("catid",catid);
  }
  saveCat(String cat_id,String cat_name) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("catid",cat_id);
    preferences.setString("catname",cat_name);
  }


  List<cat> _cat = List<cat>.empty(growable: true);

  Future<List<cat>> fetchCategories() async {
    var response = await http.get(Uri.parse(CONFIG.CAT));
    var cats = List<cat>.empty(growable: true);

    if(response.statusCode == 200) {
      var catsJson = json.decode(response.body);
      for(var dataJson in catsJson){
        cats.add(cat.fromJson(dataJson));
      }

    }

    return cats;
  }
  List<item> _item = List<item>.empty(growable: true);

  Future<List<item>> fetchItems() async {
    var response = await http.get(Uri.parse(CONFIG.ITEM));
    var items = List<item>.empty(growable: true);

    if(response.statusCode == 200) {
      var itemsJson = json.decode(response.body);
      for(var dataJson in itemsJson){
        items.add(item.fromJson(dataJson));
      }

    }

    return items;
  }


  final List<String> imgList = [
    "assets/images/c2.jpg",
    "assets/images/c4.jpg",
    "assets/images/c6.jpg",
    "assets/images/c5.jpg",
    "assets/images/c1.jpg",
    "assets/images/c3.jpg",
    "assets/images/c7.jpg"

  ];
  @override
  initState(){
    fetchCategories().then((value){
      setState(() {
        _cat = _cat.toList();
        _cat.addAll(value);
      });
      fetchItems().then((value){
        setState(() {
          _item = _item.toList();
          _item.addAll(value);
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: CustomScrollView(
            // Add the app bar and list of items as slivers in the next steps.
            slivers: <Widget>[
              SliverAppBar(
                // Provide a standard title.
                // title: Text('asdas'),
                // pinned: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {},
                  )
                ],
                // Allows the user to reveal the app bar if they begin scrolling
                // back up the list of items.
                // floating: true,
                // Display a placeholder widget to visualize the shrinking size.
                flexibleSpace: HomeSlider(),
                // Make the initial height of the SliverAppBar larger than normal.
                expandedHeight: 300,
              ),
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(top: 14.0, left: 8.0, right: 8.0),
                        child: Text(
                            AppLocalizations.of(context)!
                                .translate('NEW_ARRIVALS') ?? '',
                            style: TextStyle(
                                color:  Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        height: 240.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:  List.generate(_item.length, (index) {
                                return Container(
                                  width: 140.0,
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () {
                                        saveItem(
                                            _item[index].prd_id,
                                            _item[index].prd_name,
                                            _item[index].prd_price,
                                            _item[index].prd_image,
                                            _item[index].prd_description,
                                            _item[index].prd_quantity,
                                            _item[index].prd_color,
                                            _item[index].prd_size,
                                            _item[index].prd_date,
                                            _item[index].cat_id
                                        );
                                        Navigator.pushNamed(
                                            context, '/products');
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 160,
                                              child:
                                              Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/images/'+_item[index].prd_image),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              _item[index].prd_name,
                                              style: TextStyle(fontSize: 14
                                                  // ,color: Color(0xff9B9B9B)
                                              ),
                                            ),
                                            subtitle: Text('\$'+_item[index].prd_price,
                                                style: TextStyle(
                                                    color:  Color(0xffDB3022),
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                            }
                        ),
                      ),
                      ),
                      Container(
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 6.0, left: 8.0, right: 8.0),
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/banner-1.png'),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Text('Shop By Category',
                                style: TextStyle(
                                    color:  Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 8.0, top: 8.0, left: 8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary:  Color(0xffDB3022),
                                ),
                                child: Text('View All',
                                    style: TextStyle(
                                        color: Colors.white)),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/categorise');
                                }),
                          )
                        ],
                      ),
                      Container(
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          padding: EdgeInsets.only(
                              top: 8, left: 6, right: 6, bottom: 12),
                          children: List.generate(_cat.length, (index) {
                            return Container(
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                    saveCat(_cat[index].cat_id,_cat[index].cat_name);
                                    Navigator.pushNamed(
                                        context, '/Clothes');
                                    print('Card tapped.');
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                70,
                                        width: double.infinity,
                                        child:
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/'+_cat[index].cat_image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                          title: Text(
                                            _cat[index].cat_name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 6.0, left: 8.0, right: 8.0, bottom: 10),
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/banner-2.png'),
                          ),
                        ),
                      )
                    ],
                  ),
                  // Builds 1000 ListTiles
                  childCount: 1,
                ),
              )
            ]),
      ),
    );
  }
}
