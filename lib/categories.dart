import 'dart:convert';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glam0/models/cat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'models/cat.dart';


class Categories extends StatefulWidget {

  @override
  _CategoriesState createState() => _CategoriesState();

}

class _CategoriesState extends State<Categories> {

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

  @override
  initState(){
    fetchCategories().then((value){
      setState(() {
        _cat = _cat.toList();
        _cat.addAll(value);
      });
    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffDB3022),
        title: Text("Categories"),
      ),
      body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Container(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 8),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 180,
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
                                _cat[index].cat_name,
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

