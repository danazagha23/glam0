import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/banner.dart';

class HomeSlider extends StatefulWidget {
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  String s1 ='' , s2='' , s3='';
  Future<String> getBanner(String place) async {

    print('inside the getBanner function with placement '+place );
    var map = Map <String, dynamic>();
    map['action'] = "GET_BANNER";
    map['place'] = place;
    var response = await http.post(Uri.parse(CONFIG.BANNER), body:map);
    String imageCode = '';
    if(response.statusCode == 200) {
      print(response.body);
      print('inside the getBanner function with placement '+place );

      Map<String, dynamic> userMap = jsonDecode(response.body);
      MyBanner banner = MyBanner.fromJson(userMap);
      imageCode = banner.imageCode;
      print("image Code is ");
      print(imageCode);


    }

    return imageCode;
  }
  @override

  initState(){


    getBanner('3').then((slider1) {
      s1 = slider1;
    });

    getBanner('4').then((slider2) {
      s2 = slider2;
    });

    getBanner('5').then((slider2) {
      s3 = slider2;
    });




  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Center(
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                height: 350,
                pauseAutoPlayOnTouch: true,
                viewportFraction: 1.0
              ),
              items: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      child: Image.memory(   //////////////////////////////
                        base64Decode(s1),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      child: Image.memory(   //////////////////////////////
                        base64Decode(s2),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      child: Image.memory(   //////////////////////////////
                        base64Decode(s3),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
              ]

            ),
          ),
        ],
      ),
    );
  }
}
