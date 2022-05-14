import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../models/cat.dart';
class ShopSearch extends StatefulWidget {
  @override
  _ShopSearchState createState() => _ShopSearchState();
}


class _ShopSearchState extends State<ShopSearch> {
  saveSearch(String cat,String fprice,String sprice) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("search_cat",cat);
    preferences.setString("search_fprice",fprice);
    preferences.setString("search_sprice",sprice);
  }
  ////GET ALL STORES
  // List<store> _store = List<store>.empty(growable: true);
  //
  // Future<List<store>> fetchStores() async {
  //   var response = await http.get(Uri.parse(CONFIG.CAT));
  //   var stores = List<store>.empty(growable: true);
  //
  //   if(response.statusCode == 200) {
  //     var catsJson = json.decode(response.body);
  //     for(var dataJson in catsJson){
  //       stores.add(store.fromJson(dataJson));
  //     }
  //
  //   }
  //
  //   return stores;
  // }

  String cat = '';
  var fprice;
  var sprice;


  String dropdownValue = 'Clothes';
  RangeValues _values = RangeValues(0.0, 500.0);

  Widget build(BuildContext context) {
    return Container(
      height: 425,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                blurRadius: 2, color: Colors.black12, spreadRadius: 3)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                  child: Container(
                    width: 30,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                Container(
                  margin: new EdgeInsetsDirectional.only(bottom: 15.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      icon: Icon(Icons.keyboard_arrow_down),
                      style: TextStyle(
                          color: Colors.black
                      ),
                      underline: Container(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          cat = dropdownValue;
                        });
                      },
                      items: <String>['Clothes', 'Shoes', 'Accessories']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                      'Select Price Range', style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
                RangeSlider(
                    values: _values,
                    min: 0,
                    max: 5000,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey[300],
                    onChanged: (RangeValues values) {
                      setState(() {
                        if (values.end - values.start >= 20) {
                          _values = values;
                          fprice = values.start;
                          sprice = values.end;
                        } else {
                          if (_values.start == values.start) {
                            _values = RangeValues(_values.start, _values.start + 20);
                            fprice = values.start;
                          } else {
                            _values = RangeValues(_values.end - 20, _values.end);
                            sprice = values.end;
                          }
                        }
                      });
                    }
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 120,
                          height: 45.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Theme.of(context).accentColor),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('\$ ${_values.start.round()}', style: TextStyle(color: Colors.white)),
                          )
                      ),
                      Text('to', style: TextStyle(fontSize: 16, color: Colors.black),),
                      Container(
                          width: 120,
                          height: 45.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Theme.of(context).accentColor),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('\$ ${_values.end.round()}', style: TextStyle(color: Colors.white)),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ButtonTheme(
                        buttonColor: Theme.of(context).primaryColor,
                        minWidth: double.infinity,
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () {
                            saveSearch(cat,fprice.toString(),sprice.toString());
                            Navigator.pushNamed(context, '/filter');
                          },
                          child: Text(
                            "Apply Filters",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
      ),
    );
  }
}
