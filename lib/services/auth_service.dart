import 'dart:convert';
import 'package:glam0/categories.dart';
import 'package:glam0/config.dart';
import 'package:glam0/models/user.dart';
import 'package:glam0/models/cat.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  savePref(String id,String name,String email,String password,String phone,String address,bool isSignin) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("cust_id",id);
    preferences.setString("cust_name",name);
    preferences.setString("email",email);
    preferences.setString("password",password);
    preferences.setString("phone",phone);
    preferences.setString("address",address);
    preferences.setBool("isSignin",isSignin);
  }

  // Create storage
  Future login(UserCredential userCredential) async {
    final response = await http.post(Uri.parse(CONFIG.LOGIN),
        body: {
      'email': userCredential.email,
      'password': userCredential.password
    });
    List userdata = response.body.split(",");
    if (response.body=="failed" || response.body=="not exist") {
      Fluttertoast.showToast(
          msg: "Invalid ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          fontSize: 16.0);
      savePref(userdata[0], userdata[1], userdata[2], userdata[3], userdata[4], userdata[5],false);
      return response.body;
    } else {
      Fluttertoast.showToast(
          msg: "success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      setUser(response.body);
      savePref(userdata[0], userdata[1], userdata[2], userdata[3], userdata[4], userdata[5],true);
      return response.body;
    }
  }

  Future register(User user) async {
    final response = await http.post(Uri.parse(CONFIG.REGISTER),
        body: {
          'name': user.name,
          'password': user.password,
          'email': user.email,
          'address': user.address,
          'phone': user.phone
        });
    if (response.body == "failed") {
      Fluttertoast.showToast(
          msg: 'Email already exist',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      savePref(user.id,user.name,user.email,user.password,user.address,user.phone,false);

      // If that call was not successful, throw an error.
//      throw Exception(response.body);
      return response.body;
    } else {
      // If the call to the server was successful, parse the JSON.
      // return User.fromJson(json.decode(response.body));
      String id =response.body.toString();
      Fluttertoast.showToast(
          msg: user.name,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      savePref(id,user.name,user.email,user.password,user.address,user.phone,true);
      return response.body;

    }
  }



  setUser(String value) async {
    await storage.write(key: 'user', value: value);
  }

  getUser() async {
    String? user = await storage.read(key: 'user');
    if (user != null) {
      return user;
    }
  }

  logout() async {
    await storage.delete(key: 'user');
    savePref("","user", "", "", "", "",false);
  }
}
