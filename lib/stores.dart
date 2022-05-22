import 'dart:convert';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glam0/models/cat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'models/cat.dart';
import 'models/store.dart';


class Stores extends StatefulWidget {

  @override
  _StoresState createState() => _StoresState();

}

class _StoresState extends State<Stores> {

  saveStore(String store_id,String store_name) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("storeid",store_id);
    preferences.setString("storename",store_name);
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

  @override
  initState(){
    fetchStores().then((value){
      setState(() {
        _store = _store.toList();
        _store.addAll(value);
      });
    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffDB3022),
        title: Text("Stores"),
      ),
      body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Container(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 8),
              children: List.generate(_store.length, (index) {
                return Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 180,
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
                            // CachedNetworkImage(
                            //   fit: BoxFit.cover,
                            //   imageUrl: imgList[index],
                            //   placeholder: (context, url) => Center(
                            //       child: CircularProgressIndicator()
                            //   ),
                            //   errorWidget: (context, url, error) => new Icon(Icons.error),
                            // ),
                          ),
                          ListTile(
                              title: Text(
                                _store[index].store_name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          )),
    );
  }
}

