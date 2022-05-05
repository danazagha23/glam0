import 'dart:convert';
import 'package:like_button/like_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../models/item.dart';
import 'config.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  var prd_id;
  var prd_name;
  var prd_price;
  var prd_image;
  var prd_description;
  var prd_quantity;
  var prd_color;
  var prd_size;
  var prd_date;
  var catid;
  getItem() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      prd_id = preferences.getString("pid")!;
      prd_name = preferences.getString("pname")!;
      prd_image = preferences.getString("pimage")!;
      prd_price = preferences.getString("pprice")!;
      prd_description = preferences.getString("pdescription")!;
      prd_quantity = preferences.getString("pquantity")!;
      prd_color = preferences.getString("pcolor")!;
      prd_size = preferences.getString("psize")!;
      prd_date = preferences.getString("pdate")!;
      catid = preferences.getString("pcatid")!;
    });
  }
  var selected_size;
  var selected_color;

  var cust_id ;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      cust_id = preferences.getString("cust_id")??'';
    });
  }
  Future cartTapped() async{
    var quantity = '1';
    final response = await http.post(Uri.parse(CONFIG.CART),
        body: {
          'cust_id': cust_id,
          'prd_id': prd_id,
          'quantity': quantity,
          'color': selected_color,
          'size': selected_size,
        }
    );
  }
  bool _isFavorited = false;
  void onLikeButtonTapped() async{
      if(_isFavorited) {
        setState(() {
          _isFavorited=false;
        });
        final response = await http.post(Uri.parse(CONFIG.WISHDEL),
            body: {
              'pro_id':prd_id
            }
        );
      }else{
        setState(() {
          _isFavorited=true;
        });
        final response = await http.post(Uri.parse(CONFIG.WISH),
            body: {
              'prd_id':prd_id,
              'cust_id':cust_id
            }
        );
      }
  }
  int selectedColor = -1;
  int selectedSize = -1;
  List listSize = new List.empty(growable: true);
  List listColor = new List.empty(growable: true);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItem();
    getPref();
  }

  Color getColor(String color) {
    switch (color) {
    //add more color as your wish
      case "Colors.red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      case "yellow":
        return Colors.yellow;
      case "orange":
        return Colors.orange;
      case "green":
        return Colors.green;
      case "Colors.white":
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }
  @override
  Widget build(BuildContext context) {
    bool isLiked =false;
    listColor = prd_color.split(",");
    listSize = prd_size.split(",");
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xffDB3022),
        title: Text('Product Detail'),
      ),
      body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 300,
                  child:
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/'+prd_image),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  ),

                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment(-1.0, -1.0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 15),
                                child: Text(
                                  prd_name,
                                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    alignment: Alignment.centerRight,
                                    icon: (_isFavorited
                                        ? const Icon(Icons.favorite)
                                    : const Icon(Icons.favorite_border)),
                                    color: Colors.red[500],
                                    onPressed: onLikeButtonTapped,
                                  ),
                                ),
                                // LikeButton(
                                //   size: 35,
                                //   isLiked: isLiked,
                                //   circleColor:
                                //   CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                //   bubblesColor: BubblesColor(
                                //     dotPrimaryColor: Color(0xff33b5e5),
                                //     dotSecondaryColor: Color(0xff0099cc),
                                //   ),
                                //
                                //   onTap: onLikeButtonTapped,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Colour",
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {

                            return GestureDetector(
                              child: Container(
                                width: 24,
                                margin: EdgeInsets.all(4),
                                height: 24,
                                decoration: BoxDecoration(
                                    color: getColor(listColor[index]),
                                    border: Border.all(color: Colors.grey, width: selectedColor == index ? 2 : 0),
                                    shape: BoxShape.circle),
                              ),
                              onTap: () {
                                setState(() {
                                  selected_color = listColor[index];
                                  selectedColor = index;
                                });
                              },
                            );
                          },
                          itemCount: listColor.length,
                        ),
                      ),
                      Container(
                        height: 16,
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 8),
                        child: Text(
                          "Size",
                          style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child:Container(
                              width: 28,
                              margin: EdgeInsets.all(4),
                              height: 28,
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                listSize[index],
                                style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.8)),
                                textAlign: TextAlign.center,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: selectedSize == index ? Colors.blue : Colors.grey, width: 1),
                                  shape: BoxShape.circle),
                              ),
                              onTap: () {
                                setState(() {
                                  selected_size = listSize[index];
                                  selectedSize = index;
                                });
                              },
                            );
                          },
                          itemCount: listSize.length,

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 16,
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 8),
                              child: Text(
                                "Price",
                                style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 12),
                              ),
                            ),
                            Container(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    '\$'+prd_price,
                                    style: TextStyle(
                                        color: Color(0xff9B9B9B),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            child:  ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xffDB3022),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                ),
                              ),
                              onPressed: () {
                                cartTapped();
                                Navigator.pushNamed(context, '/cart');

                              },
                              child: Text(
                                "Add to cart".toUpperCase(),
                              ),
                            ),

                          ),
                          ),
                          Container(
                              alignment: Alignment(-1.0, -1.0),
                              child: Padding(
                                padding: const EdgeInsets.only(top:10.0 ,bottom: 10.0),
                                child: Text(
                                    'Description',
                                  style: TextStyle(color: Colors.black, fontSize: 20,  fontWeight: FontWeight.w600),
                                ),
                              )
                          ),
                          Container(
                              alignment: Alignment(-1.0, -1.0),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  prd_description,
                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                ),
                              )
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

      ),
    );
  }
  // void addSize() {
  //   listSize.add("S");
  //   listSize.add("M");
  //   listSize.add("L");
  //   listSize.add("XL");
  // }
}

