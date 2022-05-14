import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/item.dart';
import 'config.dart';
import 'models/wish.dart';

class WishList extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<WishList> {
  saveItem(String prd_id,String prd_name ,String prd_price,String prd_image,
      String prd_description) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("pid",prd_id);
    preferences.setString("pname",prd_name);
    preferences.setString("pprice",prd_price);
    preferences.setString("pimage",prd_image);
    preferences.setString("pdescription",prd_description);
  }
  var cust_id ;

  Future getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      cust_id = preferences.getString("cust_id")??'';
    });
  }


  Future deleteItem(String id) async {
    await http.post(Uri.parse(CONFIG.WISHDEL),
        body: {
          'pro_id': id
        }
    );
  }
  List<wish> products = List<wish>.empty(growable: true);

  Future<List<wish>> fetchItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      cust_id = preferences.getString("cust_id")??'';
    });
    var response = await http.post(Uri.parse(CONFIG.WISHPRO),
        body: {
          'cust_id': cust_id
        });

    var items = List<wish>.empty(growable: true);

    if(response.statusCode == 200) {
      var itemsJson = json.decode(response.body);
      for(var dataJson in itemsJson){
        items.add(wish.fromJson(dataJson));
      }

    }

    return items;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    fetchItems().then((value){
      setState(() {
        products = products.toList();
        products.addAll(value);
      });
    });
  }
  // String base64string='';
  // Future getimage(String i,String p) async{
  //   final response = await http.post(Uri.parse(CONFIG.ROOT),
  //       body: {
  //         'image_id': i,
  //         'prd_id': p
  //       }
  //   );
  //   base64string=response.body;
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffDB3022),
        title: Text('Wishlist'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          String s =item.prd_image;
          // getimage(item.prd_image,item.product_id);
          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(UniqueKey().toString()),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              if(direction == DismissDirection.endToStart) {
                // Then show a snackbar.
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(item.prd_name + " dismissed"), duration: Duration(seconds: 1)));
              } else {
                // Then show a snackbar.
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(item.prd_name + " added to carts"), duration: Duration(seconds: 1)));
              }
              // Remove the item from the data source.
              setState(() {
                deleteItem(item.product_id);
                products.removeAt(index);
              });
            },
            // Show a red background as the item is swiped away.
            background: Container(
              decoration: BoxDecoration(color: Colors.green),
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(Icons.add_shopping_cart, color: Colors.white),
                  ),

                ],
              ),
            ),
            secondaryBackground: Container(
              decoration: BoxDecoration(color: Colors.red),
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),

                ],
              ),
            ),
            child: InkWell(
              onTap: () {
                saveItem(
                    item.product_id,
                    item.prd_name,
                    item.prd_price,
                    item.prd_image,
                    item.prd_description
                );
                Navigator.pushNamed(
                    context, '/products');
                print('Card tapped.');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: ListTile(
                      trailing: Icon(Icons.swap_horiz),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue
                          ),
                          child:
                          Container(
                              child: Image.memory(
                                base64Decode(s),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                      ),
                      title: Text(
                        item.prd_name,
                        style: TextStyle(
                            fontSize: 14
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                child: Text('\$'+item.prd_price, style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w700,
                                )),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[

                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
