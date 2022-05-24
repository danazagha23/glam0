import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'models/cart.dart';
import 'edit_profile_page.dart';
class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  saveItem(String prd_id,String prd_name ,String prd_price,String prd_image,
      String prd_description,String prd_quantity) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("pid",prd_id);
    preferences.setString("pname",prd_name);
    preferences.setString("pprice",prd_price);
    preferences.setString("pimage",prd_image);
    preferences.setString("pdescription",prd_description);
    preferences.setString("pquantity",prd_quantity);
  }

  var cust_id ;
  var prd_size ;
  var prd_color ;

  Future getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      cust_id = preferences.getString("cust_id")??'';
    });
  }

  Future deleteItem(String id) async {
    await http.post(Uri.parse(CONFIG.CARTDEL),
        body: {
          'pro_id': id
        }
    );
  }
  Future deleteItems() async {
    await http.post(Uri.parse(CONFIG.ITEMDEL),
        body: {
          'cust_id': cust_id
        }
    );
  }

  var i = 0;
  Future getTotal() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      i = int.parse(preferences.getString("total")??'');
    });
  }

  List<cart> products = List<cart>.empty(growable: true);

  Future<List<cart>> fetchItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      cust_id = preferences.getString("cust_id")??'';
    });
    var response = await http.post(Uri.parse(CONFIG.CARTPRO),
        body: {
          'cust_id': cust_id
        });

    var items = List<cart>.empty(growable: true);

    if(response.statusCode == 200) {
      var itemsJson = json.decode(response.body);
      for(var dataJson in itemsJson){
        items.add(cart.fromJson(dataJson));
        // i = i + int.parse(cart.fromJson(dataJson).prd_price)*int.parse(cart.fromJson(dataJson).quantity);
        quantity = int.parse(cart.fromJson(dataJson).quantity);
      }
    }

    return items;
  }
  Future fetchOrders2() async {

    var response = await http.post(Uri.parse(CONFIG.CARTPRO),
        body: {
          'cust_id': cust_id
        });

    if(response.statusCode == 200) {
      var itemsJson = json.decode(response.body);
      for(var dataJson in itemsJson){
        final response = await http.post(Uri.parse(CONFIG.ORDERDET),
            body: {
              'cust_id': cust_id,
              'prd_id': cart.fromJson(dataJson).product_id,
              'quantity': cart.fromJson(dataJson).quantity,
              'color': cart.fromJson(dataJson).color,
              'size': cart.fromJson(dataJson).size,
            }
        );
      }
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    getTotal();
    fetchItems().then((value){
      setState(() {
        products = products.toList();
        products.addAll(value);
      });
    });
  }

  List<TextEditingController> _quantityController = new List<TextEditingController>.empty(growable: true);
  int quantity=1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffDB3022),
          title: Text("Checkout"),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  right: 8.0, top: 8.0, left: 8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary:  Color(0xffDB3022),
                  ),
                  child: Text("Edit your information",
                      style: TextStyle(
                          color: Colors.white)),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/settings');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => profile(),),);

                  }),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: 8.0, top: 8.0, left: 8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary:  Color(0xffDB3022),
                  ),
                  child: Text("Delivery details",
                      style: TextStyle(
                          color: Colors.white)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: Container(
                  child: Text(products.length.toString() + " ITEMS IN YOUR CART", textDirection: TextDirection.ltr, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
              ),
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: products.length,

                  itemBuilder: (context, index) {
                    final item = products[index];
                    String s = item.prd_image;
                    _quantityController.add(new TextEditingController());
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
                              .showSnackBar(SnackBar(content: Text(item.prd_name+ " dismissed"), duration: Duration(seconds: 1)));
                        } else {
                          // Then show a snackbar.
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text(item.prd_name + " added to carts"), duration: Duration(seconds: 1)));
                        }
                        // Remove the item from the data source.
                        setState(() {
                          i = i - int.parse(item.prd_price)*int.parse(item.quantity);
                          deleteItem(item.product_id);
                          products.removeAt(index);
                        });

                      },
                      // Show a red background as the item is swiped away.
                      background: Container(
                        decoration: BoxDecoration(color: Colors.red),
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Icon(Icons.delete, color: Colors.white),
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
                              item.prd_description,
                              item.quantity
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
                              padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                              child: ListTile(
                                // trailing: Text('\$ ${item.prd_price }'),
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
                                title:
                                Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20,top: 10.0,bottom: 5.0),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 15.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text(item.prd_name, style: TextStyle(
                                                  color: Color(0xffDB3022),
                                                  fontWeight: FontWeight.w700,
                                                )),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 15.0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                    child: Text('\$ ${item.prd_price }')
                                                ),

                                                Container(
                                                    margin: const EdgeInsets.only(top: 8.0),
                                                    color: Colors.white,
                                                    child: ButtonTheme(
                                                      height: 16.0,
                                                      minWidth: 10.0,
                                                      child: RaisedButton(
                                                          padding: const EdgeInsets.all(4.0),
                                                          color: Colors.white,
                                                          child: Icon(Icons.remove, color: Colors.black,
                                                            size: 20.0,),
                                                          onPressed: () async{
                                                            _removeQuantity(index);
                                                            if(quantity > 0){
                                                              final response = await http.post(Uri.parse(CONFIG.QUAN),
                                                                  body: {
                                                                    'cust_id': cust_id,
                                                                    'prd_id': item.product_id,
                                                                    'quantity': quantity.toString()
                                                                  }
                                                              );
                                                              setState(() {
                                                                i = i - int.parse(item.prd_price);
                                                              });
                                                            }else if(quantity == 0){
                                                              setState(() {
                                                                i = i - (int.parse(item.prd_price)*int.parse(item.quantity));
                                                                deleteItem(item.product_id);
                                                                products.removeAt(index);
                                                              });
                                                            }
                                                          }
                                                      ),
                                                    )
                                                ),

                                                Container(
                                                    width: 60.0,
                                                    padding: const EdgeInsets.only(left: 1.0, right: 1.0),
                                                    child: Center(
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        decoration: new InputDecoration(
                                                          hintText: item.quantity,
                                                        ),
                                                        keyboardType: TextInputType.number,
                                                        controller: _quantityController[index],
                                                      ),
                                                    )
                                                ),

                                                Container(
                                                  margin: const EdgeInsets.only(top: 8.0),
                                                  color: Colors.white,
                                                  child: ButtonTheme(
                                                    height: 16.0,
                                                    minWidth: 10.0,
                                                    child: RaisedButton(
                                                        padding: const EdgeInsets.all(4.0),
                                                        color: Colors.white,
                                                        child: Icon(
                                                            Icons.add, color: Colors.black, size: 20.0),
                                                        onPressed: () async {
                                                          _addQuantity(index);
                                                          final response = await http.post(Uri.parse(CONFIG.QUAN),
                                                              body: {
                                                                'cust_id': cust_id,
                                                                'prd_id': item.product_id,
                                                                'quantity': quantity.toString()
                                                              }
                                                          );
                                                          setState(() {
                                                            i = i + int.parse(item.prd_price);
                                                          });

                                                        }
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom :30.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text("TOTAL", style: TextStyle(fontSize: 16, color: Colors.grey),)
                            ),
                            Text(i.toString(),  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                )
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50, bottom: 10),
              child: ButtonTheme(
                buttonColor:  Color(0xffDB3022),
                minWidth: double.infinity,
                height: 40.0,
                child: RaisedButton(
                  onPressed: () {
                    fetchOrders();
                    fetchOrders2();
                    deleteItems();
                    Fluttertoast.showToast(
                        msg: 'Order Placed!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        fontSize: 16.0);

                    Navigator.pushNamed(context, '/cart');},
                  child: Text(
                    "Place your order",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
  Future fetchOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      cust_id = preferences.getString("cust_id")??'';
    });
    var response = await http.post(Uri.parse(CONFIG.ORDER),
        body: {
          'cust_id': cust_id,
          'price': i.toString()
        });
    fetchOrders2();

  }
  // Future fetchOrders2() async {
  //   var response = await http.post(Uri.parse(CONFIG.ORDERDET));
  // }
  void _addQuantity(int index){
    setState(() {
      quantity++;
      _quantityController[index].text = '$quantity';
    });
  }

  void _removeQuantity(int index){
    setState(() {
      if(quantity > 0){
        quantity--;
      }else{
        quantity = 0;
      }
      _quantityController[index].text = '$quantity';
    });
  }
}