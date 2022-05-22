import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../get_store.dart';
import '../models/item.dart';
import 'search.dart';

class StoreItems extends StatefulWidget {
  @override
  _StoreItemsState createState() => _StoreItemsState();
}


class _StoreItemsState extends State<StoreItems> {
  var store_id;
  var store_name;
  getStore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString("storeid")!;
      store_name = preferences.getString("storename")!;
    });
  }
  saveItem(String prd_id,String prd_name ,String prd_price,String prd_image,
      String prd_description,String prd_quantity,String prd_date,String catid,String storeid,String storename) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("pid",prd_id);
    preferences.setString("pname",prd_name);
    preferences.setString("pprice",prd_price);
    preferences.setString("pimage",prd_image);
    preferences.setString("pdescription",prd_description);
    preferences.setString("pquantity",prd_quantity);
    preferences.setString("catid",catid);
    preferences.setString("pstoreid",storeid);
    preferences.setString("pstorename",storename);
  }

  List<item> _item = List<item>.empty(growable: true);

  Future<List<item>> fetchItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString("storeid")!;
      store_name = preferences.getString("storename")!;
    });
    var response = await http.post(Uri.parse(CONFIG.SELST),
          body: {
            'store_id': store_id
          });

    var items = List<item>.empty(growable: true);

    if(response.statusCode == 200) {
      var itemsJson = json.decode(response.body);
      for(var dataJson in itemsJson){
        items.add(item.fromJson(dataJson));
      }

    }

    return items;
  }
  @override
  initState(){
    getStore();
    fetchItems().then((value){
      setState(() {
        _item = _item.toList();
        _item.addAll(value);
      });
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                scaffoldKey.currentState!
                    .showBottomSheet((context) => ShopSearch());
              },
            )
          ],
          title: Text(store_name),
          backgroundColor: Color(0xffDB3022),
        ),
        body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(

                  child: GridView.count(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 12),
                    children: List.generate(_item.length, (index) {
                      String s =_item[index].prd_image;
                      getStoreName(_item[index].store_id,_item[index].prd_id);
                      return Container(
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
                                  _item[index].prd_date,
                                  _item[index].cat_id,
                                  _item[index].store_id,
                                  _item[index].store_name,
                              );
                              Navigator.pushNamed(
                                  context, '/products');
                              print('Card tapped.');
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: <Widget>[
                                SizedBox(
                                  height: (MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2 - 5),
                                  width: double.infinity,
                                  child:
                                  Container(
                                      child: Image.memory(
                                        base64Decode(s),
                                        fit: BoxFit.cover,
                                      )
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0),
                                  child: ListTile(
                                    title: Text(
                                      _item[index].prd_name,
                                      style: TextStyle(
                                          fontWeight: FontWeight
                                              .bold,
                                          fontSize: 16
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets
                                                  .only(top: 2.0,
                                                  bottom: 1),
                                              child: Text('\$' +
                                                  _item[index]
                                                      .prd_price,
                                                  style: TextStyle(
                                                    color: Color(0xffDB3022),
                                                    fontWeight: FontWeight
                                                        .w700,
                                                  )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(  _item[index].store_name +' Store',
                                                style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w700,
                                                  fontStyle: FontStyle
                                                      .italic,
                                                  color: Colors
                                                      .grey,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                //     ],
                //   ),
                // ),
              ],
            ),
        ),

      ),
    );
  }
}