import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glam0/localizations.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../main.dart';
import '../models/cat.dart';
import '../models/image.dart';
import '../models/item.dart';
import '../get_store.dart';
import '../models/store.dart';
import 'drawer.dart';
import 'slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  saveItem(String prd_id,String prd_name ,String prd_price,String prd_image,
      String prd_description,String prd_quantity,String prd_color,String prd_size,String prd_date,String catid,String storeid,String storename) async{
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
    preferences.setString("pcatid",catid);
    preferences.setString("pstoreid",storeid);
    preferences.setString("pstorename",storename);
  }
  saveCat(String cat_id,String cat_name) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("catid",cat_id);
    preferences.setString("catname",cat_name);
  }
  saveStore(String store_id,String store_name) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("storeid",store_id);
    preferences.setString("storename",store_name);
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
  ////GET ALL STORES
  List<store> _store = List<store>.empty(growable: true);

  Future<List<store>> fetchStores() async {
    var response = await http.get(Uri.parse(CONFIG.STORE));
    var stores = List<store>.empty(growable: true);

    if(response.statusCode == 200) {
      var catsJson = json.decode(response.body);
      for(var dataJson in catsJson){
        stores.add(store.fromJson(dataJson));
      }

    }

    return stores;
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
var serverToken = 'AAAAwlVlVSg:APA91bGCAru8bqIuJkYay2VtJeDa3aOUje6X_RFbsT491rThvwXhbU1XNbRrpSuoaSS6i29jdGUjQcmxSfmNPjdwN5k376Wu1U7yMNfWZB4883um6BuguHYn-xrXOfBdjty0t5P_DfCO';
sendNotify(String title, String body) async{
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
    <String, dynamic>{
        'notification': <String, dynamic>{
          'body': body.toString(),
          'title': title.toString()
        },
      'priority': 'high',
      'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
      'to': await FirebaseMessaging.instance.getToken()
        },
      ),
    );
}

  @override
  void initState() {
    super.initState();
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
    fetchStores().then((value){
      setState(() {
        _store = _store.toList();
        _store.addAll(value);
      });
    });
    FirebaseMessaging.onMessage.listen((message) {
      print('done');
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }
  int _counter = 0;
  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Delivery",
        "Your order in the way stay awake!",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  var fbm = FirebaseMessaging.instance;
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
                    onPressed: () async {
                      await sendNotify("hhh", "bsdjbasjbdjjdbfjsd");

    fbm.getToken().then((token) {
    print('===================Token============================');
    print(token.toString());});
                      // showNotification();
                      //Navigator.pushNamed(context, '/cart');
                    },
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
                            String s =_item[index].prd_image;
                              return Container(
                                width: 160,
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
                                        _item[index].cat_id,
                                        _item[index].store_id,
                                        _item[index].store_name
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
                                          width: 150,
                                          child:
                                          Container(
                                            padding: EdgeInsets.only(left: 10, right: 10),
                                              child: Image.memory(
                                                base64Decode(s),
                                                fit: BoxFit.cover,
                                              )
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            _item[index].prd_name,
                                            style: TextStyle(fontSize: 14
                                                , color: Color(0xffDB3022)
                                            ),
                                          ),
                                          subtitle:
                                          Text('\$' + _item[index].prd_price +
                                              '\n' + _item[index].store_name + ' Store',
                                              style: TextStyle(
                                                  color: Colors
                                                      .grey,
                                                  fontWeight:
                                                  FontWeight.w700)),

                                        ),

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
                              top: 8, left: 6, right: 6, bottom: 20),
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Text('Stores',
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
                                  Navigator.pushNamed(context, '/stores');
                                }),
                          )
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        height: 160,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:  List.generate(_store.length, (index) {
                            return Container(
                              width: 140,
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                    saveStore(_store[index].store_id,_store[index].store_name);
                                    Navigator.pushNamed(
                                        context, '/storeItems');
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
                                            110,
                                        width: double.infinity,
                                        child:
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/'+_store[index].store_image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                          title: Text(
                                            _store[index].store_name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

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
